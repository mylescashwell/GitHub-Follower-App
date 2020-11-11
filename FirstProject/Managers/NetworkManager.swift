//
//  NetworkManager.swift
//  FirstProject
//
//  Created by Myles Cashwell on 10/14/20.
//  Copyright © 2020 Myles Cashwell. All rights reserved.
//

import UIKit

class NetworkManager {
    static let shared   = NetworkManager()
    private let baseUrl = "https://api.github.com/users/"
    let cache           = NSCache<NSString, UIImage>()
    var perPage = 100
    
    private init() {}
    // Singleton
    // private init () {} only allows NetworkManager to .call getFollowers function
    // utilizing this Singleton would look like NetworkManager.shared.getFollowers(
    
//---------------------------------------------------------------------------------------------------------------------------------------------
    
    func getFollowers(for username: String, page: Int, completed: @escaping (Result <[Follower], FPError>) -> Void) {
        let endPoint = baseUrl + "\(username)/followers?per_page=\(perPage)&page=\(page)"
    
        
        guard let url = URL(string: endPoint) else {
            completed(.failure(.invalidUsername))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let followers = try decoder.decode([Follower].self, from: data)
                completed(.success(followers))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        
        task.resume()

    }
    
//---------------------------------------------------------------------------------------------------------------------------------------------

    func getUserInfo(for username: String, completed: @escaping (Result <User, FPError>) -> Void) {
        let endPoint = baseUrl + "\(username)"
       
        
        guard let url = URL(string: endPoint) else {
            completed(.failure(.invalidUsername))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let user = try decoder.decode(User.self, from: data)
                
                completed(.success(user))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        
        task.resume()
        
    }
}
