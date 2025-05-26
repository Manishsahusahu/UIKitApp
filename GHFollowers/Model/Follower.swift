//
//  Follower.swift
//  GHFollowers
//
//  Created by Manish sahu on 24/05/25.
//

import Foundation
 
struct Follower: Codable, Hashable {
    let login: String
    let avatarUrl: String
    
    var id: String { UUID().uuidString }
    
    static func == (lhs: Follower, rhs: Follower) -> Bool {
        return lhs.id == rhs.id
    }
}
