//
//  TitleTableViewCell.swift
//  MiniCheckout
//
//  Created by Bidisha Biswas on 11/27/20.
//  Copyright © 2020 Stitch Fix. All rights reserved.
//

import UIKit

class TitleTableViewCell: UITableViewCell {
    
    static let reuseIdentifier: String = "headingBodyTableViewCell"
    
    var brandLabel = UILabel()
    var nameLabel = UILabel()
    let padding: CGFloat = 20.0
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(brandLabel)
        contentView.addSubview(nameLabel)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        selectionStyle = .none
        brandLabel.translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        brandLabel.numberOfLines = 0
        brandLabel.textAlignment = .left
        brandLabel.lineBreakMode = .byWordWrapping
        brandLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        nameLabel.numberOfLines = 0
        nameLabel.textAlignment = .left
        nameLabel.lineBreakMode = .byWordWrapping
        nameLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        
        
        
        NSLayoutConstraint.activate([
            brandLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            brandLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            brandLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            brandLabel.bottomAnchor.constraint(equalTo: nameLabel.topAnchor, constant: -8),
            
            nameLabel.topAnchor.constraint(equalTo: brandLabel.bottomAnchor, constant: padding),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding),
            
            
        ])
    }
}
