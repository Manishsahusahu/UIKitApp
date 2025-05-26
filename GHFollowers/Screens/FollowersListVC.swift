//
//  FollowersListVC.swift
//  GHFollowers
//
//  Created by Manish sahu on 23/05/25.
//

import UIKit

class FollowersListVC: UIViewController {
    
    enum Section {
        case main
    }
    
    var username: String = ""
    var followers = [Follower]()
    var page = 1
    var hasMoreFollowers: Bool = true
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewController()
        configureCollectionView()
        getFollowers(page: page)
        configureDataSource()
    }
    
    private func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(
            frame: view.bounds,
            collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view)
        )
        view.addSubview(collectionView)
        
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseId)
        collectionView.delegate = self
    }
    
    private func getFollowers(page: Int) {
        NetworkManager.shared.getFollowers(for: username, page: page) { [weak self] followers,error in
            guard let followers else {
                if let error {
                    self?.PresentGFAlertOnMainThread(
                        title: "Could not fetch followers",
                        message: error,
                        buttonTitle: "OK"
                    )
                }
                return
            }
            
            if followers.count < 100 { self?.hasMoreFollowers = false }
            
            self?.followers.append(contentsOf: followers)
            self?.updateData()
        }
    }
    
    private func configureDataSource() {
        dataSource = .init(collectionView: collectionView) { collectionView, indexPath, follower in
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: FollowerCell.reuseId,
                for: indexPath
            ) as! FollowerCell
            
            cell.set(follower: follower)
            return cell
        }
    }
    
    private func updateData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    
    private func getMoreFollowers() {
        guard hasMoreFollowers else { return }
        
        page += 1
        getFollowers(page: page)
    }
}

extension FollowersListVC: UICollectionViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.height
        
        if offsetY > contentHeight - frameHeight {
            getMoreFollowers()
        }
    }
}
