#if canImport(SwiftUI)
import SwiftUI

public struct DiscoverView: View {
    @Bindable var viewModel: TravelViewModel

    public init(viewModel: TravelViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.lg) {
                // MARK: - Header Search & Greeting
                headerSection

                // MARK: - Category Filter Pills
                categorySection

                // MARK: - Hero Featured Destination Carousel
                featuredSection

                // MARK: - Popular Attractions Grid/List
                popularSection
            }
            .padding(.bottom, AppSpacing.xxl)
        }
        .background(AppColors.background)
        .navigationTitle("探索台灣美景")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Subviews
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("早安，探索者 🌄")
                        .font(AppTypography.caption)
                        .foregroundColor(AppColors.mutedText)
                    Text("今天要出發去哪裡？")
                        .font(AppTypography.title)
                        .foregroundColor(AppColors.foreground)
                }
                Spacer()
                Button(action: {}) {
                    Image(systemName: "bell.badge")
                        .font(.system(size: 18))
                        .foregroundColor(AppColors.foreground)
                        .padding(10)
                        .background(Color.white)
                        .clipShape(Circle())
                        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                }
            }
            .padding(.horizontal, AppSpacing.md)
            .padding(.top, AppSpacing.sm)

            // Search Bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(AppColors.mutedText)
                TextField("搜尋景點、城市、私房秘境...", text: $viewModel.searchText)
                    .font(AppTypography.body)
                if !viewModel.searchText.isEmpty {
                    Button(action: { viewModel.searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(AppColors.mutedText)
                    }
                }
            }
            .padding(12)
            .background(Color.white)
            .cornerRadius(AppCornerRadius.md)
            .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)
            .padding(.horizontal, AppSpacing.md)
        }
    }

    private var categorySection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: AppSpacing.sm) {
                ForEach(viewModel.categories) { category in
                    Button(action: {
                        withAnimation(.spring(duration: 0.25)) {
                            viewModel.selectedCategory = category.id
                        }
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: category.iconName)
                                .font(.system(size: 13))
                            Text(category.name)
                                .font(AppTypography.callout)
                        }
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(
                            viewModel.selectedCategory == category.id ?
                            AppColors.primary : Color.white
                        )
                        .foregroundColor(
                            viewModel.selectedCategory == category.id ?
                            Color.white : AppColors.bodyText
                        )
                        .cornerRadius(AppCornerRadius.full)
                        .shadow(color: Color.black.opacity(0.03), radius: 4, x: 0, y: 2)
                    }
                }
            }
            .padding(.horizontal, AppSpacing.md)
        }
    }

    private var featuredSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text("本週精選推薦")
                .font(AppTypography.title2)
                .foregroundColor(AppColors.foreground)
                .padding(.horizontal, AppSpacing.md)

            if let hero = viewModel.attractions.first {
                Button(action: {
                    viewModel.activeDetailAttraction = hero
                }) {
                    ZStack(alignment: .bottomLeading) {
                        // Hero background representation
                        RoundedRectangle(cornerRadius: AppCornerRadius.lg)
                            .fill(
                                LinearGradient(
                                    colors: [Color(hex: "#1E3A8A"), Color(hex: "#2563EB")],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(height: 200)

                        // Content overlay
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text("⭐ 4.9 旅人超好評")
                                    .font(AppTypography.captionBold)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(AppColors.accent)
                                    .foregroundColor(.white)
                                    .cornerRadius(AppCornerRadius.sm)
                                Spacer()
                            }
                            Spacer()
                            Text(hero.name)
                                .font(AppTypography.title)
                                .foregroundColor(.white)
                            Text(hero.subtitle)
                                .font(AppTypography.subheadline)
                                .foregroundColor(Color.white.opacity(0.85))
                                .lineLimit(1)
                            HStack {
                                Label(hero.location, systemImage: "mappin.and.ellipse")
                                    .font(AppTypography.caption)
                                    .foregroundColor(Color.white.opacity(0.8))
                                Spacer()
                                Text("立即探索 →")
                                    .font(AppTypography.callout)
                                    .foregroundColor(AppColors.accent)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 4)
                                    .background(Color.white)
                                    .cornerRadius(AppCornerRadius.sm)
                            }
                        }
                        .padding(AppSpacing.md)
                    }
                    .padding(.horizontal, AppSpacing.md)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }

    private var popularSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            HStack {
                Text("熱門景點清單")
                    .font(AppTypography.title2)
                    .foregroundColor(AppColors.foreground)
                Spacer()
                Text("共 \(viewModel.filteredAttractions.count) 處")
                    .font(AppTypography.caption)
                    .foregroundColor(AppColors.mutedText)
            }
            .padding(.horizontal, AppSpacing.md)

            LazyVStack(spacing: AppSpacing.md) {
                ForEach(viewModel.filteredAttractions) { item in
                    AttractionCardRow(attraction: item, onSelect: {
                        viewModel.activeDetailAttraction = item
                    }, onToggleSave: {
                        viewModel.toggleSaved(for: item.id)
                    })
                }
            }
            .padding(.horizontal, AppSpacing.md)
        }
    }
}

// MARK: - Attraction Card Row Component
struct AttractionCardRow: View {
    let attraction: Attraction
    let onSelect: () -> Void
    let onToggleSave: () -> Void

    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: AppSpacing.md) {
                // Image box placeholder/view
                ZStack {
                    RoundedRectangle(cornerRadius: AppCornerRadius.md)
                        .fill(Color(hex: "#3B82F6").opacity(0.15))
                        .frame(width: 90, height: 90)
                    Image(systemName: "photo.artframe")
                        .font(.system(size: 28))
                        .foregroundColor(AppColors.primary)
                }

                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(attraction.name)
                            .font(AppTypography.headline)
                            .foregroundColor(AppColors.foreground)
                        Spacer()
                        Button(action: onToggleSave) {
                            Image(systemName: attraction.isSaved ? "heart.fill" : "heart")
                                .foregroundColor(attraction.isSaved ? .red : AppColors.mutedText)
                                .font(.system(size: 16))
                        }
                    }

                    Text(attraction.subtitle)
                        .font(AppTypography.subheadline)
                        .foregroundColor(AppColors.mutedText)
                        .lineLimit(1)

                    HStack(spacing: 8) {
                        HStack(spacing: 2) {
                            Image(systemName: "star.fill")
                                .font(.system(size: 11))
                                .foregroundColor(AppColors.starGold)
                            Text(String(format: "%.1f", attraction.rating))
                                .font(AppTypography.captionBold)
                                .foregroundColor(AppColors.foreground)
                        }
                        Text("•")
                            .foregroundColor(AppColors.mutedText)
                        Text(attraction.ticketPrice)
                            .font(AppTypography.caption)
                            .foregroundColor(AppColors.primary)
                        Spacer()
                        Text(attraction.location)
                            .font(AppTypography.caption)
                            .foregroundColor(AppColors.mutedText)
                    }
                }
            }
            .padding(12)
            .appCard()
        }
        .buttonStyle(PlainButtonStyle())
    }
}
#endif
