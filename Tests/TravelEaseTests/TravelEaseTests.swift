import Testing
@testable import TravelEase

@Suite("TravelEase Core State & Logic Tests")
struct TravelEaseTests {

    @Test("驗證景點依分類篩選功能")
    @MainActor
    func testCategoryFiltering() async throws {
        let viewModel = TravelViewModel()
        #expect(viewModel.filteredAttractions.count == TravelMockData.attractions.count)

        viewModel.selectedCategory = "nature"
        #expect(viewModel.filteredAttractions.allSatisfy { $0.category == "nature" })
    }

    @Test("驗證關鍵字搜尋功能")
    @MainActor
    func testSearchFiltering() async throws {
        let viewModel = TravelViewModel()
        viewModel.searchText = "九份"
        #expect(viewModel.filteredAttractions.contains { $0.name.contains("九份") })
    }

    @Test("驗證收藏狀態切換")
    @MainActor
    func testToggleSaved() async throws {
        let viewModel = TravelViewModel()
        let initialSaved = viewModel.attractions[0].isSaved
        let targetId = viewModel.attractions[0].id

        viewModel.toggleSaved(for: targetId)
        #expect(viewModel.attractions[0].isSaved == !initialSaved)
    }

    @Test("驗證將景點加入行程時間軸")
    @MainActor
    func testAddAttractionToDaySchedule() async throws {
        let viewModel = TravelViewModel()
        let initialCount = viewModel.tripSchedules[0].activities.count
        guard let attraction = viewModel.attractions.first else { return }

        viewModel.addAttractionToDaySchedule(attraction: attraction, dayIndex: 0)
        #expect(viewModel.tripSchedules[0].activities.count == initialCount + 1)
        #expect(viewModel.tripSchedules[0].activities.last?.title == attraction.name)
    }
}
