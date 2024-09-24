import Foundation

struct ImgurSearchResponse: Decodable {
    let data: [ImgurImageWrapper]
    let success: Bool
    let status: Int
}

struct ImgurImageWrapper: Identifiable, Codable {
    let id: String
    let title: String?
    let description: String?
    let datetime: Int
    let cover: String?
    let coverWidth: Int?
    let coverHeight: Int?
    let accountUrl: String?
    let accountId: Int?
    let privacy: String?
    let layout: String?
    let views: Int?
    let link: String?
    let ups: Int?
    let downs: Int?
    let points: Int?
    let score: Int?
    let isAlbum: Bool
    let vote: String?
    let favorite: Bool
    let nsfw: Bool
    let section: String?
    let commentCount: Int?
    let favoriteCount: Int?
    let topic: String?
    let topicId: String?
    let imagesCount: Int?
    let inGallery: Bool
    let isAd: Bool
    let tags: [ImgurTag]?
    let images: [ImgurImage]?

    enum CodingKeys: String, CodingKey {
        case id, title, description, datetime, cover
        case coverWidth = "cover_width"
        case coverHeight = "cover_height"
        case accountUrl = "account_url"
        case accountId = "account_id"
        case privacy, layout, views, link, ups, downs, points, score
        case isAlbum = "is_album"
        case vote, favorite, nsfw, section
        case commentCount = "comment_count"
        case favoriteCount = "favorite_count"
        case topic, topicId = "topic_id"
        case imagesCount = "images_count"
        case inGallery = "in_gallery"
        case isAd = "is_ad"
        case tags, images
    }
}


struct ImgurImage: Codable, Identifiable, Equatable {
    let id: String
    let title: String?
    let description: String?
    let datetime: Int?
    let type: String?
    let link: String?
    
    // Thumbnail URL derived from the original link
    var thumbnailLink: String? {
        guard let link = link else { return nil }
        return link.replacingOccurrences(of: ".jpg", with: "s.jpg")
    }
    
    static func ==(lhs: ImgurImage, rhs: ImgurImage) -> Bool {
        return lhs.id == rhs.id
    }
}

struct ImgurTag: Codable {
    let name: String
    let displayName: String
    // Add other properties based on your needs
}

struct IdentifiableImageURL: Identifiable {
    let id = UUID()
    let url: String
}
