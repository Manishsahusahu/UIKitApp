//
//  NetworkManager.swift
//  GHFollowers
//
//  Created by Manish sahu on 25/05/25.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    let baseUrl = "https://api.github.com/users/"
    
    private init() {}
    
    func getFollowers(
        for username: String,
        page: Int,
         completion: @escaping ([Follower]?, String?) -> Void
    ) {
        let urlString = "\(baseUrl)\(username)/followers?per_page=100$page=\(page)"
        guard let url = URL(string: urlString) else {
            completion(nil, "URL request failed. Please try again later.")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error {
                completion(nil, error.localizedDescription)
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(nil, "Invalid status code. Please try again.")
                return
            }
            
            guard let data else {
                completion(nil, "Invalid data received. Please try again later.")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let followers = try decoder.decode([Follower].self, from: data)
                
                completion(followers, nil)
            } catch {
                completion(nil, error.localizedDescription)
            }
        }.resume()
    }
}
