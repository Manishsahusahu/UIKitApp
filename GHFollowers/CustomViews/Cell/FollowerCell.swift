//
//  FollowerCell.swift
//  GHFollowers
//
//  Created by Manish sahu on 25/05/25.
//

import UIKit

class FollowerCell: UICollectionViewCell {
    static let reuseId = "FollowersCell"
    
    let avatarImageView = UIImageView()
    let usernameLabel = GFTitleLabel(textAlignment: .center, fontSize: 16)
}
