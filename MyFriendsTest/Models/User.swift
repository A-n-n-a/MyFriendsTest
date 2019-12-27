//
//  Friend.swift
//  MyFriends
//
//  Created by Anna on 12/26/19.
//  Copyright © 2019 Anna. All rights reserved.
//

import Foundation

struct User: Decodable {
    
    let id: String
    let name: String
    let email: String
    let phone: String
    let largePicture: String
    let thumbnail: String
}
