# TravelEase iOS (旅程悠遊)

> 專為探索台灣設計的現代 iOS 智慧觀光旅遊 App，結合 SwiftUI 原生架構、iOS 17+ 現代狀態管理、品牌設計系統與高保真互動原型。

---

## ✨ 核心特色與功能

- 🌟 **探索首頁 (Discover)**：
  - 智慧搜尋與分類標籤（全部、自然山海、歷史人文、在地美食）。
  - 精選景點卡片（九份山城、日月潭、阿里山、太魯閣）。
  - 即時收藏狀態切換。
- 📅 **行程規劃時間軸 (Trip Planner)**：
  - Day 1 / Day 2 / Day 3 每日分頁時間軸切換。
  - 交通方式、移動耗時估算與景點停留時間標記。
  - 支援動態加入景點與打勾完成狀態。
- 🗺️ **周邊地圖 (Travel Map)**：
  - 地圖周邊景點釘選標記。
  - 底部浮動卡片滑動預覽與快速導航。
- 👤 **個人中心 (Profile)**：
  - 個人旅遊足跡與探索家等級勳章。
  - 電子票券與 QR Code。
  - 收藏清單集中管理。
- 🎬 **啟動畫面 (Splash Screen)**：
  - 具備星夜漸層、動態環境光暈與 Logo 彈性動畫的 App 啟動過渡。

---

## 🏛️ 架構與最佳實踐 (Swift 6 & iOS 17+)

本專案遵循最新 Apple Human Interface Guidelines (HIG) 與 Swift 官方最佳實踐：

- **狀態管理**：全面採用 `@Observable` 巨集與 `@MainActor`，View 內使用 `@State` 維護生命週期。
- **型別安全導航**：使用 `NavigationStack` 搭配自訂 `Route` enum。
- **並行與效能**：資料模型全面遵循 `Sendable`；非同步操作善用 `.task` 自動取消機制；拆分細粒度子視圖縮小 SwiftUI Diff 重繪範圍。
- **設計系統**：嚴格使用 Design System Token (`AppColors`, `AppSpacing`, `AppTypography`, `AppCornerRadius`)，避免寫死 Hex 數值。

---

## 📁 專案目錄結構

```text
travel-ease-ios/
├── Package.swift                    # Swift Package Manager 配置
├── Sources/
│   └── TravelEase/
│       ├── DesignSystem/
│       │   └── DesignSystem.swift   # 原生色彩、間距、字體 Token 與 ViewModifier
│       ├── Models/
│       │   └── TravelModels.swift   # Attraction, TripDaySchedule, Category 模型與 Mock Data
│       ├── ViewModels/
│       │   └── TravelViewModel.swift# iOS 17 @Observable 核心狀態管理
│       └── Views/
│           ├── TravelAppMainView.swift  # 4 Tab 導覽與 Toast 根視圖
│           ├── SplashScreenView.swift   # 品牌動效啟動畫面
│           ├── DiscoverView.swift       # 探索頁面
│           ├── TripPlannerView.swift    # 每日行程時間軸
│           ├── TravelMapView.swift      # 地圖周邊探索
│           ├── ProfileView.swift        # 個人中心與電子票券
│           └── AttractionDetailView.swift# 景點詳細頁 Half Modal
├── Tests/
│   └── TravelEaseTests/             # Swift Testing 單元測試套件
├── prototype/
│   └── travel_app_prototype.html    # iPhone 16 Pro 單檔高保真 HTML 互動原型
├── design-system/                   # UI/UX Pro Max 產出之設計系統規範 (MASTER.md)
└── swift-ios-best-practices.md      # Context7 檢索之權威 Swift 開發指南
```

---

## 🚀 快速開始與執行

### 1. 執行單元測試 (Swift Testing)
```bash
swift test
```

### 2. 在本機預覽 iPhone 16 Pro 互動原型
直接以瀏覽器開啟 `prototype/travel_app_prototype.html`：
```bash
# 在 Linux / WSL2
explorer.exe prototype/travel_app_prototype.html

# 在 macOS
open prototype/travel_app_prototype.html
```

### 3. 在 Mac / Xcode 啟動原生 iOS 模擬器
1. 將本儲存庫 Clone 至 macOS 環境。
2. 透過 Xcode 開啟 `Package.swift`。
3. 頂部選擇目標設備（例如 `iPhone 16 Pro`），按下 `Cmd + R` 即可原生編譯並啟動執行。

---

## 📄 授權條款

MIT License
