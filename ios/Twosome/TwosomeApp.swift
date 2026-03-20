import SwiftUI

@main
struct TwosomeApp: App {
    @State private var store = AppDataStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(store)
        }
    }
}
