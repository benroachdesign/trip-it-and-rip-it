import MapKit
import SwiftUI

struct BandonMapCard: View {
    private let resortCenter = CLLocationCoordinate2D(latitude: 43.0900, longitude: -124.4130)

    @State private var position: MapCameraPosition

    init() {
        let initialRegion = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 43.0900, longitude: -124.4130),
            span: MKCoordinateSpan(latitudeDelta: 0.030, longitudeDelta: 0.030)
        )
        _position = State(initialValue: .region(initialRegion))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            HStack {
                Text("BANDON DUNES RESORT")
                    .font(AppFont.body(11, weight: .semibold))
                    .tracking(2)
                    .foregroundStyle(Color.homeMuted)
                Spacer()
                if let url = MapsLink.url(for: "Bandon Dunes Resort, Bandon, OR") {
                    Link(destination: url) {
                        HStack(spacing: 4) {
                            Text("OPEN IN MAPS")
                                .font(AppFont.body(10, weight: .semibold))
                                .tracking(1.5)
                            Image(systemName: "arrow.up.right")
                                .font(.system(size: 9, weight: .semibold))
                                .accessibilityHidden(true)
                        }
                        .foregroundStyle(Color.homeAccent)
                    }
                    .hapticOnTap(.soft)
                    .accessibilityHint("Opens Bandon Dunes Resort in Maps")
                }
            }
            Map(position: $position) {
                Marker("Lily Pond Rooms", systemImage: "house.lodge.fill",
                       coordinate: CLLocationCoordinate2D(latitude: 43.0870, longitude: -124.4108))
                    .tint(Color.homeAccent)
                ForEach(BandonMapLocation.courses) { loc in
                    Marker(loc.name, systemImage: "flag.fill", coordinate: loc.coordinate)
                        .tint(.white)
                }
            }
            .mapStyle(.hybrid(elevation: .realistic))
            .mapControlVisibility(.hidden)
            .frame(height: 220)
            .clipShape(RoundedRectangle(cornerRadius: Radius.lg))
            .overlay(
                RoundedRectangle(cornerRadius: Radius.lg)
                    .stroke(Color.homeDivider, lineWidth: 1)
            )
        }
    }
}

struct BandonMapLocation: Identifiable {
    let id: String
    let name: String
    let coordinate: CLLocationCoordinate2D

    static let courses: [BandonMapLocation] = [
        BandonMapLocation(id: "pacific-dunes",   name: "Pacific Dunes",
                          coordinate: CLLocationCoordinate2D(latitude: 43.0915, longitude: -124.4168)),
        BandonMapLocation(id: "bandon-dunes",    name: "Bandon Dunes",
                          coordinate: CLLocationCoordinate2D(latitude: 43.0895, longitude: -124.4142)),
        BandonMapLocation(id: "old-macdonald",   name: "Old Macdonald",
                          coordinate: CLLocationCoordinate2D(latitude: 43.0945, longitude: -124.4115)),
        BandonMapLocation(id: "sheep-ranch",     name: "Sheep Ranch",
                          coordinate: CLLocationCoordinate2D(latitude: 43.0995, longitude: -124.4200)),
        BandonMapLocation(id: "bandon-trails",   name: "Bandon Trails",
                          coordinate: CLLocationCoordinate2D(latitude: 43.0815, longitude: -124.4060)),
        BandonMapLocation(id: "bandon-preserve", name: "Bandon Preserve",
                          coordinate: CLLocationCoordinate2D(latitude: 43.0825, longitude: -124.4170)),
        BandonMapLocation(id: "shortys",         name: "Shorty's",
                          coordinate: CLLocationCoordinate2D(latitude: 43.0885, longitude: -124.4090))
    ]
}
