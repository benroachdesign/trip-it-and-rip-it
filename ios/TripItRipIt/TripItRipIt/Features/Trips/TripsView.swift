import Supabase
import SwiftUI
import UIKit

struct TripsView: View {
    @State private var trips: [Trip] = []
    @State private var loadError: String?

    var body: some View {
        Group {
            if let loadError {
                ContentUnavailableView(
                    "Couldn't load trips",
                    systemImage: "calendar.badge.exclamationmark",
                    description: Text(loadError)
                )
            } else if trips.isEmpty {
                ProgressView().controlSize(.large)
            } else {
                ScrollView {
                    LazyVStack(spacing: Spacing.lg) {
                        ForEach(trips) { trip in
                            NavigationLink(value: trip) {
                                TripYearCard(
                                    trip: trip,
                                    featuredCourseName: Trip.mockFeaturedCourse(for: trip.id),
                                    heroCourse: Trip.mockHeroCourse(for: trip.id),
                                    courseNames: Trip.mockCourseNames(for: trip.id)
                                )
                            }
                            .buttonStyle(.plain)
                            .hapticOnTap(.soft)
                        }
                    }
                    .padding(.horizontal, Spacing.lg)
                    .padding(.vertical, Spacing.md)
                }
                .refreshable { await load() }
                .background(Color.appBackground)
                .navigationDestination(for: Trip.self) { trip in
                    TripDetailView(trip: trip)
                }
                .navigationDestination(for: Course.self) { course in
                    CourseDetailView(course: course)
                }
            }
        }
        .background(Color.appBackground)
        .navigationTitle("Trips")
        .navigationBarTitleDisplayMode(.inline)
        .task { await load() }
    }

    private func load() async {
        if AppEnvironment.bypassAuth {
            trips = Trip.mockTrips
            return
        }
        if trips.isEmpty, let cached = LocalCache.load([Trip].self, forKey: CacheKey.trips) {
            trips = cached
        }
        do {
            let fresh: [Trip] = try await SupabaseService.client
                .from("trips")
                .select("id, year, trip_title, location_city, location_state, start_date, end_date, winning_team_id, hero_photo_url, blurb")
                .order("year", ascending: false)
                .execute()
                .value
            trips = fresh
            LocalCache.save(fresh, forKey: CacheKey.trips)
            loadError = nil
        } catch {
            if trips.isEmpty {
                loadError = error.localizedDescription
            }
        }
    }
}

private struct TripYearCard: View {
    let trip: Trip
    let featuredCourseName: String?
    let heroCourse: Course?
    let courseNames: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            heroSection
            Rectangle()
                .fill(Color.appDivider)
                .frame(height: 1)
            infoSection
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.appSurface)
        .clipShape(RoundedRectangle(cornerRadius: Radius.lg))
        .overlay(
            RoundedRectangle(cornerRadius: Radius.lg)
                .stroke(Color.appDivider, lineWidth: 1)
        )
    }

    private var heroSection: some View {
        heroImage
            .filmGrain()
            .frame(maxWidth: .infinity)
            .frame(height: 180)
            .clipped()
    }

    @ViewBuilder
    private var heroImage: some View {
        if let assetName = heroCourse?.photoAssetName, UIImage(named: assetName) != nil {
            Image(assetName)
                .resizable()
                .scaledToFill()
        } else if let urlString = heroCourse?.heroPhotoUrl ?? trip.heroPhotoUrl,
                  let url = URL(string: urlString) {
            AsyncImage(url: url) { phase in
                switch phase {
                case .success(let image):
                    image.resizable().scaledToFill()
                default:
                    placeholderHero
                }
            }
        } else {
            placeholderHero
        }
    }

    private var placeholderHero: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color.appAccent,
                    Color.appAccent.opacity(0.75)
                ],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
            if let featured = featuredCourseName {
                Text(featured)
                    .font(AppFont.display(26, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.55))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, Spacing.lg)
            }
        }
    }

    private var infoSection: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            VStack(alignment: .leading, spacing: 8) {
                Text(String(trip.year))
                    .font(AppFont.display(48, weight: .bold))
                    .foregroundStyle(Color.appAccent)
                    .monospacedDigit()
                    .lineLimit(1)
                HStack(spacing: 10) {
                    Text(trip.locationDisplay.uppercased())
                        .font(AppFont.caption.weight(.semibold))
                        .tracking(2)
                        .foregroundStyle(Color.appMuted)
                        .lineLimit(1)
                        .minimumScaleFactor(0.85)
                    if let dateRange = trip.dateRangeDisplay {
                        Text("·")
                            .font(AppFont.caption.weight(.semibold))
                            .foregroundStyle(Color.appMuted)
                        Text(dateRange.uppercased())
                            .font(AppFont.caption.weight(.semibold))
                            .tracking(2)
                            .foregroundStyle(Color.appMuted)
                            .lineLimit(1)
                    }
                }
            }
            if !courseNames.isEmpty {
                MarqueeText(text: courseNames.joined(separator: "  ·  "))
                    .font(AppFont.caption)
                    .foregroundStyle(Color.appMuted)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, Spacing.lg)
        .padding(.vertical, Spacing.md)
    }
}
