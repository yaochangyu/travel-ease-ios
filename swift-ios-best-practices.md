# Swift & iOS 開發最佳實踐指南 (Swift 6 & iOS 17/18+)

> **資料來源**：基於 Context7 檢索之權威文檔（Swift 官方文檔、SwiftUI Expert Skill、Apple Developer 指南）彙整。

---

## 1. 現代狀態管理 (State Management)

### 1.1 採用 `@Observable` 巨集（iOS 17+ 標準）
取代傳統的 `ObservableObject`、`@StateObject` 與 `@Published`。

- **規則 1**：所有狀態類別皆標註 `@Observable` 與 `@MainActor`，確保執行緒安全與 UI 綁定。
- **規則 2**：View 擁有該物件時，使用 `@State private var`。`@State` 確保 View 在重繪時不會重建實例造成狀態丟失。

```swift
import SwiftUI
import Observation

@Observable
@MainActor
final class TripPlanViewModel {
    var destination: String = "台北"
    var budget: Double = 5000.0
    var isLoading: Bool = false
    
    func updateDestination(_ newPlace: String) {
        self.destination = newPlace
    }
}

struct TripPlanView: View {
    // 由 View 擁有生命週期：使用 @State
    @State private var viewModel = TripPlanViewModel()

    var body: some View {
        VStack(spacing: 16) {
            TextField("目的地", text: $viewModel.destination)
            Text("預算: $\(viewModel.budget, specifier: "%.0f")")
        }
    }
}
```

### 1.2 狀態包裝器 (Property Wrapper) 決策樹

```text
這個值是由當前 View 擁有生命週期嗎？
├─ 是 (YES)：
│   ├─ 簡單 Value Type (String, Int, Struct) → @State private var
│   └─ 引用物件 (Class)：
│       └─ 現代模式 → 標註 @Observable 與 @MainActor，View 內宣告 @State private var
│
└─ 否 (NO, 由父層傳入)：
    ├─ 子層需要雙向修改它嗎？
    │   ├─ 是 → @Binding var
    │   └─ 否：子層需要對其內部屬性建立 Binding 嗎？
    │       ├─ 是 (針對 @Observable 物件) → @Bindable var
    │       └─ 否：子層只需讀取或監聽變化？
    │           ├─ 是 → 普通 let + .onChange()
    │           └─ 否 → 普通 let
```

---

## 2. 型別安全導航 (Type-Safe Navigation)

### 2.1 使用 `NavigationStack` 與路由 Enum（iOS 16+）
棄用舊版 `NavigationView` 與 `NavigationLink(destination:)`。

```swift
enum AppRoute: Hashable {
    case attractionDetail(id: String)
    case itineraryEditor(tripId: String)
    case settings
}

struct MainTabView: View {
    @State private var navigationPath = NavigationPath()

    var body: some View {
        NavigationStack(path: $navigationPath) {
            List {
                Button("查看九份老街") {
                    navigationPath.append(AppRoute.attractionDetail(id: "jiufen"))
                }
            }
            .navigationDestination(for: AppRoute.self) { route in
                switch route {
                case .attractionDetail(let id):
                    AttractionDetailView(attractionId: id)
                case .itineraryEditor(let tripId):
                    ItineraryEditorView(tripId: tripId)
                case .settings:
                    SettingsView()
                }
            }
        }
    }
}
```

### 2.2 程式化返回與關閉 (Dismiss)
使用 `@Environment(\.dismiss)` 取代已棄用的 `presentationMode`。

```swift
struct ModalSheetView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Button("完成") {
            dismiss()
        }
    }
}
```

---

## 3. Swift 6 並行處理與執行緒安全 (Concurrency & Sendable)

### 3.1 善用 `.task` 修飾符進行非同步工作
`.task` 會在 View 出現時啟動非同步任務，並在 **View 消失時自動取消 (Auto-cancellation)**，防止記憶體洩漏與無效請求。

```swift
struct AttractionListView: View {
    @State private var attractions: [Attraction] = []

    var body: some View {
        List(attractions) { item in
            AttractionRow(item: item)
        }
        .task {
            // View 消失時會自動中斷
            self.attractions = await AttractionService.fetchPopular()
        }
    }
}
```

### 3.2 跨執行緒 Closure 的值捕獲 (Capture List)
在可能脫離主執行緒的閉包（如 `visualEffect`、`Shape.path`、`Layout` 等）中，**禁止直接存取 `@MainActor` 屬性**，必須透過 Capture List 顯式傳入副本：

```swift
// ❌ 錯誤：直接存取 @MainActor 隔離的狀態
.visualEffect { content, geometry in
    content.blur(radius: self.isBlurred ? 5 : 0) // 編譯錯誤
}

// ✅ 正確：透過捕獲列表提取值副本
.visualEffect { [isBlurred = self.isBlurred] content, geometry in
    content.blur(radius: isBlurred ? 5 : 0)
}
```

---

## 4. SwiftUI 渲染效能優化 (Performance Optimization)

### 4.1 避免在 `body` 內執行昂貴計算
`body` 可能每秒被多次調用，重計算（如排序、篩選、過濾）會嚴重造成卡頓。

```swift
// ❌ 錯誤：每次 body 重算都會執行排序
var body: some View {
    List(items.sorted { $0.rating > $1.rating }) { item in
        Text(item.name)
    }
}

// ✅ 正確：在 Model 內快取或透過 onChange 監聽更新
@State private var sortedItems: [Attraction] = []

var body: some View {
    List(sortedItems) { item in
        Text(item.name)
    }
    .onChange(of: items, initial: true) { _, newItems in
        sortedItems = newItems.sorted { $0.rating > $1.rating }
    }
}
```

### 4.2 拆分子視圖 (Granular Subviews)
當一個大 View 內部的某個小狀態變更時，拆為獨立 Subview 可以讓 SwiftUI 僅重繪該子視圖，縮小 Diff 計算範圍。

---

## 5. 設計系統與 HIG 規範 (Human Interface Guidelines)

### 5.1 語意化顏色與 Design Tokens
禁止在元件內直接寫死 Hex Code，統一透過 Design System Token (`AppColors`, `AppSpacing`, `AppTypography`) 呼叫。

### 5.2 觸控目標與無障礙
- **最小觸控面積**：保證所有互動按鈕與圖示至少具備 `44 × 44 pt` 觸控區域（可使用 `.contentShape(Rectangle())` 擴大）。
- **色彩對比度**：內文與底色保持至少 `4.5:1` 對比（WCAG AA 標準）。
- **Safe Area**：自訂導覽與底部浮動列必須使用 `.safeAreaPadding()` 或尊重 SafeArea 邊界。

---

## 6. 架構建議總結 (Architecture Checklist)

| 面向 | 推薦作法 | 應避免的舊寫法 / Anti-patterns |
|---|---|---|
| **狀態監聽** | `@Observable` + `@State` | `ObservableObject` + `@ObservedObject` |
| **導航機制** | `NavigationStack(path:)` + `enum Route` | `NavigationView` + `NavigationLink(destination:)` |
| **非同步任務** | `.task { await ... }` | 在 `onAppear` 內手動 `Task { ... }` 且未取消 |
| **資料流傳遞** | `@Environment` / `@Bindable` | 跨 4 層 View 傳遞多重 `@Binding` |
| **字體排印** | Dynamic Type (`Font.headline`, `Font.title`) | 固定像素大小且不支援系統縮放 |
