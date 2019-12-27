//
//  UserCell.swift
//  MyFriends
//
//  Created by Anna on 12/26/19.
//  Copyright © 2019 Anna. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {
    
    @IBOutlet weak var icon: CustomImageView!
    @IBOutlet weak var nameLabel: UILabel!
    

    var user: User! {
        didSet {
            nameLabel.text = user.name
            icon.retrieveImgeFromLink(user.thumbnail)
        }
    }
    
}
