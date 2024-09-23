import SwiftUI
import Kingfisher

struct ContentView: View {
    @EnvironmentObject var viewModel: ImageSearchViewModel
    @State private var searchTask: Task<Void, Never>? = nil

    init() {
        // Add the clear button to all text fields while editing
        UITextField.appearance().clearButtonMode = .whileEditing
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // Search Bar
                TextField("Search for images...", text: $viewModel.searchTerm, onCommit: {
                    // Trigger search when user presses return
                    searchTask?.cancel()
                    searchTask = Task {
                        await viewModel.performSearch()
                    }
                })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .onChange(of: viewModel.searchTerm) { _, _ in
                    // Cancel the previous search task if it exists
                    searchTask?.cancel()
                    searchTask = Task {
                        await viewModel.debounceSearch()
                    }
                }
                
                // Content
                if viewModel.isLoading && viewModel.images.isEmpty {
                    Spacer()
                    ProgressView("Loading images...")
                    Spacer()
                } else if viewModel.images.isEmpty {
                    Text("No images found. Try searching for something else.")
                    Spacer()
                } else {
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
                            ForEach(viewModel.images, id: \.id) { image in
                                if let thumbnailLink = image.thumbnailLink, let thumbnailURL = URL(string: thumbnailLink) {
                                    KFImage(thumbnailURL)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 100, height: 100)
                                        .clipped()
                                        .onTapGesture {
                                            viewModel.selectedImageURL = IdentifiableImageURL(url: image.link ?? "")
                                        }
                                        .onAppear {
                                            if image == viewModel.images.last && viewModel.hasMoreImages {
                                                viewModel.loadMoreImages()
                                            }
                                        }
                                }
                            }
                        }
                        
                        if viewModel.isLoading {
                            ProgressView("Loading more images...")
                        }
                    }
                }
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
            .navigationBarItems(trailing: HStack {
                SortMenu(viewModel: viewModel)
                DateRangeMenu(viewModel: viewModel)
            })
        }
    }
}
