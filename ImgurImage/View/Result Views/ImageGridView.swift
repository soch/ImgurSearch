import SwiftUI
import Kingfisher

struct ImageGridView: View {
    @EnvironmentObject var viewModel: ImageSearchViewModel
    
    var body: some View {
        Group {
            if viewModel.isLoading && viewModel.images.isEmpty {
                LoadingView()
            } else if viewModel.images.isEmpty {
                NoResultsView()
            } else {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
                        ForEach(viewModel.images.indices, id: \.self) { index in
                            let image = viewModel.images[index]
                            if let thumbnailLink = image.thumbnailLink, let thumbnailURL = URL(string: thumbnailLink) {
                                KFImage(thumbnailURL)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .clipped()
                                    .border(Color.blue, width: viewModel.selectedImageIndex == index ? 3 : 0) 
                                    .onTapGesture {
                                        viewModel.selectedImageURL = IdentifiableImageURL(url: image.link ?? "")
                                        viewModel.selectImage(at: index) // Set selected image index
                                    }
                                    .onAppear {
                                        if image == viewModel.images.last && viewModel.hasMoreImages {
                                            loadMoreImages()
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
    }
    
    private func loadMoreImages() {
        guard !viewModel.isLoading && viewModel.hasMoreImages else { return }
        viewModel.currentPage += 1
        print("Setting current page = \(viewModel.currentPage)")
        Task {
            await viewModel.searchImages()
        }
    }
}
