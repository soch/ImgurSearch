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
                if let selectedIndex = viewModel.images.firstIndex(where: { $0.link == identifiableImage.url }) {
                    FullImageView(images: viewModel.images, startIndex: selectedIndex)
                        .presentationDragIndicator(.visible)
                }
            }
            .navigationTitle("Imgur Search")
            .navigationBarItems(trailing: MenuView()) // show sort & filter menus
        }
    }
}
