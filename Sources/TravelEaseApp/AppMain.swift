#if canImport(SwiftUI)
import SwiftUI

@main
public struct TravelEaseApp: App {
    public init() {}

    public var body: some Scene {
        WindowGroup {
            TravelAppMainView()
        }
    }
}
#endif
