//
//  FriendsViewController.swift
//  MyFriends
//
//  Created by Anna on 12/27/19.
//  Copyright © 2019 Anna. All rights reserved.
//

import UIKit

class FriendsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var friends = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewFriend))

        tableView.registerCell(for: UserCell.self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getFriends()
    }

    func getFriends() {
        DispatchQueue.global(qos: .background).async {
            CoreDataManager.fetchFriends { [weak self] (friends, error) in
                DispatchQueue.main.async {
                    if let error = error {
                        self?.showOkAlert(title: "Error", message: error.localizedDescription)
                    }
                    if let friends = friends {
                        self?.friends = friends
                        self?.tableView.reloadData()
                    }
                }
            }
        }
        
    }

    @objc func addNewFriend() {
        if let randomVC = UIStoryboard.get(flow: .main).get(controller: .randomVC) as? RandomUsersViewController {
            self.navigationController?.pushViewController(randomVC, animated: true)
        }
    }
    
    func unfriendUser(at indexPath: IndexPath) {
        CoreDataManager.unfriendUser(user: friends[indexPath.row]) { [weak self] (success) in
            if success {
                self?.friends.remove(at: indexPath.row)
                self?.tableView.deleteRows(at: [indexPath], with: .bottom)
            } else {
                self?.showOkAlert(title: "Error", message: "Try again later")
            }
        }
    }
}

extension FriendsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UserCell.self)) as! UserCell
        let user = friends[indexPath.row]
        cell.user = user
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let user = friends[indexPath.row]
        if let userDetailsVC = UIStoryboard.get(flow: .main).get(controller: .userDetailsVC) as? UserDetailsViewController {
            userDetailsVC.user = user
            self.navigationController?.pushViewController(userDetailsVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            unfriendUser(at: indexPath)
        }
    }
}
