//
//  UIViewController+Ext.swift
//  GHFollowers
//
//  Created by Manish sahu on 24/05/25.
//

import UIKit

extension UIViewController {
    func PresentGFAlertOnMainThread(title: String, message: String, buttonTitle: String) {
        DispatchQueue.main.async {
            let alert = GFAlertVC(alertTitle: title, message: message, buttonTitle: buttonTitle)
            alert.modalPresentationStyle = .overFullScreen
            alert.modalTransitionStyle = .crossDissolve
            
            self.present(alert, animated: true)
        }
    }
}
