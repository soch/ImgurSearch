//
//  NetworkService.swift
//  ImgurImage
//
//  Created by Amit Jain on 9/22/24.
//

import Foundation

protocol NetworkServiceProtocol {
    func searchImages(query: String, sortOption: String, dateRange: String, page: Int, clientID: String) async throws -> [ImgurImage]
}

class NetworkService: NetworkServiceProtocol {
    private let baseApiUrl = "https://api.imgur.com/3/gallery/search/"
    
    func searchImages(query: String, sortOption: String, dateRange: String, page: Int, clientID: String) async throws -> [ImgurImage] {
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let apiUrl: String
        
        if sortOption == "top" {
            apiUrl = "\(baseApiUrl)\(sortOption)/\(page)?q=\(encodedQuery)&mature=false"
        } else {
            apiUrl = "\(baseApiUrl)\(sortOption)/\(dateRange)/\(page)?q=\(encodedQuery)&mature=false"
        }
        
        guard let url = URL(string: apiUrl) else {
            print("❌ Error: Invalid URL")
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.addValue(clientID, forHTTPHeaderField: "Authorization")
        
        // Debugging: Print Request Information
        print("🌐 Sending Request:")
        print("URL: \(url)")
        print("Headers: \(request.allHTTPHeaderFields ?? [:])")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            // Debugging: Print Response Information
            if let httpResponse = response as? HTTPURLResponse {
                print("✅ Response Status Code: \(httpResponse.statusCode)")
            }
            
            let responseObject = try JSONDecoder().decode(ImgurSearchResponse.self, from: data)
            
            // Debugging: Print Decoded Response Info
            print("✅ Successfully decoded response with \(responseObject.data.count) items")
            
            return responseObject.data.compactMap { item in
                if let images = item.images {
                    return images.filter { $0.type?.hasPrefix("image/") == true }
                } else if let link = item.link, item.type?.hasPrefix("image/") == true {
                    return [ImgurImage(id: item.id, link: link, type: item.type)]
                }
                return nil
            }.flatMap { $0 }
            
        } catch {
            // Debugging: Print Error Details
            print("❌ Networking Error: \(error.localizedDescription)")
            throw error
        }
    }
}
