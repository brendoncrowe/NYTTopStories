//
//  NewsArticleModel.swift
//  NYTTopStories
//
//  Created by Brendon Crowe on 3/18/23.
//

import Foundation

enum ImageFormat: String {
    case superJumbo = "Super Jumbo"
    case thumbLarge = "Large Thumbnail"
}

struct TopStories: Decodable {
    let section: String
    let lastUpdated: String
    let results: [Article]
    
    private enum CodingKeys: String, CodingKey {
        case section
        case lastUpdated = "last_updated"
        case results
    }
}

struct Article: Decodable {
    let section: String
    let title: String
    let abstract: String
    let url: String
    let publishedDate: String
    let byline: String
    let multimedia: [Multimedia]
    
    private enum CodingKeys: String, CodingKey {
        case section
        case title
        case abstract
        case publishedDate = "published_date"
        case url
        case byline
        case multimedia
    }
}

struct Multimedia: Decodable {
    let url: String
    let format: String
    let height: Double
    let width: Double
    let caption: String
}


extension Article {
    func getArticleImageArticle(for imageFormat: ImageFormat) -> String {
        let results = multimedia.filter { $0.format == imageFormat.rawValue }
        guard let multimediaImage = results.first else {
            // result is 0
            return ""
        }
        return multimediaImage.url
    }
}
