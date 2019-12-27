//
//  StoryboardHelper.swift
//  MyFriends
//
//  Created by Anna on 12/26/19.
//  Copyright © 2019 Anna. All rights reserved.
//

import Foundation
import UIKit

// Storyboard Files
enum StoryboardFlow: String {
    case main = "Main"
}

// ViewController Storyboard ID's
enum StoryboardControllerID: String {
    case randomVC = "RandomUsersVC"
    case friendsVC = "FriendsVC"
    case userDetailsVC = "UserDetailsVC"
}

extension UIStoryboard {
    
    class func get(flow: StoryboardFlow) -> UIStoryboard {
        return UIStoryboard(name: flow.rawValue, bundle: nil)
    }
    
    class func instantiateFlow(_ flow: StoryboardFlow) -> UIViewController {
        let flowSB = UIStoryboard.get(flow: flow)
        let initialVC = flowSB.instantiateInitialViewController()!
        
        return initialVC
    }
    
    func get(controller controllerID: StoryboardControllerID) -> UIViewController {
        return self.instantiateViewController(withIdentifier: controllerID.rawValue)
    }
    
}

