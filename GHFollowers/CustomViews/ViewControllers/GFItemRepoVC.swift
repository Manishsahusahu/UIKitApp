//
//  GFItemRepoVC.swift
//  GHFollowers
//
//  Created by Manish sahu on 30/05/25.
//

import UIKit

class GFItemRepoVC: GFItemInfoVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureItems()
    }
    
    private func configureItems() {
        itemInfoViewOne.set(itemInfoType: .repos, count: user.publicRepos)
        itemInfoViewTwo.set(itemInfoType: .gists, count: user.publicGists)
        actionButton.set(backgroundColor: .systemPurple, title: "Github Profile")
    }
    
    override func handleActionButton() {
        delegate?.didTapGithubProfile(user: user)
    }
}
