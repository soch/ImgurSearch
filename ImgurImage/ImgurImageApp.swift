import SwiftUI

@main
struct ImgurImageApp: App {
    @StateObject private var viewModel =  ImageSearchViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
