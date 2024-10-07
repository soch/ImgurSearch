//
//  ImgurImage.swift
//  ImgurImage
//
//  Created by Amit Jain on 9/22/24.
//


import Foundation

struct ImgurSearchResponse: Codable {
    let data: [ImgurImageWrapper]
}

struct ImgurImageWrapper: Codable {
    let id: String
    let title: String?
    let link: String?
    let images: [ImgurImage]?
    let type: String?
}

struct ImgurImage: Codable, Identifiable, Equatable {
    let id: String
    let link: String?
    let type: String?
    
    // Thumbnail URL derived from the original link
    var thumbnailLink: String? {
        guard let link = link else { return nil }
        return link.replacingOccurrences(of: ".jpg", with: "s.jpg")// Load "Small Square" version
    }
    
    static func ==(lhs: ImgurImage, rhs: ImgurImage) -> Bool {
        return lhs.id == rhs.id
    }
}

struct IdentifiableImageURL: Identifiable { //sheet(item:onDismiss:content:) expects the item to conform to Identifiable
    let id = UUID()
    let url: String
}
