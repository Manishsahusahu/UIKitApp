//
//  UserInfoVC.swift
//  GHFollowers
//
//  Created by Manish sahu on 27/05/25.
//

import UIKit

class UserInfoVC: UIViewController {
    let username: String
    var user: User? = nil
    
    let headerView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
        getUserInfo()
        
        layoutUI()
    }
    
    init(username: String) {
        self.username = username
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }

    private func getUserInfo() {
        NetworkManager.shared.getUserInfo(for: username) {
            [weak self] userInfo,
            error in
            guard let self else { return }
            
            if let error = error {
                PresentGFAlertOnMainThread(
                    title: "Fetch User failed",
                    message: error,
                    buttonTitle: "OK"
                )
            }
            
            self.user = userInfo
        }
    }
    
    private func layoutUI() {
        view.addSubview(headerView)
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.backgroundColor = .systemGray6
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            headerView.heightAnchor.constraint(equalToConstant: 180)
        ])
    }
    
}
