//
//  SearchVC.swift
//  GHFollowers
//
//  Created by Manish sahu on 23/05/25.
//

import UIKit

class SearchVC: UIViewController {
    
    let logoImageView = UIImageView()
    let userNameTextField = GFTextField()
    let calltoActionButton = GFButton(backgroundColor: .systemGreen, title: "Get Followers")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = []
        view.backgroundColor = .systemBackground
        configureLogoImageView()
        configureTextField()
        configureCTAButton()
        createDismissKeyboardTapGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    private func createDismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    @objc private func pushFollowersVC() {
        guard let username = userNameTextField.text, !username.isEmpty else {
            PresentGFAlertOnMainThread(title: "Empty Username", message: "Kindly enter the username, we need to know, whom to look for.", buttonTitle: "OK")
            
            return
        }
        
        let followersVC = FollowersListVC()
        followersVC.username = userNameTextField.text ?? ""
        followersVC.title = userNameTextField.text ?? ""
        navigationController?.pushViewController(followersVC, animated: true)
    }
    
    private func configureLogoImageView() {
        view.addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = UIImage(named: "logo")
        
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            logoImageView.heightAnchor.constraint(equalToConstant: 200),
            logoImageView.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    private func configureTextField() {
        view.addSubview(userNameTextField)
        userNameTextField.delegate = self
        
        NSLayoutConstraint.activate([
            userNameTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 48),
            userNameTextField.heightAnchor.constraint(equalToConstant: 50),
            userNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            userNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
        ])
    }
    
    private func configureCTAButton() {
        view.addSubview(calltoActionButton)
        calltoActionButton.addTarget(self, action: #selector(pushFollowersVC), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            calltoActionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -48),
            calltoActionButton.heightAnchor.constraint(equalToConstant: 50),
            calltoActionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            calltoActionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
        ])
    }
}

extension SearchVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        pushFollowersVC()
        return true
    }
}
