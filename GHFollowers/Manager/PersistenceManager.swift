//
//  PersistenceManager.swift
//  GHFollowers
//
//  Created by Manish sahu on 01/06/25.
//

import Foundation

enum PersistenceManager {
    
    static let defaults = UserDefaults.standard
    
    enum Keys {
        static let favorites = "favorites"
    }
    
    enum ActionType {
        case add, remove
    }
    
    static func update(with follower: Follower, actionType: ActionType, completion: @escaping (Error?) -> Void) {
        retreiveFavorites { result in
            switch result {
            case .success(let favorites):
                var newFavs = favorites
                
                switch actionType {
                case .add:
                    if !favorites.contains(where: { $0.login == follower.login }) {
                        newFavs.append(follower)
                    }
                case .remove:
                    newFavs.removeAll(where: { $0.login == follower.login })
                }
                
                completion(save(favorites: newFavs))
                return
                
            case .failure(let error):
                completion(error)
                return
            }
        }
    }
    
    static func retreiveFavorites(
        completion: @escaping (Result<[Follower], Error>) -> Void
    ) {
        guard let data = defaults.data(forKey: Keys.favorites) else {
            completion(.success([]))
            return
        }
        
        do {
            let favorites = try JSONDecoder().decode([Follower].self, from: data)
            completion(.success(favorites))
        } catch {
            completion(.failure(error))
        }
    }
    
    static func save(favorites: [Follower]) -> Error? {
        do {
            let encodedData = try JSONEncoder().encode(favorites)
            defaults.set(encodedData, forKey: Keys.favorites)
            
            return nil
        } catch {
            return error
        }
    }
}
