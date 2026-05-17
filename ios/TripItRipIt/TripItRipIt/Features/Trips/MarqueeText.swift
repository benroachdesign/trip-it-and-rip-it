import SwiftUI

struct MarqueeText: View {
    let text: String
    var speed: CGFloat = 18
    var spacing: CGFloat = 40

    @State private var textWidth: CGFloat = 0

    var body: some View {
        Color.clear
            .frame(height: 20)
            .frame(maxWidth: .infinity)
            .overlay(alignment: .leading) { marqueeContent }
            .clipped()
            .mask(
                LinearGradient(
                    stops: [
                        .init(color: .clear, location: 0),
                        .init(color: .black, location: 0.04),
                        .init(color: .black, location: 0.96),
                        .init(color: .clear, location: 1)
                    ],
                    startPoint: .leading, endPoint: .trailing
                )
            )
    }

    private var marqueeContent: some View {
        TimelineView(.animation) { context in
            let elapsed = context.date.timeIntervalSinceReferenceDate
            let loopDistance = textWidth + spacing
            let offset: CGFloat = loopDistance > 0
                ? -CGFloat((elapsed * Double(speed)).truncatingRemainder(dividingBy: Double(loopDistance)))
                : 0

            HStack(spacing: spacing) {
                Text(text)
                    .fixedSize()
                    .background(WidthReader { width in
                        if abs(width - textWidth) > 0.5 { textWidth = width }
                    })
                Text(text)
                    .fixedSize()
            }
            .offset(x: offset)
        }
    }
}

private struct WidthReader: View {
    let onChange: (CGFloat) -> Void

    var body: some View {
        GeometryReader { proxy in
            Color.clear
                .onAppear { onChange(proxy.size.width) }
                .onChange(of: proxy.size.width) { _, new in onChange(new) }
        }
    }
}
