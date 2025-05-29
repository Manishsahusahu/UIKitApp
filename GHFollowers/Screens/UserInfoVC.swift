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

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    init(username: String) {
        self.username = username
        super.init(nibName: nil, bundle: nil)
        
        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
        getUserInfo()
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
    
}
