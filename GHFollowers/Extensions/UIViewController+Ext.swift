//
//  UIViewController+Ext.swift
//  GHFollowers
//
//  Created by Manish sahu on 24/05/25.
//

import UIKit
import SafariServices

fileprivate var containerView: UIView!

extension UIViewController {
    func PresentGFAlertOnMainThread(title: String, message: String, buttonTitle: String) {
        DispatchQueue.main.async {
            let alert = GFAlertVC(alertTitle: title, message: message, buttonTitle: buttonTitle)
            alert.modalPresentationStyle = .overFullScreen
            alert.modalTransitionStyle = .crossDissolve
            
            self.present(alert, animated: true)
        }
    }
    
    func PresentSafariVC(with url: URL) {
        let safariVC = SFSafariViewController(url: url)
        safariVC.preferredControlTintColor = .systemGreen
        
        present(safariVC, animated: true)
    }
    
    func showLoadingView() {
        containerView = UIView(frame: view.bounds)
        view.addSubview(containerView)
        
        containerView.backgroundColor = .systemBackground
        containerView.alpha = 0
        
        UIView.animate(withDuration: 0.25) {
            containerView.alpha = 0.8
        }
        
        let activityIndicatorView = UIActivityIndicatorView(style: .large)
        activityIndicatorView.startAnimating()
        activityIndicatorView.center = containerView.center
        containerView.addSubview(activityIndicatorView)
    }
    
    func dismissLoadingView() {
        Task {
            await MainActor.run {
                containerView.removeFromSuperview()
                containerView = nil
            }
        }
    }
    
    func showGFEmptyStateView(message: String, view: UIView) {
        Task {
            await MainActor.run {
                let emptyStateView = GFEmptyStateView(message: message)
                emptyStateView.frame = view.bounds
                view.addSubview(emptyStateView)
            }
        }
    }
}
