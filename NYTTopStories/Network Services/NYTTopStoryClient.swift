//
//  NYTTopStoryClient.swift
//  NYTTopStories
//
//  Created by Laxmikanth Reddy on 12/11/22.
//

import Foundation
import NetworkHelper


struct NYTTopStoriesAPIClient {
    static func fetchTopStories(for section: String, completion: @escaping(Result<[Article], AppError>) -> ()) {
        let endpointURLString = "https://api.nytimes.com/svc/topstories/v2/\(section).json?api-key=\(Config.apiKey)"
        guard let url = URL(string: endpointURLString) else {
            completion(.failure(.badURL(endpointURLString)))
            return
        }
        let request = URLRequest(url: url)
        NetworkHelper.shared.performDataTask(with: request) { result in
            switch result {
            case .failure(let appError):
                completion(.failure(.networkClientError(appError)))
            case .success(let data):
                do {
                    let topStories = try JSONDecoder().decode(TopStories.self, from: data)
                    completion(.success(topStories.results))
                }catch {
                    completion(.failure(.decodingError(error)))
                }
            }
        }
    }
    
}
