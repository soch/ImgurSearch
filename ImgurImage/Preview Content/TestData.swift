//
//  TestData.swift
//  ImgurImage
//
//  Created by Amit Jain on 9/23/24.
//

import Foundation
struct TestData {
    static var images: [ImgurImage] = {
        var decodedImages:[ImgurImage] = []
        do {
            let url = Bundle.main.url(forResource: "Response", withExtension: "json")!
            let data = try! Data(contentsOf: url)
            let decoder = JSONDecoder()
            let result = try! decoder.decode(ImgurSearchResponse.self, from: data)
            print("Async decoded images count", decodedImages.count)
            
            decodedImages = result.data.compactMap { item in
                if let images = item.images {
                    return images.filter { $0.type?.hasPrefix("image/") == true }
                } else if let link = item.link, item.type?.hasPrefix("image/") == true {
                    return [ImgurImage(id: item.id, link: link, type: item.type)]
                }
                return nil
            }.flatMap { $0 }
        }
        return decodedImages
    }()
}
