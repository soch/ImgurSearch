import SwiftUI

@main
struct ImgurImageApp: App {
    private let networkService = NetworkService()
    private let clientID = "Client-ID b067d5cb828ec5a"
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(ImageSearchViewModel(networkService: networkService, clientID: clientID))
        }
    }
}
