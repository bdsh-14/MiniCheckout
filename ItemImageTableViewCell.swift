//
//  ItemImageTableViewCell.swift
//  MiniCheckout
//
//  Created by Bidisha Biswas on 11/28/20.
//  Copyright © 2020 Stitch Fix. All rights reserved.
//

import UIKit

class ItemImageTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "offer_detail_cell"

    var productImageView = ProductImageView(frame: .zero)
    var padding: CGFloat = 8
    
    var imageUrl: String? {
        didSet {
            URLSession.shared.dataTask(with: NSURL(string: "\(imageUrl ?? "")")! as URL, completionHandler: { (data, _, error) -> Void in

                if error != nil {
                    print(error as Any)
                    return
                }
                DispatchQueue.main.async { () -> Void in
                    let image = UIImage(data: data!)
                    self.productImageView.image = image
                }
            }).resume()
        }
    }
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(productImageView)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        NSLayoutConstraint.activate([
            productImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            productImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
           // productImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding),
            productImageView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
}
