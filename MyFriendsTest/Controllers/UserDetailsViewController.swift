//
//  UserDetailsViewController.swift
//  MyFriends
//
//  Created by Anna on 12/27/19.
//  Copyright © 2019 Anna. All rights reserved.
//

import UIKit

class UserDetailsViewController: UIViewController {

    @IBOutlet weak var icon: CustomImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    
    var user: User!
    
    let phoneMask = "(000) 000-00-00"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save))
           navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))

        setupUI()
    }
    

    func setupUI() {
        
        icon.retrieveImgeFromLink(user.largePicture)
        nameLabel.text = user.name
        emailTextField.text = user.email
        
        let maskedNumber =  PhoneFormatter.maskedNumber(user.phone)
        phoneTextField.text = maskedNumber
    }

    
    @objc func cancel() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func save() {
        let phone = phoneTextField.text
        let email = emailTextField.text
        
        guard isPhoneLengthValid(phone: phone) else {
            phoneTextField.backgroundColor = UIColor.red.withAlphaComponent(0.2)
            if !isEmailValid(email: email) {
                emailTextField.backgroundColor = UIColor.red.withAlphaComponent(0.2)
            }
            return
        }
        
        guard isEmailValid(email: email) else {
            emailTextField.backgroundColor = UIColor.red.withAlphaComponent(0.2)
            return
        }
        
        CoreDataManager.editUserData(user: user, phone: phone, email: email) { [weak self] (success) in
            if success {
                self?.navigationController?.popViewController(animated: true)
            } else {
                self?.showOkAlert(title: "Error", message: "Could not edit contacts/ Try again later")
            }
        }
    }
    
    func isEmailValid(email: String?) -> Bool {
        if let email = email {
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

            let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            return emailPredicate.evaluate(with: email)
        }
        return false
    }
    
    func isPhoneLengthValid(phone: String?) -> Bool {
        if let phone = phone {
            return PhoneFormatter.cleanPhoneNumber(phone).count == 10
        }
        return false
    }
}

extension UserDetailsViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == emailTextField {
            emailTextField.backgroundColor = .white
            return true
        }
        
        if textField == phoneTextField, let text = textField.text, let textRange = Range(range, in: text), range.location < phoneMask.count {
            phoneTextField.backgroundColor = .white
            let phone = text.replacingCharacters(in: textRange, with: string)
            let maskedNumber =  PhoneFormatter.maskedNumber(phone, clear: string == "")
            textField.text = maskedNumber
        }
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
