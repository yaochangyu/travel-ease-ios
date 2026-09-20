#if canImport(SwiftUI)
import SwiftUI

public struct TravelMapView: View {
    @Bindable var viewModel: TravelViewModel

    public init(viewModel: TravelViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        ZStack(alignment: .bottom) {
            // Simulated Map Canvas
            ZStack {
                Color(hex: "#E0F2FE")
                    .ignoresSafeArea()

                VStack(spacing: 20) {
                    Image(systemName: "map.fill")
                        .font(.system(size: 64))
                        .foregroundColor(AppColors.primary.opacity(0.3))
                    Text("📍 正在探索台灣即時周邊景點")
                        .font(AppTypography.headline)
                        .foregroundColor(AppColors.primary)
                }

                // Simulated Map Pins
                ForEach(viewModel.attractions) { attr in
                    Button(action: {
                        viewModel.activeDetailAttraction = attr
                    }) {
                        VStack(spacing: 2) {
                            Text(attr.name)
                                .font(AppTypography.captionBold)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.white)
                                .cornerRadius(AppCornerRadius.sm)
                                .shadow(radius: 2)
                            Image(systemName: "mappin.circle.fill")
                                .font(.system(size: 30))
                                .foregroundColor(AppColors.accent)
                        }
                    }
                }
            }

            // Bottom Floating Attraction Slider
            VStack(alignment: .leading, spacing: 8) {
                Text("周邊推薦探索")
                    .font(AppTypography.headline)
                    .foregroundColor(AppColors.foreground)
                    .padding(.horizontal, AppSpacing.md)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: AppSpacing.md) {
                        ForEach(viewModel.attractions) { attr in
                            Button(action: {
                                viewModel.activeDetailAttraction = attr
                            }) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(attr.name)
                                        .font(AppTypography.headline)
                                        .foregroundColor(AppColors.foreground)
                                    Text(attr.subtitle)
                                        .font(AppTypography.caption)
                                        .foregroundColor(AppColors.mutedText)
                                        .lineLimit(1)
                                    HStack {
                                        Text("⭐ \(String(format: "%.1f", attr.rating))")
                                            .font(AppTypography.captionBold)
                                            .foregroundColor(AppColors.starGold)
                                        Spacer()
                                        Text(attr.ticketPrice)
                                            .font(AppTypography.caption)
                                            .foregroundColor(AppColors.primary)
                                    }
                                }
                                .frame(width: 200)
                                .padding(12)
                                .background(Color.white)
                                .cornerRadius(AppCornerRadius.md)
                                .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal, AppSpacing.md)
                    .padding(.bottom, AppSpacing.lg)
                }
            }
            .padding(.top, 12)
            .background(
                LinearGradient(
                    colors: [Color.white.opacity(0), Color.white.opacity(0.95), Color.white],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
        }
        .navigationTitle("周邊地圖")
        .inlineTitleDisplayMode()
    }
}

public struct ProfileView: View {
    @Bindable var viewModel: TravelViewModel

    public init(viewModel: TravelViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.lg) {
                // User Header Card
                HStack(spacing: AppSpacing.md) {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [AppColors.primary, AppColors.secondary],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 64, height: 64)
                        .overlay(
                            Image(systemName: "person.fill")
                                .font(.system(size: 28))
                                .foregroundColor(.white)
                        )

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Yao Chang")
                            .font(AppTypography.title2)
                            .foregroundColor(AppColors.foreground)
                        Text("台灣深度探索家 · Level 4")
                            .font(AppTypography.caption)
                            .foregroundColor(AppColors.mutedText)
                    }
                    Spacer()
                }
                .padding(AppSpacing.md)
                .appCard()
                .padding(.horizontal, AppSpacing.md)
                .padding(.top, AppSpacing.md)

                // Stats Grid
                HStack(spacing: AppSpacing.md) {
                    StatBox(title: "已去過景點", value: "24 處", icon: "checkmark.seal.fill", color: AppColors.primary)
                    StatBox(title: "規劃中行程", value: "2 趟", icon: "calendar.badge.clock", color: AppColors.accent)
                    StatBox(title: "已收藏秘境", value: "\(viewModel.attractions.filter { $0.isSaved }.count) 個", icon: "heart.fill", color: .red)
                }
                .padding(.horizontal, AppSpacing.md)

                // Saved Attractions Section
                VStack(alignment: .leading, spacing: AppSpacing.sm) {
                    Text("我的收藏清單")
                        .font(AppTypography.headline)
                        .foregroundColor(AppColors.foreground)
                        .padding(.horizontal, AppSpacing.md)

                    let savedList = viewModel.attractions.filter { $0.isSaved }
                    if savedList.isEmpty {
                        Text("尚未收藏任何景點，快去探索頁尋找喜愛的秘境吧！")
                            .font(AppTypography.body)
                            .foregroundColor(AppColors.mutedText)
                            .padding(.horizontal, AppSpacing.md)
                    } else {
                        ForEach(savedList) { item in
                            AttractionCardRow(attraction: item, onSelect: {
                                viewModel.activeDetailAttraction = item
                            }, onToggleSave: {
                                viewModel.toggleSaved(for: item.id)
                            })
                            .padding(.horizontal, AppSpacing.md)
                        }
                    }
                }
            }
            .padding(.bottom, AppSpacing.xxl)
        }
        .background(AppColors.background)
        .navigationTitle("個人中心")
        .inlineTitleDisplayMode()
    }
}

struct StatBox: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(color)
            Text(value)
                .font(AppTypography.headline)
                .foregroundColor(AppColors.foreground)
            Text(title)
                .font(AppTypography.caption)
                .foregroundColor(AppColors.mutedText)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .appCard()
    }
}
#endif
