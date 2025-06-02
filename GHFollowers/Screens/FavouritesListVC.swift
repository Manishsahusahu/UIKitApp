//
//  FavouritesListVC.swift
//  GHFollowers
//
//  Created by Manish sahu on 23/05/25.
//

import UIKit

class FavouritesListVC: UIViewController {
    let tableView = UITableView()
    var favorites: [Follower] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewcontroller()
    }
    
    private func configureViewcontroller() {
        view.backgroundColor = .systemBackground
        self.edgesForExtendedLayout = []
        title = "Favorites"
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.rowHeight = 80
        tableView.register(FavoriteCell.self, forCellReuseIdentifier: FavoriteCell.reuseId)
    }
    
    private func getFavoritesData() {
        PersistenceManager.retreiveFavorites { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let favorites):
                self.favorites = favorites
            case .failure(let failure):
                break
            }
        }
    }
}

extension FavouritesListVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteCell.reuseId) as! FavoriteCell
        let favorite = favorites[indexPath.row]
        
        cell.set(favorite: favorite)
        return cell
    }
}
