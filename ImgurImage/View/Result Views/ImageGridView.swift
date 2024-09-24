import SwiftUI
import Kingfisher

struct ImageGridView: View {
    @EnvironmentObject var  viewModel: ImageSearchViewModel

    var body: some View {
        Group {
            if viewModel.isLoading && viewModel.images.isEmpty {
                LoadingView()
            } else if viewModel.images.isEmpty {
                NoResultsView()
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
        guard !viewModel.isLoading  && viewModel.hasMoreImages else { return }
        viewModel.currentPage += 1
        print ("Setting current page = \(viewModel.currentPage)")
        Task {
            await viewModel.searchImages()
        }
    }
}

struct ImageGridView_Previews: PreviewProvider {
    let images = TestData.images
    var vm = ImageSearchViewModel()
    vm.testData(images: )
    static var previews: some View {
        ImageGridView().environmentObject(vm)
    }
}
