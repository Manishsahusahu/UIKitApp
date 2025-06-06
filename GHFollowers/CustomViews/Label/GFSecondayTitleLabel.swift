//
//  GFSecondayTitleLabel.swift
//  GHFollowers
//
//  Created by Manish sahu on 27/05/25.
//

import UIKit

class GFSecondayTitleLabel: UILabel {  
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(fontSize: CGFloat) {
        super.init(frame: .zero)
        
        font = UIFont.systemFont(ofSize: fontSize, weight: .medium)
        configure()
    }
    
    private func configure() {
        textColor = .secondaryLabel
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.9
        translatesAutoresizingMaskIntoConstraints = false
        lineBreakMode = .byTruncatingTail 
    }
}
