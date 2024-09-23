import Foundation

class ImageSearchViewModel: ObservableObject {
    @Published var images: [ImgurImage] = []
    @Published var searchTerm: String = ""
    @Published var isLoading = false
    @Published var selectedSortOption: SortOption = .viral
    @Published var selectedDateRange: DateRange = .allTime
    @Published var currentPage = 0
    @Published var hasMoreImages = true
    
    private let networkService: NetworkServiceProtocol
    private let clientID: String
    
    init(networkService: NetworkServiceProtocol, clientID: String = "Client-ID b067d5cb828ec5a") {
        self.networkService = networkService
        self.clientID = clientID
    }
    
    func performSearch() async {
        currentPage = 0
        hasMoreImages = true
        images = []
        await searchImages()
    }
    
    func searchImages() async {
        isLoading = true
        do {
            let fetchedImages = try await networkService.searchImages(
                query: searchTerm,
                sortOption: selectedSortOption.rawValue,
                dateRange: selectedDateRange.rawValue,
                page: currentPage,
                clientID: clientID
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
