//
//  PhoneFormatter.swift
//  MyFriends
//
//  Created by Anna on 12/27/19.
//  Copyright © 2019 Anna. All rights reserved.
//

import Foundation

class PhoneFormatter {
    static func maskedNumber(_ number: String, clear: Bool = false) -> String {
        let cleanPhoneNumber = PhoneFormatter.cleanPhoneNumber(number)
        var mask = ""
        switch cleanPhoneNumber.count {
        case 1:
            mask = "(X"
        case 2:
            mask = "(XX"
        case 3:
            mask = number.count == 4 && clear ? "(XX" : "(XXX)"
        case 4:
            mask = "(XXX) X"
        case 5:
            mask = "(XXX) XX"
        case 6:
            mask = "(XXX) XXX"
        case 7:
            mask = "(XXX) XXX-X"
        case 8:
            mask = "(XXX) XXX-XX"
        case 9:
            mask = "(XXX) XXX-XX-X"
        case 10:
            mask = "(XXX) XXX-XX-XX"
        default:
            mask = "(XXX) XXX-XX-XX"
        }
        
        var result = ""
        var index = cleanPhoneNumber.startIndex
        for character in mask {
            if character == "X" {
                result.append(cleanPhoneNumber[index])
                index = cleanPhoneNumber.index(after: index)
            } else {
                result.append(character)
            }
        }
        return result
    }
    
    static func cleanPhoneNumber(_ number: String) -> String {
        return number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
    }
    
    static func maskedFullNumber(_ number: String) -> String {
        let cleanPhoneNumber = PhoneFormatter.cleanPhoneNumber(number)
        guard cleanPhoneNumber.count == 10 else { return number}
        let mask = "(XXX) XXX-XX-XX"
        
        var result = ""
        var index = cleanPhoneNumber.startIndex
        for character in mask {
            if character == "X" {
                result.append(cleanPhoneNumber[index])
                index = cleanPhoneNumber.index(after: index)
            } else {
                result.append(character)
            }
        }
        return result
    }
}

