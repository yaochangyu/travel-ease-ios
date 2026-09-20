import SwiftUI

// MARK: - Design System Tokens: Colors
public enum AppColors {
    public static let primary = Color(hex: "#2563EB")
    public static let onPrimary = Color.white
    public static let secondary = Color(hex: "#3B82F6")
    public static let onSecondary = Color.black
    public static let accent = Color(hex: "#EA580C")
    public static let onAccent = Color.white
    public static let background = Color(hex: "#F8FAFC")
    public static let foreground = Color(hex: "#1E293B")
    public static let card = Color.white
    public static let cardForeground = Color(hex: "#1E293B")
    public static let muted = Color(hex: "#E9EFF8")
    public static let mutedForeground = Color(hex: "#475569")
    public static let border = Color(hex: "#E2E8F0")
    public static let destructive = Color(hex: "#DC2626")
    public static let onDestructive = Color.white
}

// MARK: - Design System Tokens: Spacing
public enum AppSpacing {
    public static let xs: CGFloat = 4
    public static let sm: CGFloat = 8
    public static let md: CGFloat = 16
    public static let lg: CGFloat = 24
    public static let xl: CGFloat = 32
    public static let xxl: CGFloat = 48
    public static let heroPadding: CGFloat = 64
}

// MARK: - Design System Tokens: Corner Radius
public enum AppCornerRadius {
    public static let sm: CGFloat = 6
    public static let md: CGFloat = 8
    public static let lg: CGFloat = 12
    public static let xl: CGFloat = 16
    public static let full: CGFloat = 9999
}

// MARK: - Design System Tokens: Typography
public enum AppTypography {
    public static let largeTitle = Font.system(size: 34, weight: .bold)
    public static let title = Font.system(size: 28, weight: .bold)
    public static let title2 = Font.system(size: 22, weight: .semibold)
    public static let title3 = Font.system(size: 20, weight: .semibold)
    public static let headline = Font.system(size: 17, weight: .semibold)
    public static let body = Font.system(size: 17, weight: .regular)
    public static let callout = Font.system(size: 16, weight: .regular)
    public static let subheadline = Font.system(size: 15, weight: .regular)
    public static let footnote = Font.system(size: 13, weight: .regular)
    public static let caption = Font.system(size: 12, weight: .regular)
}

// MARK: - SwiftUI Color Hex Extension Helper
extension Color {
    public init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - SwiftUI Button Styles
public struct PrimaryButtonStyle: ButtonStyle {
    public init() {}
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(AppTypography.headline)
            .foregroundColor(AppColors.onAccent)
            .padding(.horizontal, AppSpacing.lg)
            .padding(.vertical, AppSpacing.sm + 4)
            .background(AppColors.accent)
            .cornerRadius(AppCornerRadius.md)
            .opacity(configuration.isPressed ? 0.85 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}

public struct SecondaryButtonStyle: ButtonStyle {
    public init() {}
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(AppTypography.headline)
            .foregroundColor(AppColors.primary)
            .padding(.horizontal, AppSpacing.lg)
            .padding(.vertical, AppSpacing.sm + 4)
            .background(Color.clear)
            .overlay(
                RoundedRectangle(cornerRadius: AppCornerRadius.md)
                    .stroke(AppColors.primary, lineWidth: 2)
            )
            .opacity(configuration.isPressed ? 0.85 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}

// MARK: - Card View Modifier (Glassmorphism & Clean Card)
public struct AppCardModifier: ViewModifier {
    public init() {}
    public func body(content: Content) -> some View {
        content
            .padding(AppSpacing.lg)
            .background(AppColors.card)
            .foregroundColor(AppColors.cardForeground)
            .cornerRadius(AppCornerRadius.lg)
            .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 4)
            .overlay(
                RoundedRectangle(cornerRadius: AppCornerRadius.lg)
                    .stroke(AppColors.border, lineWidth: 1)
            )
    }
}

extension View {
    public func appCardStyle() -> some View {
        self.modifier(AppCardModifier())
    }
}
