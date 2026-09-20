#if canImport(SwiftUI)
import SwiftUI

public struct SplashScreenView: View {
    @State private var isAnimating: Bool = false
    @State private var logoScale: CGFloat = 0.7
    @State private var logoOpacity: Double = 0.0
    @State private var textOpacity: Double = 0.0
    var onFinished: () -> Void

    public init(onFinished: @escaping () -> Void = {}) {
        self.onFinished = onFinished
    }

    public var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient(
                colors: [
                    Color(hex: "#0F172A"),
                    Color(hex: "#1E3A8A"),
                    Color(hex: "#2563EB")
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            // Subtle Background Glow Circles
            Circle()
                .fill(Color(hex: "#EA580C").opacity(0.15))
                .frame(width: 320, height: 320)
                .blur(radius: 60)
                .offset(x: isAnimating ? -60 : 60, y: isAnimating ? -100 : 100)

            Circle()
                .fill(Color(hex: "#38BDF8").opacity(0.2))
                .frame(width: 260, height: 260)
                .blur(radius: 50)
                .offset(x: isAnimating ? 80 : -80, y: isAnimating ? 120 : -120)

            VStack(spacing: AppSpacing.lg) {
                Spacer()

                // Logo Mark
                ZStack {
                    RoundedRectangle(cornerRadius: 32)
                        .fill(
                            LinearGradient(
                                colors: [Color.white, Color(hex: "#F1F5F9")],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 108, height: 108)
                        .shadow(color: Color.black.opacity(0.25), radius: 24, x: 0, y: 12)

                    // Compass & Mountain Logo Icon
                    ZStack {
                        Image(systemName: "mountain.2.fill")
                            .font(.system(size: 38))
                            .foregroundColor(AppColors.primary)
                            .offset(y: 4)

                        Image(systemName: "sparkles")
                            .font(.system(size: 20))
                            .foregroundColor(AppColors.accent)
                            .offset(x: 22, y: -22)
                    }
                }
                .scaleEffect(logoScale)
                .opacity(logoOpacity)

                // Branding Titles
                VStack(spacing: 8) {
                    Text("TravelEase")
                        .font(.system(size: 34, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                        .tracking(1.2)

                    Text("探索台灣 · 智慧隨行")
                        .font(AppTypography.headline)
                        .foregroundColor(Color.white.opacity(0.85))
                        .tracking(2.0)
                }
                .opacity(textOpacity)

                Spacer()

                // Bottom Loading Spinner / Version
                VStack(spacing: AppSpacing.sm) {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.1)

                    Text("v1.0.0 · AI 智慧旅遊引擎載入中")
                        .font(AppTypography.caption)
                        .foregroundColor(Color.white.opacity(0.6))
                }
                .padding(.bottom, AppSpacing.xl)
                .opacity(textOpacity)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.7)) {
                logoScale = 1.0
                logoOpacity = 1.0
            }
            withAnimation(.easeOut(duration: 0.8).delay(0.3)) {
                textOpacity = 1.0
            }
            withAnimation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true)) {
                isAnimating = true
            }

            // Auto advance after 2.2 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
                withAnimation(.easeInOut(duration: 0.4)) {
                    onFinished()
                }
            }
        }
    }
}
#endif
