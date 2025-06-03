//
//  UIView+Ext.swift
//  GHFollowers
//
//  Created by Manish sahu on 03/06/25.
//

import UIKit

extension UIView {
    func pinToEdges(of view: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: view.topAnchor),
            self.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            self.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}
