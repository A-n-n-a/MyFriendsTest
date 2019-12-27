//
//  ViewController.swift
//  MyFriends
//
//  Created by Anna on 12/26/19.
//  Copyright © 2019 Anna. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showOkAlert(title: String? = nil, message: String? = nil) {
        let myAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: nil)
        myAlert.addAction(okAction)
        self.present(myAlert, animated: true, completion: nil)
    }
}
