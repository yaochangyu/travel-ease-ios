import Foundation

// MARK: - Category Model
public struct TravelCategory: Identifiable, Hashable, Sendable {
    public let id: String
    public let name: String
    public let iconName: String
    public let count: Int

    public init(id: String, name: String, iconName: String, count: Int) {
        self.id = id
        self.name = name
        self.iconName = iconName
        self.count = count
    }
}

// MARK: - Attraction Model
public struct Attraction: Identifiable, Hashable, Sendable {
    public let id: String
    public let name: String
    public let subtitle: String
    public let category: String
    public let rating: Double
    public let reviewCount: Int
    public let location: String
    public let imageUrl: String
    public let description: String
    public let audioGuideUrl: String?
    public let openingHours: String
    public let ticketPrice: String
    public let estimatedStayTime: String
    public let coordinates: (latitude: Double, longitude: Double)
    public let tags: [String]
    public var isSaved: Bool

    public init(
        id: String,
        name: String,
        subtitle: String,
        category: String,
        rating: Double,
        reviewCount: Int,
        location: String,
        imageUrl: String,
        description: String,
        audioGuideUrl: String? = nil,
        openingHours: String = "09:00 - 18:00",
        ticketPrice: String = "免費參觀",
        estimatedStayTime: String = "2-3 小時",
        coordinates: (Double, Double) = (25.0330, 121.5654),
        tags: [String] = [],
        isSaved: Bool = false
    ) {
        self.id = id
        self.name = name
        self.subtitle = subtitle
        self.category = category
        self.rating = rating
        self.reviewCount = reviewCount
        self.location = location
        self.imageUrl = imageUrl
        self.description = description
        self.audioGuideUrl = audioGuideUrl
        self.openingHours = openingHours
        self.ticketPrice = ticketPrice
        self.estimatedStayTime = estimatedStayTime
        self.coordinates = coordinates
        self.tags = tags
        self.isSaved = isSaved
    }

    public static func == (lhs: Attraction, rhs: Attraction) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: - Review Model
public struct AttractionReview: Identifiable, Hashable, Sendable {
    public let id: String
    public let userName: String
    public let userAvatarUrl: String
    public let rating: Double
    public let dateString: String
    public let content: String

    public init(id: String, userName: String, userAvatarUrl: String, rating: Double, dateString: String, content: String) {
        self.id = id
        self.userName = userName
        self.userAvatarUrl = userAvatarUrl
        self.rating = rating
        self.dateString = dateString
        self.content = content
    }
}

// MARK: - Trip Activity Item (Timeline Node)
public struct TripActivity: Identifiable, Hashable, Sendable {
    public let id: String
    public var timeString: String
    public var title: String
    public var subtitle: String
    public var category: String
    public var durationMinutes: Int
    public var transitInfo: String? // e.g. "步行 10 分鐘 (800m)"
    public var isCompleted: Bool
    public var attractionId: String?

    public init(
        id: String = UUID().uuidString,
        timeString: String,
        title: String,
        subtitle: String,
        category: String,
        durationMinutes: Int = 90,
        transitInfo: String? = nil,
        isCompleted: Bool = false,
        attractionId: String? = nil
    ) {
        self.id = id
        self.timeString = timeString
        self.title = title
        self.subtitle = subtitle
        self.category = category
        self.durationMinutes = durationMinutes
        self.transitInfo = transitInfo
        self.isCompleted = isCompleted
        self.attractionId = attractionId
    }
}

// MARK: - Trip Day Schedule
public struct TripDaySchedule: Identifiable, Hashable, Sendable {
    public let id: String
    public let dayNumber: Int
    public let dateTitle: String
    public var activities: [TripActivity]

    public init(id: String = UUID().uuidString, dayNumber: Int, dateTitle: String, activities: [TripActivity]) {
        self.id = id
        self.dayNumber = dayNumber
        self.dateTitle = dateTitle
        self.activities = activities
    }
}

// MARK: - User Profile & Ticket
public struct TravelTicket: Identifiable, Hashable, Sendable {
    public let id: String
    public let attractionName: String
    public let validDate: String
    public let qrCodeString: String
    public let ticketType: String
    public let status: String // "有效", "已使用"

    public init(id: String, attractionName: String, validDate: String, qrCodeString: String, ticketType: String, status: String = "有效") {
        self.id = id
        self.attractionName = attractionName
        self.validDate = validDate
        self.qrCodeString = qrCodeString
        self.ticketType = ticketType
        self.status = status
    }
}

// MARK: - Mock Data Provider
public enum TravelMockData {
    public static let categories: [TravelCategory] = [
        TravelCategory(id: "all", name: "全部熱門", iconName: "sparkles", count: 48),
        TravelCategory(id: "nature", name: "自然山海", iconName: "leaf.fill", count: 18),
        TravelCategory(id: "culture", name: "歷史人文", iconName: "building.columns.fill", count: 12),
        TravelCategory(id: "food", name: "在地美食", iconName: "fork.knife", count: 24),
        TravelCategory(id: "relax", name: "渡假放鬆", iconName: "sun.max.fill", count: 9)
    ]

