//
//  ItemDetail.swift
//  MiniCheckout
//
//  Created by Bidisha Biswas on 11/23/20.
//  Copyright © 2020 Stitch Fix. All rights reserved.
//

import Foundation

class Items: Codable, Equatable {
    static func == (lhs: Items, rhs: Items) -> Bool {
        return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
    var id: Int
    var shipmentItems: [Item]
}

class Item: Codable {
    var id: Int
    var name: String
    var price: String
    var brand: String
    var imageUrl: URL
    var size: String
}
