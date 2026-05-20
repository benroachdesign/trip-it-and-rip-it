import CoreImage
import SwiftUI
import UIKit

/// Tileable monochrome noise overlay, produced once via CoreImage and
/// cached. Applied at low opacity over hero photography for a subtle
/// editorial / film texture.
struct FilmGrainOverlay: View {
    var opacity: Double = 0.05

    private static let texture: UIImage = {
        let size = CGSize(width: 256, height: 256)
        guard let filter = CIFilter(name: "CIRandomGenerator"),
              let output = filter.outputImage?.cropped(to: CGRect(origin: .zero, size: size))
        else {
            return UIImage()
        }
        let ctx = CIContext()
        guard let cg = ctx.createCGImage(output, from: output.extent) else {
            return UIImage()
        }
        return UIImage(cgImage: cg)
    }()

    var body: some View {
        Image(uiImage: Self.texture)
            .resizable(resizingMode: .tile)
            .opacity(opacity)
            .allowsHitTesting(false)
            .blendMode(.overlay)
    }
}

extension View {
    /// Adds a subtle film-grain texture overlay. Intended for hero photos
    /// only — not for surfaces of solid color.
    func filmGrain(opacity: Double = 0.05) -> some View {
        self.overlay(FilmGrainOverlay(opacity: opacity))
    }
}
