//
//  FollowersListVC.swift
//  GHFollowers
//
//  Created by Manish sahu on 23/05/25.
//

import UIKit

protocol FollowerListVCDelegate: AnyObject {
    func didRequestFollowers(for username: String)
}

class FollowersListVC: UIViewController {
    enum Section {
        case main
    }
    
    var username: String = ""
    var followers = [Follower]()
    var filteredFollowers = [Follower]()
    var page = 1
    var hasMoreFollowers: Bool = true
    var isSearching = false
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewController()
        configureCollectionView()
        getFollowers(page: page)
        configureDataSource()
        configureSearchController()
    }
    
    private func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
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
        showLoadingView()
        
        NetworkManager.shared.getFollowers(for: username, page: page) { [weak self] followers,error in
            guard let self else { return }
            
            self.dismissLoadingView()
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
            
            if followers.count < 100 { self.hasMoreFollowers = false }
            
            self.followers.append(contentsOf: followers)
            
            if self.followers.isEmpty {
                let message = "No followers found for \(self.username)"
                Task {
                    await MainActor.run {
                        self.showGFEmptyStateView(message: message, view: self.view)
                    }
                }
                return
            }
            self.updateData(on: self.followers)
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
    
    private func updateData(on followers: [Follower]) {
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
    
    private func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search for a username"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self
    }
    
    @objc private func addButtonTapped() {
        NetworkManager.shared.getUserInfo(for: username) { [weak self] user, error in
            guard let self else { return }
            
            if let error {
                self.PresentGFAlertOnMainThread(
                    title: "Unable to fetch user info.",
                    message: "",
                    buttonTitle: "Ok"
                )
            }
        }
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let searchingArray = isSearching ? filteredFollowers : followers
        let follower = searchingArray[indexPath.item]
        
        let destinationVC = UserInfoVC(username: follower.login)
        destinationVC.delegate = self
        let navController = UINavigationController(rootViewController: destinationVC)
        present(navController, animated: true)
    }
}

extension FollowersListVC: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            if !searchText.isEmpty {
                filteredFollowers = followers.filter { $0.login.contains(searchText) }
                updateData(on: filteredFollowers)
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        updateData(on: self.followers)
    }
}

extension FollowersListVC: FollowerListVCDelegate {
    func didRequestFollowers(for username: String) {
        page = 1
        self.username = username
        self.title = username
        followers.removeAll()
        filteredFollowers.removeAll()
        getFollowers(page: page)
    }
    
}
