import Foundation
import Supabase

enum SupabaseService {
    static let client = SupabaseClient(
        supabaseURL: SupabaseConfig.url,
        supabaseKey: SupabaseConfig.publishableKey,
        options: SupabaseClientOptions(
            db: SupabaseClientOptions.DatabaseOptions(decoder: postgrestDecoder)
        )
    )

    /// PostgREST returns `date` columns as bare `"yyyy-MM-dd"` strings, which the
    /// SDK's default decoder rejects (it only accepts ISO-8601 timestamps *with* a
    /// time component). This decoder accepts full timestamps and date-only values,
    /// so `date` columns like `trips.start_date` decode into `Date`.
    private static let postgrestDecoder: JSONDecoder = {
        let decoder = JSONDecoder()

        let timestampFractional = ISO8601DateFormatter()
        timestampFractional.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        let timestamp = ISO8601DateFormatter()
        timestamp.formatOptions = [.withInternetDateTime]

        let dateOnly = DateFormatter()
        dateOnly.calendar = Calendar(identifier: .iso8601)
        dateOnly.locale = Locale(identifier: "en_US_POSIX")
        dateOnly.timeZone = TimeZone(identifier: "UTC")
        dateOnly.dateFormat = "yyyy-MM-dd"

        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let string = try container.decode(String.self)
            if let date = timestampFractional.date(from: string) { return date }
            if let date = timestamp.date(from: string) { return date }
            if let date = dateOnly.date(from: string) { return date }
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Unrecognized date format: \(string)"
            )
        }
        return decoder
    }()
}
