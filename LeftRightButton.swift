//
//  LeftRightButton.swift
//  MiniCheckout
//
//  Created by Bidisha Biswas on 11/28/20.
//  Copyright © 2020 Stitch Fix. All rights reserved.
//

import UIKit

class LeftRightButton: UIButton {
    
    var buttonImage = UIImage()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        clipsToBounds = true
        setImage(buttonImage, for: .normal)
        translatesAutoresizingMaskIntoConstraints = false
        setTitleColor(.systemGreen, for: .normal)
    }
}
