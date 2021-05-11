//
//  NetworkManager.swift
//  mready
//
//  Created by Arnold Mitricã on 10.05.2021.
//

import UIKit

class NetworkManager {
    static let shared = NetworkManager() // singleton
    private let baseURL = "https://api.github.com/"
    //https://api.github.com/search/repositories?q=iOS&per_page=5&page=1&order=desc
    let cache = NSCache<NSString, UIImage>()
    
    //private init() {}
    
    typealias completionHandler = (Result<[Repositories], GFError>) -> Void
    
    func getRepositories(for topic: String, page: Int, completed: @escaping (Result<Repositories, GFError>) -> Void) {
        let endPoint = baseURL + "search/repositories?q=\(topic)&per_page=10&page=\(page)&order=desc&sort=stars"
        print(endPoint)
        
        guard let url = URL(string: endPoint) else {
            completed(Result.failure(.invalidQuery))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let _ = error {
                completed(Result.failure(.unableToComplete))
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(Result.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(Result.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
               // decoder.keyDecodingStrategy = .convertFromSnakeCase // specifies the type of decoding
                let repositories = try decoder.decode(Repositories.self, from: data)
                completed(Result.success(repositories))
            } catch let error{
                print(error)
                completed(Result.failure(.invalidData))
            }
            
        }
        task.resume()
    }
    
    func getRepoInfo(for repository: String, completed: @escaping (Result<Repository, GFError>) -> Void) {
        let endPoint = baseURL + "\(repository)"
        
        guard let url = URL(string: endPoint) else {
            completed(Result.failure(.invalidQuery))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let _ = error {
                completed(Result.failure(.unableToComplete))
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(Result.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(Result.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase // specifies the type of decoding
                decoder.dateDecodingStrategy = .iso8601
                let user = try decoder.decode(Repository.self, from: data)
                completed(Result.success(user))
            } catch {
                completed(Result.failure(.invalidData))
            }
        }
        task.resume()
    }
    
    func downloadImage(from urlString: String, completed: @escaping (UIImage?) -> Void) {
        let cacheKey = NSString(string: urlString)
        if let image = cache.object(forKey: cacheKey) {
            completed(image)
            return
        }
        
        guard let url = URL(string: urlString) else {
            completed(nil)
            return
        }
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self,
                error == nil,
                let response = response as? HTTPURLResponse, response.statusCode == 200,
                let data = data,
                let image = UIImage(data: data) else {
                    completed(nil)
                    return
            }
            
            self.cache.setObject(image, forKey: cacheKey)
            completed(image)
        }
        task.resume()
    }
}

