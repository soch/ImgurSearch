import Foundation

protocol NetworkServiceProtocol {
    func performRequest<T: Decodable>(for endpoint: Endpoint) async throws -> T
}

enum Endpoint {
    case searchImages(query: String, sortOption: String, dateRange: String, page: Int)
    
    var url: URL? {
        switch self {
        case .searchImages(let query, let sortOption, let dateRange, let page):
            let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            let apiUrl: String
            
            if sortOption == "top" {
                apiUrl = "\(AppConstants.baseApiUrl)\(sortOption)/\(dateRange)/\(page)?q=\(encodedQuery)&mature=false"
            } else {
                apiUrl = "\(AppConstants.baseApiUrl)\(sortOption)/\(page)?q=\(encodedQuery)&mature=false"
            }
            
            return URL(string: apiUrl)
        }
    }
}

class NetworkService: NetworkServiceProtocol {
    
    func performRequest<T: Decodable>(for endpoint: Endpoint) async throws -> T {
        guard let url = endpoint.url else {
            print("❌ Error: Invalid URL")
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.addValue(AppConstants.clientID, forHTTPHeaderField: "Authorization")
        
        print("🌐 Sending Request:")
        print("URL: \(url)")
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            if let jsonString = String(data: data, encoding: .utf8) {
                print("🌐 Raw Response: \(jsonString)")
            }
            let responseObject = try JSONDecoder().decode(T.self, from: data)
            return responseObject
            
        } catch {
            print("❌ Networking Error: \(error.localizedDescription)")
            throw error
        }
    }
    
    func searchImages(query: String, sortOption: String, dateRange: String, page: Int) async throws -> [ImgurImage] {
        let response: ImgurSearchResponse = try await performRequest(for: .searchImages(query: query, sortOption: sortOption, dateRange: dateRange, page: page))
        
        // Flatten the data to extract valid ImgurImage instances
        return response.data.compactMap { item in
            if let images = item.images {
                return images.filter { $0.type?.hasPrefix("image/") == true }
            } else if let link = item.link, item.type?.hasPrefix("image/") == true {
                // If the item is a single image, return it wrapped in an array
                return [ImgurImage(id: item.id, link: link, type: item.type)]
            }
            // Return nil for items that don't match
            return nil
        }.flatMap { $0 } // Flatten the resulting array
    }


}
