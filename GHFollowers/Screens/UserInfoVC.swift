//
//  UserInfoVC.swift
//  GHFollowers
//
//  Created by Manish sahu on 27/05/25.
//

import UIKit
import SafariServices

protocol UserInfoVCDelegate: AnyObject {
    func didTapGithubProfile(user: User)
    func didTapGetFollowers(user: User)
}

class UserInfoVC: UIViewController {
    let username: String
    var user: User? = nil
    weak var delegate: FollowerListVCDelegate!
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    let headerView = UIView()
    let itemViewOne = UIView()
    let itemViewTwo = UIView()
    let dateLabel = GFBodyLabel(textAlignment: .center)
    var itemViews: [UIView] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
        getUserInfo()
        
        configureScrollView()
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
            
            if let userInfo {
                self.user = userInfo
                Task { await MainActor.run {
                    self.configureUIElements(with: userInfo)
                }}
            }
        }
    }
    
    private func configureScrollView() {
        view.addSubview(scrollView)
        view.addSubview(contentView)
        
        scrollView.pinToEdges(of: view)
        contentView.pinToEdges(of: scrollView)
        
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 2000 )
        ])
        
    }
    
    private func configureUIElements(with user: User) {
        let repoVC = GFItemRepoVC(user: user)
        repoVC.delegate = self
        let followersVC = GFItemFollowersVC(user: user)
        followersVC.delegate = self
        
        self.add(childVC: GFUserInfoHeaderVC(user: user), to: self.headerView)
        self.add(childVC: repoVC, to: self.itemViewOne)
        self.add(childVC: followersVC, to: self.itemViewTwo)
        self.dateLabel.text = "Github since \(user.createdAt.convertToDisplayFormat())"
    }
    
    private func layoutUI() {
        let padding: CGFloat = 20
        let itemHeight: CGFloat = 140
        
        itemViews = [headerView, itemViewOne, itemViewTwo, dateLabel]
        for itemView in itemViews {
            contentView.addSubview(itemView)
            itemView.translatesAutoresizingMaskIntoConstraints = false
            itemView.backgroundColor = .systemBackground
            
            NSLayoutConstraint.activate([
                itemView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
                itemView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding)
            ])
        }
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 180),
            
            itemViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
            itemViewOne.heightAnchor.constraint(equalToConstant: itemHeight),
            
            itemViewTwo.topAnchor.constraint(equalTo: itemViewOne.bottomAnchor, constant: padding),
            itemViewTwo.heightAnchor.constraint(equalToConstant: itemHeight),
            
            dateLabel.topAnchor.constraint(equalTo: itemViewTwo.bottomAnchor, constant: padding),
            dateLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
    
    private func add(childVC: UIViewController, to containerView: UIView) {
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }
}

extension UserInfoVC: UserInfoVCDelegate {
    func didTapGithubProfile(user: User) {
        guard let url = URL(string: user.htmlUrl) else {
            PresentGFAlertOnMainThread(title: "Invalid URL", message: "", buttonTitle: "Ok")
            
            return
        }
        
        PresentSafariVC(with: url)
    }
    
    func didTapGetFollowers(user: User) {
        guard user.followers != 0 else {
            PresentGFAlertOnMainThread(title: "No Followers", message: "", buttonTitle: "Oh!")
            
            return
        }
        delegate.didRequestFollowers(for: user.login)
        dismissVC()
    }
    
}
