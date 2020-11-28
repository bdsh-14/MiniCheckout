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
    
    var label = UILabel()
    let padding: CGFloat = 20.0
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(label)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        selectionStyle = .none
        label.translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemGray
        label.numberOfLines = 0
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding)
        ])
    }
}
