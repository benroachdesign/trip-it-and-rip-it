import Foundation

enum LocalCache {
    static let directoryName = "TripItRipItCache"

    private static var directoryURL: URL? {
        guard let appSupport = FileManager.default.urls(
            for: .applicationSupportDirectory, in: .userDomainMask
        ).first else { return nil }
        let dir = appSupport.appendingPathComponent(directoryName, isDirectory: true)
        if !FileManager.default.fileExists(atPath: dir.path) {
            try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        }
        return dir
    }

    private static func fileURL(for key: String) -> URL? {
        directoryURL?.appendingPathComponent("\(key).json")
    }

    private static var encoder: JSONEncoder {
        let e = JSONEncoder()
        e.dateEncodingStrategy = .iso8601
        return e
    }

    private static var decoder: JSONDecoder {
        let d = JSONDecoder()
        d.dateDecodingStrategy = .iso8601
        return d
    }

    static func save<T: Encodable>(_ value: T, forKey key: String) {
        guard let url = fileURL(for: key) else { return }
        do {
            let data = try encoder.encode(value)
            try data.write(to: url, options: .atomic)
        } catch {
            print("LocalCache save(\(key)) failed: \(error)")
        }
    }

    static func load<T: Decodable>(_ type: T.Type, forKey key: String) -> T? {
        guard let url = fileURL(for: key),
              let data = try? Data(contentsOf: url) else { return nil }
        do {
            return try decoder.decode(type, from: data)
        } catch {
            print("LocalCache load(\(key)) failed: \(error)")
            return nil
        }
    }
}

enum CacheKey {
    static let trips = "trips"
    static let members = "members"
}
