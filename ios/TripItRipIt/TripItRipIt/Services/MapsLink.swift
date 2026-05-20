import Foundation

/// Builds Apple Maps universal-link URLs that open the system map app
/// with a pre-populated search query.
enum MapsLink {
    static func url(for query: String) -> URL? {
        var components = URLComponents(string: "https://maps.apple.com/")
        components?.queryItems = [URLQueryItem(name: "q", value: query)]
        return components?.url
    }
}
