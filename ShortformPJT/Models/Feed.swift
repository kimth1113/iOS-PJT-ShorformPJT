//
//  Feed.swift
//  ShortformPJT
//
//  Created by 김태현 on 2023/02/10.
//

import Foundation

struct Feed: Codable {
    let count, page: Int
    let posts: [Post]
}

struct Post: Codable {
    let contents: [Content]
    let description, id: String
    let influencer: Influencer
    let likeCount: Int

    enum CodingKeys: String, CodingKey {
        case contents, description, id, influencer
        case likeCount = "like_count"
    }
}

struct Content: Codable {
    let contentURL: String
    let type: TypeEnum

    enum CodingKeys: String, CodingKey {
        case contentURL = "content_url"
        case type
    }
}

enum TypeEnum: String, Codable {
    case image = "image"
    case video = "video"
}

struct Influencer: Codable {
    let displayName: String
    let followCount: Int
    let profileThumbnailURL: String

    enum CodingKeys: String, CodingKey {
        case displayName = "display_name"
        case followCount = "follow_count"
        case profileThumbnailURL = "profile_thumbnail_url"
    }
}
