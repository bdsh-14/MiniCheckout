//
//  ItemDetail.swift
//  MiniCheckout
//
//  Created by Bidisha Biswas on 11/23/20.
//  Copyright © 2020 Stitch Fix. All rights reserved.
//

import Foundation

class Item: Codable {
    var id: Int
    var name: String
    var price: Float
    var brand: String
    var image_url: URL
    var size: String
}
