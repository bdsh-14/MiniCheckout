//
//  ProductImageView.swift
//  MiniCheckout
//
//  Created by Bidisha Biswas on 11/28/20.
//  Copyright © 2020 Stitch Fix. All rights reserved.
//

import UIKit

class ProductImageView: UIImageView {
    
    let cache = NSCache<NSString, UIImage>()
    
    let placeHolderImage = UIImage(named: "Placeholder_image")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        layer.cornerRadius = 5
        contentMode = .scaleAspectFit
        clipsToBounds = true
        image = placeHolderImage
        heightAnchor.constraint(equalToConstant: 200).isActive = true
        widthAnchor.constraint(equalToConstant: 200).isActive = true
        translatesAutoresizingMaskIntoConstraints = false
    }
}
