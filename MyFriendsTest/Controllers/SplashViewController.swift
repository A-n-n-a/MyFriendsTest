//
//  ViewController.swift
//  MyFriends
//
//  Created by Anna on 12/26/19.
//  Copyright © 2019 Anna. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        getFriends()
    }

    func getFriends() {
        NetworkManager.getFriends { [weak self] (users, error, errorMessage) in
            DispatchQueue.main.async {
                if error != nil {
                    self?.showOkAlert(title: "Error", message: "Could not retrieve users. Try again later")
                    return
                }
                
                if let errorMessage = errorMessage {
                    self?.showOkAlert(title: "Error", message: errorMessage)
                    return
                }
                
                if let users = users {
                    UserManager.randomUsers = users
                    
                    if let friendsVC = UIStoryboard.get(flow: .main).get(controller: .friendsVC) as? FriendsViewController {
                        self?.navigationController?.setViewControllers([friendsVC], animated: true)
                    }
                }
            }
        }
    }
}

