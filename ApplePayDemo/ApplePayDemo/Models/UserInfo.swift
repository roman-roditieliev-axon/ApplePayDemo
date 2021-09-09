//
//  UserInfo.swift
//  ApplePayDemo
//
//  Created by User on 09.09.2021.
//

import Foundation

struct UserInfo {
    let name = "Roman"
    let email = "testPayment@icloud.com"
    let phoneNumber = "0987771122"
    let address = "Kharkiv"

    static let shared = UserInfo()
}
