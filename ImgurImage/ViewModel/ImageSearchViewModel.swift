import Foundation

@MainActor
class ImageSearchViewModel: ObservableObject {
    @Published var images: [ImgurImage] = []
    @Published var searchTerm: String = "Star Trek"
    @Published var isLoading = false
    @Published var currentPage = 0
    @Published var hasMoreImages = true
    @Published var selectedImageURL: IdentifiableImageURL?

    @Published var selectedSortOption: SortOption = .time
    @Published var selectedDateRange: DateRange = .allTime
    
    private let networkService: NetworkServiceProtocol = NetworkService()


    func performSearch() async {
        DispatchQueue.main.async { [weak self] in
            self?.currentPage = 0
            self?.hasMoreImages = true
            self?.images = []
        }
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
            // Filter out duplicates before updating the images array
            let existingImageIds = Set(images.map { $0.id })
            let newImages = fetchedImages.filter { !existingImageIds.contains($0.id) }
            
            DispatchQueue.main.async { [weak self] in
                if newImages.isEmpty {
                    self?.hasMoreImages = false
#if DEBUG
                    print("No more images available.")
#endif
                } else {
                    self?.hasMoreImages = (newImages.count >= AppConstants.paginationLimit)
                    self?.images.append(contentsOf: newImages)
#if DEBUG
                    if let hasImages = self?.hasMoreImages {
                        print("Loaded \(newImages.count) new images. Set hasMoreImages to \(String(describing: hasImages))")
                    }
#endif
                }
                self?.isLoading = false
            }
        } catch {
            DispatchQueue.main.async { [weak self] in
                self?.isLoading = false
                print("Error fetching images: \(error)")
            }
        }
    }
    
    func setSortOption(option: SortOption) {
        selectedSortOption = option
    }
    
    func setDateOption(range: DateRange) {
        selectedDateRange = range
    }
}
