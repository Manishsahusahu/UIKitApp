//
//  FollowersListVC.swift
//  GHFollowers
//
//  Created by Manish sahu on 23/05/25.
//

import UIKit

class FollowersListVC: UIViewController {
    
    var username: String = ""
    var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        NetworkManager.shared.getFollowers(for: username, page: 1) { followers,error in
            guard let followers else {
                if let error {
                    self.PresentGFAlertOnMainThread(
                        title: "Could not fetch followers",
                        message: error,
                        buttonTitle: "OK"
                    )
                }
                return
            }
            
            print("Followers fetched successfully")
            print(followers)
        }
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewLayout())
        view.addSubview(collectionView)
        
        collectionView.backgroundColor = .systemPink
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseId)
    }
}
