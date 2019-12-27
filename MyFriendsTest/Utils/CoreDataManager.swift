//
//  CoreDataManager.swift
//  MyFriends
//
//  Created by Anna on 12/27/19.
//  Copyright © 2019 Anna. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager {
    
    static var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MyFriendsTest")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    static func addFriend(_ friend: User, completion: BoolCompletion) {
        
        if CoreDataManager.friendExists(user: friend) {
            if CoreDataManager.userIsFriend(user: friend) {
                completion?(true)
                return
            } else {
                makeFriend(user: friend) { (success) in
                    completion?(success)
                }
            }
        }
        
        let context = CoreDataManager.persistentContainer.viewContext
        guard let newFriend = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as? Friend else {
                completion?(false)
                return
        }
        
        newFriend.id = friend.id
        newFriend.name = friend.name
        newFriend.phone = friend.phone
        newFriend.email = friend.email
        newFriend.isFriend = true
        newFriend.largePicture = friend.largePicture
        newFriend.thumbnail = friend.thumbnail
        
        
        do {
            try context.save()
            completion?(true)
        } catch let error as NSError {
            #if DEBUG
            print("Could not save. \(error), \(error.userInfo)")
            #endif
            completion?(false)
        }
    }
    
     static func fetchFriends(completion: Completion) {
        var users = [User]()
        let context = CoreDataManager.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Friend")
        fetchRequest.predicate = NSPredicate(format: "isFriend = true")
        
        do {
            let friends = try context.fetch(fetchRequest)
            for friend in friends {
                if let user = CoreDataManager.mapManagedObject(friend) {
                    users.append(user)
                }
            }
            completion?(users, nil)
        } catch let error as NSError {
            #if DEBUG
            print("Could not fetch. \(error), \(error.userInfo)")
            #endif
            completion?(nil, error)
        }
        
    }
    
    static func friendExists(user: User) -> Bool {
        let context = CoreDataManager.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Friend")
        fetchRequest.predicate = NSPredicate(format: "id = %@", user.id)
        do {
            let friends = try context.fetch(fetchRequest)
            if let _ = friends.first {
                return true
            }
        } catch let error as NSError {
            #if DEBUG
            print("Could not fetch user. \(error), \(error.userInfo)")
            #endif
            return false
        }
        return false
    }
    
    static func userIsFriend(user: User) -> Bool {
        let context = CoreDataManager.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Friend")
        fetchRequest.predicate = NSPredicate(format: "id = %@", user.id)
        do {
            let friends = try context.fetch(fetchRequest)
            if let friend = friends.first as? Friend {
                return friend.isFriend
            }
        } catch let error as NSError {
            #if DEBUG
            print("Could not fetch user. \(error), \(error.userInfo)")
            #endif
            return false
        }
        return false
    }
    
    
    static func unfriendUser(user: User, completion: BoolCompletion) {
        
        let context = CoreDataManager.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Friend")
        fetchRequest.predicate = NSPredicate(format: "id = %@", user.id)

        do {
            let friends = try context.fetch(fetchRequest)
            if let friend = friends.first as? Friend {
                friend.isFriend = false
            }
            try context.save()
            completion?(true)
        } catch let error as NSError {
            #if DEBUG
            print("Could not fetch user. \(error), \(error.userInfo)")
            #endif
            completion?(false)
        }
    }
    
    static func makeFriend(user: User, completion: BoolCompletion) {
        
        let context = CoreDataManager.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Friend")
        fetchRequest.predicate = NSPredicate(format: "id = %@", user.id)

        do {
            let friends = try context.fetch(fetchRequest)
            if let friend = friends.first as? Friend {
                friend.isFriend = true
            }
            try context.save()
            completion?(true)
        } catch let error as NSError {
            #if DEBUG
            print("Could not fetch user. \(error), \(error.userInfo)")
            #endif
            completion?(false)
        }
    }
    
    static func editUserData(user: User, phone: String?, email: String?, completion: BoolCompletion) {
        
        let context = CoreDataManager.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Friend")
        fetchRequest.predicate = NSPredicate(format: "id = %@", user.id)

        do {
            let friends = try context.fetch(fetchRequest)
            if let friend = friends.first as? Friend {
                if let phone = phone {
                    friend.phone = phone
                }
                if let email = email {
                    friend.email = email
                }
            }
            try context.save()
            completion?(true)
        } catch let error as NSError {
            #if DEBUG
            print("Could not fetch user. \(error), \(error.userInfo)")
            #endif
            completion?(false)
        }
    }
    
    static func deleteAllRecords() {
        
        let context = CoreDataManager.persistentContainer.viewContext
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "MyFriendsTest")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do
        {
            try context.execute(deleteRequest)
            try context.save()
        }
        catch {
            #if DEBUG
            print(error)
            #endif
        }
    }
    
    static func mapManagedObject(_ managedObject: NSManagedObject) -> User? {
        guard let friend = managedObject as? Friend,
            let id = friend.id,
            let name = friend.name,
            let email = friend.email,
            let phone = friend.phone,
            let large = friend.largePicture,
            let thumb = friend.thumbnail else {
            return nil
        }
        let user = User(id: id, name: name, email: email, phone: phone, largePicture: large, thumbnail:  thumb)
        
        return user
    }
}

