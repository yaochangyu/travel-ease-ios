#if canImport(SwiftUI)
import SwiftUI

// MARK: - TravelEase Design System Tokens
public enum AppColors {
    public static let primary = Color(hex: "#2563EB")       // 蔚藍 (Brand Trust)
    public static let onPrimary = Color.white
    public static let secondary = Color(hex: "#0EA5E9")     // 天空藍
    public static let accent = Color(hex: "#EA580C")        // 日落珊瑚橘 (High-contrast CTA)
    public static let onAccent = Color.white
    public static let background = Color(hex: "#F8FAFC")    // 淺灰背景
    public static let cardBg = Color.white                  // 卡片底色
    public static let foreground = Color(hex: "#0F172A")    // 標題字色
    public static let bodyText = Color(hex: "#334155")      // 內文字色
    public static let muted = Color(hex: "#E2E8F0")         // 次要分隔線
    public static let mutedText = Color(hex: "#64748B")     // 輔助說明字色
    public static let success = Color(hex: "#10B981")       // 翠綠成功色
    public static let starGold = Color(hex: "#F59E0B")      // 評分金黃色
}

public enum AppSpacing {
    public static let xs: CGFloat = 4
    public static let sm: CGFloat = 8
    public static let md: CGFloat = 16
    public static let lg: CGFloat = 24
    public static let xl: CGFloat = 32
    public static let xxl: CGFloat = 48
}

public enum AppCornerRadius {
    public static let sm: CGFloat = 8
    public static let md: CGFloat = 12
    public static let lg: CGFloat = 16
    public static let xl: CGFloat = 24
    public static let full: CGFloat = 999
}

public enum AppTypography {
    public static let largeTitle = Font.system(size: 32, weight: .bold)
    public static let title = Font.system(size: 24, weight: .bold)
    public static let title2 = Font.system(size: 20, weight: .semibold)
    public static let headline = Font.system(size: 17, weight: .semibold)
    public static let body = Font.system(size: 15, weight: .regular)
    public static let callout = Font.system(size: 14, weight: .medium)
    public static let subheadline = Font.system(size: 13, weight: .regular)
    public static let caption = Font.system(size: 12, weight: .regular)
    public static let captionBold = Font.system(size: 12, weight: .semibold)
}

// MARK: - Color Extension Helper
extension Color {
    public init(hex: String) {
        let cleanHex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: cleanHex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch cleanHex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Reusable View Modifiers
public struct AppCardModifier: ViewModifier {
    public init() {}
    public func body(content: Content) -> some View {
        content
            .background(AppColors.cardBg)
            .cornerRadius(AppCornerRadius.lg)
            .shadow(color: Color.black.opacity(0.06), radius: 10, x: 0, y: 4)
            .overlay(
                RoundedRectangle(cornerRadius: AppCornerRadius.lg)
                    .stroke(AppColors.muted.opacity(0.6), lineWidth: 1)
            )
    }
}

extension View {
    public func appCard() -> some View {
        self.modifier(AppCardModifier())
    }
}
#endif
