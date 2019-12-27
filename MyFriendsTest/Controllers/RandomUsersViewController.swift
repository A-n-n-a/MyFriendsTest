//
//  RandomUsersViewController.swift
//  MyFriends
//
//  Created by Anna on 12/26/19.
//  Copyright © 2019 Anna. All rights reserved.
//

import UIKit

class RandomUsersViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var currentPage = 1
    var isFetchInProgress = false
    var usersToRefresh: Int {
        return (currentPage - 1) * 20 + 10
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.registerCell(for: UserCell.self)
    }

    func updateFriends(page: Int) {
        NetworkManager.getFriends(page: page) { [weak self] (users, error, errorMessage) in
            DispatchQueue.main.async {
                if let error = error {
                    self?.showOkAlert(title: "Error", message: error.localizedDescription)
                }
                
                if let errorMessage = errorMessage {
                    self?.showOkAlert(title: "Error", message: errorMessage)
                    return
                }
                
                if let users = users {
                    UserManager.randomUsers.append(contentsOf: users)
                    self?.tableView.reloadData()
                }
            }
        }
    }
}

extension RandomUsersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        UserManager.randomUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UserCell.self)) as! UserCell
        let user = UserManager.randomUsers[indexPath.row]
        cell.user = user
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let user = UserManager.randomUsers[indexPath.row]
        CoreDataManager.addFriend(user, completion: { [weak self] (success) in
            if success {
                self?.showOkAlert(message: "\(user.name) was successfully added to the friends list")
            } else {
                self?.showOkAlert(title: "Error", message: "Could not add \(user.name) to the friends list")
            }
        })
            
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = UserManager.randomUsers.count - 1
        if indexPath.row >= lastElement {
            currentPage += 1
            updateFriends(page: currentPage)
        }
    }
}
