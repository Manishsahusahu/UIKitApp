//
//  GFItemFollowersVC.swift
//  GHFollowers
//
//  Created by Manish sahu on 30/05/25.
//

import UIKit

class GFItemFollowersVC: GFItemInfoVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureItems()
    }
    
    private func configureItems() {
        itemInfoViewOne.set(itemInfoType: .followers, count: user.followers)
        itemInfoViewTwo.set(itemInfoType: .following, count: user.following)
        actionButton.set(backgroundColor: .systemGreen, title: "Get Followers")
    }
    
    override func handleActionButton() {
        delegate?.didTapGithubProfile()
    }
}
