import Foundation
#if canImport(Observation)
import Observation
#endif

// MARK: - App Navigation Routes
public enum TravelRoute: Hashable, Sendable {
    case attractionDetail(Attraction)
    case tripDayDetail(Int)
    case ticketDetail(TravelTicket)
}

// MARK: - App State (iOS 17+ @Observable)
#if canImport(Observation)
@Observable
@MainActor
public final class TravelViewModel {
    public var selectedTab: Int = 0
    public var selectedCategory: String = "all"
    public var searchText: String = ""
    
    public var categories: [TravelCategory] = TravelMockData.categories
    public var attractions: [Attraction] = TravelMockData.attractions
    public var tripSchedules: [TripDaySchedule] = TravelMockData.sampleTripSchedule
    public var selectedDayIndex: Int = 0
    
    public var activeDetailAttraction: Attraction? = nil
    public var toastMessage: String? = nil
    public var showToast: Bool = false

    public init() {}

    public var filteredAttractions: [Attraction] {
        attractions.filter { attraction in
            let matchesCategory = (selectedCategory == "all") || (attraction.category == selectedCategory)
            let matchesSearch = searchText.isEmpty ||
                attraction.name.localizedCaseInsensitiveContains(searchText) ||
                attraction.subtitle.localizedCaseInsensitiveContains(searchText) ||
                attraction.location.localizedCaseInsensitiveContains(searchText)
            return matchesCategory && matchesSearch
        }
    }

    public func toggleSaved(for attractionId: String) {
        if let index = attractions.firstIndex(where: { $0.id == attractionId }) {
            attractions[index].isSaved.toggle()
            showToastMessage(attractions[index].isSaved ? "已加入我的收藏" : "已從收藏移除")
        }
    }

    public func addAttractionToDaySchedule(attraction: Attraction, dayIndex: Int = 0) {
        guard dayIndex < tripSchedules.count else { return }
        let newActivity = TripActivity(
            timeString: "15:00",
            title: attraction.name,
            subtitle: attraction.subtitle,
            category: attraction.category,
            durationMinutes: 90,
            transitInfo: "距離上一景點 2.5km",
            isCompleted: false,
            attractionId: attraction.id
        )
        tripSchedules[dayIndex].activities.append(newActivity)
        showToastMessage("已成功將「\(attraction.name)」加入 Day \(dayIndex + 1) 行程！")
    }

    public func toggleActivityCompleted(dayIndex: Int, activityId: String) {
        guard dayIndex < tripSchedules.count else { return }
        if let actIndex = tripSchedules[dayIndex].activities.firstIndex(where: { $0.id == activityId }) {
            tripSchedules[dayIndex].activities[actIndex].isCompleted.toggle()
        }
    }

    public func showToastMessage(_ message: String) {
        self.toastMessage = message
        self.showToast = true
    }
}
#endif
