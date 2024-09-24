//
//  NetworkService.swift
//  ImgurImage
//
//  Created by Amit Jain on 9/22/24.
//

import Foundation

protocol NetworkServiceProtocol {
    func searchImages(query: String, sortOption: String, dateRange: String, page: Int) async throws -> [ImgurImage]
}

class NetworkService: NetworkServiceProtocol {
    
    func searchImages(query: String, sortOption: String, dateRange: String, page: Int) async throws -> [ImgurImage] {
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        var apiUrl: String
        if sortOption == "top" {
            apiUrl = "\(AppConstants.baseApiUrl)\(sortOption)/\(dateRange)/\(page)?q=\(encodedQuery)&mature=false"
            
        } else {
            apiUrl = "\(AppConstants.baseApiUrl)\(sortOption)/\(page)?q=\(encodedQuery)&mature=false"
        }
        
        guard let url = URL(string: apiUrl) else {
            print("❌ Error: Invalid URL")
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.addValue(AppConstants.clientID, forHTTPHeaderField: "Authorization")
        
        
        print("🌐 Sending Request:")
        print("URL: \(url)")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            //            #if DEBUG
            //            if let httpResponse = response as? HTTPURLResponse {
            //                print("✅ Response Status Code: \(httpResponse.statusCode)")
            //            }
            //            if let jsonString = String(data: data, encoding: .utf8) {
            //                print("🌐 Raw Response: \(jsonString)")
            //            }
            //            #endif
            let responseObject = try JSONDecoder().decode(ImgurSearchResponse.self, from: data)
            return responseObject.data.compactMap { item in
                if let images = item.images {
                    return images.filter { $0.type?.hasPrefix("image/") == true }
                } else if let link = item.link, item.type?.hasPrefix("image/") == true {
                    return [ImgurImage(id: item.id, link: link, type: item.type)]
                }
                return nil
            }.flatMap { $0 }
            
        } catch {
            print("❌ Networking Error: \(error.localizedDescription)")
            throw error
        }
    }
}
