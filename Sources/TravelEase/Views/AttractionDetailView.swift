#if canImport(SwiftUI)
import SwiftUI

public struct AttractionDetailView: View {
    let attraction: Attraction
    @Bindable var viewModel: TravelViewModel
    @Environment(\.dismiss) private var dismiss

    public init(attraction: Attraction, viewModel: TravelViewModel) {
        self.attraction = attraction
        self.viewModel = viewModel
    }

    public var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(alignment: .leading, spacing: AppSpacing.md) {
                    // Hero Image Banner
                    ZStack(alignment: .topLeading) {
                        RoundedRectangle(cornerRadius: 0)
                            .fill(
                                LinearGradient(
                                    colors: [Color(hex: "#1E3A8A"), Color(hex: "#2563EB"), Color(hex: "#38BDF8")],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(height: 280)

                        VStack {
                            HStack {
                                Button(action: { dismiss() }) {
                                    Image(systemName: "xmark")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(AppColors.foreground)
                                        .padding(10)
                                        .background(Color.white.opacity(0.9))
                                        .clipShape(Circle())
                                }
                                Spacer()
                                Button(action: {
                                    viewModel.toggleSaved(for: attraction.id)
                                }) {
                                    Image(systemName: attraction.isSaved ? "heart.fill" : "heart")
                                        .font(.system(size: 18))
                                        .foregroundColor(attraction.isSaved ? .red : AppColors.foreground)
                                        .padding(10)
                                        .background(Color.white.opacity(0.9))
                                        .clipShape(Circle())
                                }
                            }
                            .padding(.horizontal, AppSpacing.md)
                            .padding(.top, AppSpacing.lg)
                            Spacer()
                        }
                    }

                    VStack(alignment: .leading, spacing: AppSpacing.md) {
                        // Title & Tags
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text(attraction.name)
                                    .font(AppTypography.largeTitle)
                                    .foregroundColor(AppColors.foreground)
                                Spacer()
                            }
                            Text(attraction.subtitle)
                                .font(AppTypography.body)
                                .foregroundColor(AppColors.mutedText)

                            // Tag Pills
                            HStack(spacing: 6) {
                                ForEach(attraction.tags, id: \.self) { tag in
                                    Text("# \(tag)")
                                        .font(AppTypography.captionBold)
                                        .foregroundColor(AppColors.primary)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(AppColors.primary.opacity(0.08))
                                        .cornerRadius(AppCornerRadius.sm)
                                }
                            }
                            .padding(.top, 4)
                        }

                        // Info Quick Grid
                        HStack(spacing: AppSpacing.sm) {
                            DetailInfoChip(title: "旅人評分", value: "⭐ \(String(format: "%.1f", attraction.rating))", subtitle: "(\(attraction.reviewCount)+ 評論)")
                            DetailInfoChip(title: "營業時間", value: "營業中", subtitle: attraction.openingHours)
                            DetailInfoChip(title: "門票價格", value: attraction.ticketPrice, subtitle: attraction.estimatedStayTime)
                        }

                        // Audio Guide Banner
                        HStack(spacing: AppSpacing.md) {
                            Image(systemName: "headphones.circle.fill")
                                .font(.system(size: 36))
                                .foregroundColor(AppColors.accent)
                            VStack(alignment: .leading, spacing: 2) {
                                Text("隨身智慧語音導覽")
                                    .font(AppTypography.headline)
                                    .foregroundColor(AppColors.foreground)
                                Text("點擊聆聽專業在地歷史故事與導覽 (3:45)")
                                    .font(AppTypography.caption)
                                    .foregroundColor(AppColors.mutedText)
                            }
                            Spacer()
                            Image(systemName: "play.circle.fill")
                                .font(.system(size: 32))
                                .foregroundColor(AppColors.primary)
                        }
                        .padding(14)
                        .background(AppColors.accent.opacity(0.08))
                        .cornerRadius(AppCornerRadius.md)

                        // Description
                        VStack(alignment: .leading, spacing: 6) {
                            Text("景點介紹")
                                .font(AppTypography.title2)
                                .foregroundColor(AppColors.foreground)
                            Text(attraction.description)
                                .font(AppTypography.body)
                                .foregroundColor(AppColors.bodyText)
                                .lineSpacing(4)
                        }

                        // Location
                        VStack(alignment: .leading, spacing: 6) {
                            Text("地理位置")
                                .font(AppTypography.title2)
                                .foregroundColor(AppColors.foreground)
                            Label(attraction.location, systemImage: "mappin.and.ellipse")
                                .font(AppTypography.callout)
                                .foregroundColor(AppColors.mutedText)
                        }
                    }
                    .padding(.horizontal, AppSpacing.md)
                    .padding(.bottom, 120) // space for bottom floating bar
                }
            }
            .ignoresSafeArea(edges: .top)

            // Bottom Sticky Action Bar
            HStack(spacing: AppSpacing.md) {
                Button(action: {
                    viewModel.addAttractionToDaySchedule(attraction: attraction, dayIndex: viewModel.selectedDayIndex)
                }) {
                    HStack {
                        Image(systemName: "calendar.badge.plus")
                        Text("加入行程 (Day \(viewModel.selectedDayIndex + 1))")
                    }
                    .font(AppTypography.headline)
                    .foregroundColor(AppColors.primary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: AppCornerRadius.md)
                            .stroke(AppColors.primary, lineWidth: 2)
                    )
                    .cornerRadius(AppCornerRadius.md)
                }

                Button(action: {
                    viewModel.showToastMessage("已為您開啟 Apple 地圖導航！")
                }) {
                    HStack {
                        Image(systemName: "location.fill")
                        Text("立即導航")
                    }
                    .font(AppTypography.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(AppColors.accent)
                    .cornerRadius(AppCornerRadius.md)
                    .shadow(color: AppColors.accent.opacity(0.3), radius: 8, x: 0, y: 4)
                }
            }
            .padding(.horizontal, AppSpacing.md)
            .padding(.vertical, 12)
            .background(Color.white)
            .shadow(color: Color.black.opacity(0.08), radius: 10, x: 0, y: -4)
        }
    }
}

struct DetailInfoChip: View {
    let title: String
    let value: String
    let subtitle: String

    var body: some View {
        VStack(spacing: 3) {
            Text(title)
                .font(AppTypography.caption)
                .foregroundColor(AppColors.mutedText)
            Text(value)
                .font(AppTypography.headline)
                .foregroundColor(AppColors.foreground)
            Text(subtitle)
                .font(.system(size: 10))
                .foregroundColor(AppColors.mutedText)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(AppColors.background)
        .cornerRadius(AppCornerRadius.sm)
    }
}
#endif
