//
//  NetworkManager.swift
//  MyFriends
//
//  Created by Anna on 12/26/19.
//  Copyright © 2019 Anna. All rights reserved.
//

import Foundation
import Alamofire

typealias Completion = ((_ friends: [User]?, _ error: Error?) -> Void)?
typealias CompletionWithErrorMessage = ((_ friends: [User]?, _ error: Error?, _ errorMessage: String?) -> Void)?
typealias BoolCompletion = ((_ success: Bool) -> Void)?

class NetworkManager {
    
    static var urlBase = "https://randomuser.me/api/?results=20"
    
    static func getFriends(page: Int = 1, completion: CompletionWithErrorMessage) {
        guard let url = URL(string: NetworkManager.urlBase) else {
            completion?(nil, nil, "URL is invalid")
            return
        }
        Alamofire.request(url, method: .get, parameters: [:]).validate()
            .responseJSON { response in
                
                guard response.result.isSuccess else {
                    
                    completion?(nil, response.result.error, nil)
                    return
                }

                guard let value = response.result.value as? [String: Any],
                  let results = value["results"] as? [[String: Any]] else {
                    
                    completion?(nil, nil, "JSON parcing error")
                    return
                }

                var users = [User]()
                for user in results {
                    if let nameDict = user["name"] as? [String: Any],
                        let firstName = nameDict["first"] as? String,
                        let lastName = nameDict["last"] as? String,
                        let picture = user["picture"] as? [String: Any],
                        let largePicture = picture["large"] as? String,
                        let thumbnail = picture["thumbnail"] as? String,
                        let phone = user["phone"] as? String,
                        let email = user["email"] as? String,
                        let idDict = user["id"] as? [String: Any],
                        let id = idDict["value"] as? String {
                        
                        let fullName = "\(firstName) \(lastName)"
                        let newUser = User(id: id, name: fullName, email: email, phone: phone, largePicture: largePicture, thumbnail: thumbnail)
                        users.append(newUser)
                    }
                }
                
                completion?(users, nil, nil)
        }
    }
}


struct UsersResponse: Decodable {
    var results: [User]?
}
