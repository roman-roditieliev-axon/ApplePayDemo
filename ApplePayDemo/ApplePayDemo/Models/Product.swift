//
//  Product.swift
//  ApplePayDemo
//
//  Created by User on 09.09.2021.
//

import Foundation

struct Product {
    let productName = "Product"
    let currency = "UAH"
    let price: NSDecimalNumber = 100
    let kommission: NSDecimalNumber = 5

    static let shared = Product()
}
