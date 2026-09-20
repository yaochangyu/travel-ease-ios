#if canImport(SwiftUI)
import SwiftUI

public struct TravelAppMainView: View {
    @State private var viewModel = TravelViewModel()
    @State private var showSplash: Bool = true

    public init() {}

    public var body: some View {
        ZStack {
            TabView(selection: $viewModel.selectedTab) {
                NavigationStack {
                    DiscoverView(viewModel: viewModel)
                }
                .tabItem {
                    Label("探索", systemImage: "safari.fill")
                }
                .tag(0)

                NavigationStack {
                    TripPlannerView(viewModel: viewModel)
                }
                .tabItem {
                    Label("行程", systemImage: "calendar")
                }
                .tag(1)

                NavigationStack {
                    TravelMapView(viewModel: viewModel)
                }
                .tabItem {
                    Label("地圖", systemImage: "map.fill")
                }
                .tag(2)

                NavigationStack {
                    ProfileView(viewModel: viewModel)
                }
                .tabItem {
                    Label("我的", systemImage: "person.fill")
                }
                .tag(3)
            }
            .tint(AppColors.primary)
            .sheet(item: $viewModel.activeDetailAttraction) { attraction in
                AttractionDetailView(attraction: attraction, viewModel: viewModel)
            }
            .overlay(alignment: .top) {
                if viewModel.showToast, let msg = viewModel.toastMessage {
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(AppColors.success)
                        Text(msg)
                            .font(AppTypography.callout)
                            .foregroundColor(AppColors.foreground)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(Color.white)
                    .cornerRadius(AppCornerRadius.full)
                    .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 4)
                    .padding(.top, 50)
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                            withAnimation {
                                viewModel.showToast = false
                            }
                        }
                    }
                }
            }

            // Splash Screen Transition
            if showSplash {
                SplashScreenView(onFinished: {
                    withAnimation(.easeInOut(duration: 0.35)) {
                        showSplash = false
                    }
                })
                .transition(.opacity)
                .zIndex(100)
            }
        }
    }
}
#endif
