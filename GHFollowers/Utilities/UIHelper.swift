//
//  UIHelper.swift
//  GHFollowers
//
//  Created by Manish sahu on 25/05/25.
//

import UIKit

struct UIHelper {
    static func createThreeColumnFlowLayout(in view: UIView) -> UICollectionViewFlowLayout {
        let width = view.bounds.width
        let padding: CGFloat = 12
        let minItemSpacing: CGFloat =  10
        let availableWidth = width - (2 * padding) - (minItemSpacing * 2)
        let itemWidth = availableWidth / 3
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = .init(width: itemWidth, height: itemWidth + 40 )
        flowLayout.sectionInset = .init(top: padding, left: padding, bottom: padding, right: padding)
        
        return flowLayout
    }
}
