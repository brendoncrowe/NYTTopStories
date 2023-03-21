//
//  SectionTitleAPI.swift
//  NYTTopStories
//
//  Created by Brendon Crowe on 3/21/23.
//

import Foundation
import NetworkHelper


struct SectionTitleAPI {
    
     static func fetchItems(for section: String, completion: @escaping (Result<String, AppError>) -> ()) {
        let endpoint = "https://api.nytimes.com/svc/topstories/v2/\(section).json?api-key=\(AppKeys.apiKey)"
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
                    let sectionTitle = searchResults.section
                    completion(.success(sectionTitle))
                } catch {
                    completion(.failure(.decodingError(error)))
                }
            }
        }
    }
}
