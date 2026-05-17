import Supabase
import SwiftUI

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
                                    featuredCoursePhotoUrl: Trip.mockFeaturedCoursePhoto(for: trip.id),
                                    courseNames: Trip.mockCourseNames(for: trip.id)
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, Spacing.lg)
                    .padding(.vertical, Spacing.md)
                }
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
        do {
            trips = try await SupabaseService.client
                .from("trips")
                .select("id, year, trip_title, location_city, location_state, start_date, end_date, winning_team_id, hero_photo_url, blurb")
                .order("year", ascending: false)
                .execute()
                .value
        } catch {
            loadError = error.localizedDescription
        }
    }
}

private struct TripYearCard: View {
    let trip: Trip
    let featuredCourseName: String?
    let featuredCoursePhotoUrl: String?
    let courseNames: [String]

    private var resolvedHeroUrl: String? {
        trip.heroPhotoUrl ?? featuredCoursePhotoUrl
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            heroSection
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
        ZStack(alignment: .bottomLeading) {
            heroImage
            LinearGradient(
                colors: [.clear, .black.opacity(0.55)],
                startPoint: .center, endPoint: .bottom
            )
            Text(String(trip.year))
                .font(AppFont.display(56, weight: .bold))
                .foregroundStyle(.white)
                .monospacedDigit()
                .shadow(color: .black.opacity(0.25), radius: 6, y: 2)
                .padding(.horizontal, Spacing.lg)
                .padding(.bottom, Spacing.md)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 180)
        .clipped()
    }

    @ViewBuilder
    private var heroImage: some View {
        if let urlString = resolvedHeroUrl, let url = URL(string: urlString) {
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
        VStack(alignment: .leading, spacing: Spacing.sm) {
            VStack(alignment: .leading, spacing: 2) {
                Text(trip.locationDisplay)
                    .font(AppFont.sectionHeader)
                    .foregroundStyle(Color.appInk)
                if let dateRange = trip.dateRangeDisplay {
                    Text(dateRange)
                        .font(AppFont.footnote)
                        .foregroundStyle(Color.appMuted)
                }
            }
            if !courseNames.isEmpty {
                MarqueeText(text: courseNames.joined(separator: "  ·  ") + "   •  •  •  ")
                    .font(AppFont.caption)
                    .foregroundStyle(Color.appMuted)
                    .padding(.top, Spacing.xs)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Spacing.lg)
    }
}
