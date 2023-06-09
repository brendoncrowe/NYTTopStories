//
//  NewsArticleModel.swift
//  NYTTopStories
//
//  Created by Brendon Crowe on 3/18/23.
//

import Foundation

public typealias Writeable = Codable & Equatable

enum ImageFormat: String {
    case superJumbo = "Super Jumbo"
    case thumbLarge = "Large Thumbnail"
}

struct TopStories: Writeable {
    let section: String
    let lastUpdated: String
    let results: [Article]
    
    private enum CodingKeys: String, CodingKey {
        case section
        case lastUpdated = "last_updated"
        case results
    }
}

struct Article: Writeable {
    let section: String
    let title: String
    let abstract: String
    let url: String
    let publishedDate: String
    let byline: String
    let multimedia: [Multimedia]?
    
    private enum CodingKeys: String, CodingKey {
        case section
        case title
        case abstract
        case publishedDate = "published_date"
        case url
        case byline
        case multimedia
    }
    
    static func == (lhs: Article, rhs: Article) -> Bool {
        return lhs.abstract == rhs.abstract && lhs.title == rhs.title
    }
    
}

struct Multimedia: Writeable {
    let url: String
    let format: String
    let height: Double
    let width: Double
    let caption: String
}

extension Article {
    func getArticleImageArticle(for imageFormat: ImageFormat) -> String {
        guard let multimedia = multimedia else { return "" }
        let results = multimedia.filter { $0.format == imageFormat.rawValue }
        guard let multimediaImage = results.first else {
            // result is 0
            return ""
        }
        return multimediaImage.url
    }
}
