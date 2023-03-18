//
//  NYTTopStoriesAPIClient.swift
//  NYTTopStories
//
//  Created by Brendon Crowe on 3/18/23.
//

import Foundation
import NetworkHelper


struct NYYTopStoriesAPIClient {
    
     static func fetchItems(for section: String, completion: @escaping (Result<[Article], AppError>) -> ()) {
        let endpoint = "https://api.nytimes.com/svc/topstories/v2/us.json?api-key=\(AppKeys.apiKey)"
        guard let url = URL(string: endpoint) else {
            completion(.failure(.badURL(endpoint)))
            return
        }
        let request = URLRequest(url: url)
        NetworkHelper.shared.performDataTask(with: request) { result in
            switch result {
            case .failure(let appError):
                completion(.failure(.networkClientError(appError)))
            case .success(let data):
                do {
                    let searchResults = try JSONDecoder().decode(TopStories.self, from: data)
                    let articles = searchResults.results
                    completion(.success(articles))
                } catch {
                    completion(.failure(.decodingError(error)))
                }
            }
        }
    }
}
