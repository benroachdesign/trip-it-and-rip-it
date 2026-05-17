import SwiftUI
import UIKit

extension Color {
    static let appBackground = Color(uiColor: UIColor { trait in
        trait.userInterfaceStyle == .dark
            ? UIColor(red: 0.063, green: 0.071, blue: 0.071, alpha: 1)
            : UIColor(red: 0.973, green: 0.961, blue: 0.933, alpha: 1)
    })

    static let appSurface = Color(uiColor: UIColor { trait in
        trait.userInterfaceStyle == .dark
            ? UIColor(red: 0.110, green: 0.118, blue: 0.118, alpha: 1)
            : UIColor.white
    })

    static let appInk = Color(uiColor: UIColor { trait in
        trait.userInterfaceStyle == .dark
            ? UIColor(red: 0.961, green: 0.949, blue: 0.918, alpha: 1)
            : UIColor(red: 0.102, green: 0.102, blue: 0.102, alpha: 1)
    })

    static let appMuted = Color(uiColor: UIColor { trait in
        trait.userInterfaceStyle == .dark
            ? UIColor(red: 0.580, green: 0.580, blue: 0.580, alpha: 1)
            : UIColor(red: 0.420, green: 0.420, blue: 0.420, alpha: 1)
    })

    static let appAccent = Color(uiColor: UIColor { trait in
        trait.userInterfaceStyle == .dark
            ? UIColor(red: 0.341, green: 0.580, blue: 0.557, alpha: 1)
            : UIColor(red: 0.122, green: 0.227, blue: 0.227, alpha: 1)
    })

    static let appDivider = Color(uiColor: UIColor { trait in
        trait.userInterfaceStyle == .dark
            ? UIColor(white: 1, alpha: 0.08)
            : UIColor(white: 0, alpha: 0.08)
    })
}
