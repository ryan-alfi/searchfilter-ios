//
//  Product.swift
//  SearchFilter
//
//  Created by Ari Fajrianda Alfi on 12/11/19.
//  Copyright © 2019 Ryan Alfi. All rights reserved.
//

import Foundation

struct Product: Decodable {
    let id: Int
    let name: String
    let uri: String
    let imageUri: String
    let price: String
}

struct ProductListResponse: Decodable {
    let data: [Product]
}
