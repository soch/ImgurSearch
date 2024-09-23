import Foundation

class ImageSearchViewModel: ObservableObject {
    @Published var images: [ImgurImage] = []
    @Published var searchTerm: String = "Star Trek"
    @Published var isLoading = false
    @Published var currentPage = 0
    @Published var hasMoreImages = true
    @Published var selectedImageURL: IdentifiableImageURL?

    @Published var selectedSortOption: SortOption = .viral
    @Published var selectedDateRange: DateRange = .allTime
    
    private let networkService: NetworkServiceProtocol = NetworkService()


    func performSearch() async {
        currentPage = 0
        hasMoreImages = true
        images = []
        await searchImages()
    }
    
    func debounceSearch() async {
        // Delay the search operation by 0.5 seconds
        try? await Task.sleep(nanoseconds: 500_000_000)
        
        // Perform the search if the task has not been cancelled
        if !Task.isCancelled {
            await performSearch()
        }
    }

    func searchImages() async {
        isLoading = true
        do {
            let fetchedImages = try await networkService.searchImages(
                query: searchTerm,
                sortOption: selectedSortOption.rawValue,
                dateRange: selectedDateRange.rawValue,
                page: currentPage
            )
            DispatchQueue.main.async {
                self.images = fetchedImages
                self.isLoading = false
            }
        } catch {
            DispatchQueue.main.async {
                self.isLoading = false
                print("Error fetching images: \(error)")
            }
        }
    }
}
