//
//  TableView.swift
//  MyFriends
//
//  Created by Anna on 12/26/19.
//  Copyright © 2019 Anna. All rights reserved.
//

import UIKit

extension UITableView {
    func registerCell(for cellClass: AnyClass) {
        let bundle = Bundle(for: cellClass)
        let nib = UINib(nibName: String(describing: cellClass), bundle: bundle)
        self.register(nib, forCellReuseIdentifier: String(describing: cellClass))
    }
}
