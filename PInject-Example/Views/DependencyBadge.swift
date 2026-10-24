import SwiftUI

public struct DependencyBadge: View {
    public let text: String
    public let color: Color

    public init(_ text: String, color: Color = .blue) {
        self.text = text
        self.color = color
    }

    public var body: some View {
        Text(text)
            .font(.caption2.bold())
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(color.opacity(0.15))
            .foregroundColor(color)
            .clipShape(Capsule())
    }
}