    public static let attractions: [Attraction] = [
        Attraction(
            id: "jiufen",
            name: "九份山城老街",
            subtitle: "黃金山城與絕美夕陽茶樓景觀",
            category: "culture",
            rating: 4.8,
            reviewCount: 3840,
            location: "新北市瑞芳區",
            imageUrl: "https://images.unsplash.com/photo-1508804185872-d7badad00f7d?w=800&auto=format&fit=crop&q=80",
            description: "依山傍海的九份老街擁有獨特的階梯式建築與濃厚的人文歷史。漫步在豎崎路的紅燈籠下，品嚐熱騰騰的芋圓，遠眺基隆山與陰陽海夕陽。",
            audioGuideUrl: "https://example.com/audio/jiufen.mp3",
            openingHours: "全天開放（店家約 09:00 - 20:00）",
            ticketPrice: "免費參觀",
            estimatedStayTime: "2.5 - 3.5 小時",
            coordinates: (25.1098, 121.8441),
            tags: ["打卡熱點", "私房茶樓", "夕陽夜景", "傳統小吃"],
            isSaved: true
        ),
        Attraction(
            id: "sunmoonlake",
            name: "日月潭環湖步道",
            subtitle: "全球十大最美自行車道與湖光山色",
            category: "nature",
            rating: 4.9,
            reviewCount: 5210,
            location: "南投縣魚池鄉",
            imageUrl: "https://images.unsplash.com/photo-1544644181-1484b3fdfc62?w=800&auto=format&fit=crop&q=80",
            description: "被 CNN 評選為全球最美自行車道之一。清晨薄霧籠罩的湖面如同仙境，可搭乘纜車俯瞰湖景，或乘船遊覽水社與伊達邵碼頭。",
            audioGuideUrl: "https://example.com/audio/sml.mp3",
            openingHours: "全天開放（船班 08:30 - 17:00）",
            ticketPrice: "步道免費（船票約 $300）",
            estimatedStayTime: "3 - 5 小時",
            coordinates: (23.8580, 120.9160),
            tags: ["湖泊美景", "自行車道", "水上活動", "親子友善"],
            isSaved: false
        ),
        Attraction(
            id: "alishan",
            name: "阿里山森林遊樂區",
            subtitle: "千年巨木步道、雲海與祝山日出",
            category: "nature",
            rating: 4.9,
            reviewCount: 4620,
            location: "嘉義縣阿里山鄉",
            imageUrl: "https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=800&auto=format&fit=crop&q=80",
            description: "阿里山五奇：日出、雲海、晚霞、森林與高山鐵路。漫步在巨木群棧道吸收芬多精，搭乘百年蒸氣小火車穿越雲海。",
            audioGuideUrl: "https://example.com/audio/alishan.mp3",
            openingHours: "全天開放",
            ticketPrice: "全票 $300 / 優惠票 $150",
            estimatedStayTime: "半天至一日",
            coordinates: (23.5110, 120.8030),
            tags: ["森林浴", "祝山日出", "登山健行", "雲海景觀"],
            isSaved: true
        ),
        Attraction(
            id: "taroko",
            name: "太魯閣峽谷步道",
            subtitle: "大自然鬼斧神工的大理石巨岩峽谷",
            category: "nature",
            rating: 4.8,
            reviewCount: 4100,
            location: "花蓮縣秀林鄉",
            imageUrl: "https://images.unsplash.com/photo-1506744038136-46273834b3fb?w=800&auto=format&fit=crop&q=80",
            description: "立霧溪千萬年沖刷下形成的雄偉大理石峽谷，燕子口、九曲洞與白楊步道展現出令人屏息的大自然力量。",
            audioGuideUrl: "https://example.com/audio/taroko.mp3",
            openingHours: "08:30 - 17:00",
            ticketPrice: "免費入園",
            estimatedStayTime: "3 - 4 小時",
            coordinates: (24.1610, 121.6210),
            tags: ["壯麗峽谷", "地質奇觀", "戶外健行"],
            isSaved: false
        )
    ]

    public static let sampleTripSchedule: [TripDaySchedule] = [
        TripDaySchedule(
            dayNumber: 1,
            dateTitle: "Day 1 · 台北出發與黃金山城",
            activities: [
                TripActivity(timeString: "09:30", title: "台北車站出發", subtitle: "搭乘自強號前往瑞芳", category: "transit", durationMinutes: 45, transitInfo: "搭車約 42 分鐘", isCompleted: true),
                TripActivity(timeString: "10:45", title: "九份山城老街漫步", subtitle: "豎崎路、阿妹茶樓與芋圓品嚐", category: "culture", durationMinutes: 120, transitInfo: "公車 15 分鐘", isCompleted: true, attractionId: "jiufen"),
                TripActivity(timeString: "13:30", title: "黃金博物館與黃金瀑布", subtitle: "體驗淘金歷史與壯麗瀑布景緻", category: "culture", durationMinutes: 90, transitInfo: "步行 8 分鐘", isCompleted: false),
                TripActivity(timeString: "16:30", title: "不厭亭眺望寂寞公路", subtitle: "欣賞雙溪與九份交界夕陽稜線", category: "nature", durationMinutes: 60, transitInfo: "車程 20 分鐘", isCompleted: false),
                TripActivity(timeString: "18:30", title: "山城夜景景觀餐廳", subtitle: "品茗與在地特色風味晚宴", category: "food", durationMinutes: 90, isCompleted: false)
            ]
        ),
        TripDaySchedule(
            dayNumber: 2,
            dateTitle: "Day 2 · 日月潭湖光水色之旅",
            activities: [
                TripActivity(timeString: "08:30", title: "水社碼頭晨光漫步", subtitle: "晨霧中的靜謐湖畔巡禮", category: "nature", durationMinutes: 60, isCompleted: false),
                TripActivity(timeString: "10:00", title: "日月潭自行車道騎行", subtitle: "向山段水上自行車步道拍照打卡", category: "nature", durationMinutes: 120, transitInfo: "租借單車騎行 6km", isCompleted: false, attractionId: "sunmoonlake"),
                TripActivity(timeString: "13:00", title: "伊達邵老街原民美食", subtitle: "山豬肉香腸與阿薩姆紅茶", category: "food", durationMinutes: 80, isCompleted: false)
            ]
        )
    ]
}
