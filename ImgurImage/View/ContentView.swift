import SwiftUI
import Kingfisher

struct ContentView: View {
    @EnvironmentObject var viewModel: ImageSearchViewModel
    

    init() {
        UITextField.appearance().clearButtonMode = .whileEditing
    }
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBarView()
                ImageGridView()
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
            .navigationBarItems(trailing: MenuView())
        }
    }
}


