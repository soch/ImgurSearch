import SwiftUI
import Kingfisher

struct ContentView: View {
    @EnvironmentObject var viewModel: ImageSearchViewModel
    
    init() {
        UITextField.appearance().clearButtonMode = .whileEditing // show x button
    }
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBarView() // search input
                ImageGridView() // shows images
            }
            .padding()
            .onAppear {
                Task {
                    await viewModel.performSearch()
                }
            }
            .sheet(item: $viewModel.selectedImageURL) { identifiableImage in
                FullImageView(imageUrl: identifiableImage.url)
            }
            .navigationTitle("Imgur Search")
            .navigationBarItems(trailing: MenuView()) // show sort & filter menus
        }
    }
}
