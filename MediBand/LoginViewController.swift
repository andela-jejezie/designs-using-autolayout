//
//  LoginViewController.swift
//  MediBand
//
//  Created by Johnson Ejezie on 7/14/15.
//  Copyright (c) 2015 Johnson Ejezie. All rights reserved.
//

import UIKit
import AFNetworking
import SwiftSpinner
import SwiftKeychainWrapper
import SwiftValidator


class LoginViewController: UIViewController, UITextFieldDelegate, ValidationDelegate {
    
    var tap:UITapGestureRecognizer!
    let validator = Validator()

    
    @IBOutlet weak var userNameTextfield: UITextField!
    

    @IBOutlet weak var passwordTextfield: UITextField!
    
    
    
    @IBOutlet weak var loginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let emailString: String? = KeychainWrapper.stringForKey("email")
        let passwordString: String? = KeychainWrapper.stringForKey("password")
        
        if (emailString != nil && passwordString != nil) {
           login(emailString!, password: passwordString!)
        }
            
        userNameTextfield.layer.cornerRadius = 5
        passwordTextfield.layer.cornerRadius = 5
        loginButton.layer.cornerRadius = 4
        
        tap = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)

        // Do any additional setup after loading the view.
        
        
        validator.styleTransformers(success:{ (validationRule) -> Void in
            println("here")
            // clear error label
            validationRule.errorLabel?.hidden = true
            validationRule.errorLabel?.text = ""
            validationRule.textField.layer.borderColor = UIColor.greenColor().CGColor
            validationRule.textField.layer.borderWidth = 0.5
            
            }, error:{ (validationError) -> Void in
                println("error")
                validationError.errorLabel?.hidden = false
                validationError.errorLabel?.text = validationError.errorMessage
                validationError.textField.layer.borderColor = UIColor.redColor().CGColor
                validationError.textField.layer.borderWidth = 1.0
        })
        
        
        
        validator.registerField(userNameTextfield, rules: [RequiredRule(), FullNameRule()])
        validator.registerField(passwordTextfield, rules: [RequiredRule(), FullNameRule()])
    }
    
    override func viewWillAppear(animated: Bool) {
        
        setScreeName("LoginView")
        
    }
    
    func handleSingleTap(sender:UITapGestureRecognizer){
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }


    @IBAction func loginActionButton() {
        
        validator.validate(self)
        
        let saveSuccessful: Bool = KeychainWrapper.setString(passwordTextfield.text, forKey: "password")
        
        let saveSuccessful1: Bool = KeychainWrapper.setString(userNameTextfield.text, forKey: "email")
        println("\(saveSuccessful) and \(saveSuccessful1)")
        trackEvent("UX", action: "login button clicked", label: "login button", value: nil)
    }
    
    func validationSuccessful() {
        login(userNameTextfield.text, password: passwordTextfield.text)
    }
    
    func login(email:String, password:String) {
        SwiftSpinner.show("Connecting...", animated: true)
        let login = Login()
        login.loginUserWith(email, andPassword: password) { (success) -> Void in
            if success == true {
                println("successful")
                self.performSegueWithIdentifier("LoginToPatients", sender: nil)
            }else {
                println("error")
            }
        }
    }
    
    func validationFailed(errors: [UITextField : ValidationError]) {
        setErrors()
    }
    
    private func setErrors(){
        for (field, error) in validator.errors {
            field.layer.borderColor = UIColor.redColor().CGColor
            field.layer.borderWidth = 1.0
            error.errorLabel?.text = error.errorMessage
            error.errorLabel?.hidden = false
        }
    }
    
    
    @IBAction func forgotPasswordActionButton() {
        
        let alertController = UIAlertController(title: "Reset Password", message: "Enter your email", preferredStyle: .Alert)
        
        let OKAction = UIAlertAction(title: "RESET", style: .Default) { (action) in
            // ...
            self.trackEvent("UX", action: "Reset password", label: "Forgot password button", value: nil)
        }
        alertController.addAction(OKAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default) { (action) -> Void in
            //....
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        alertController.addAction(cancelAction)
        
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Email"
            textField.keyboardType = .EmailAddress
        }
        
        self.presentViewController(alertController, animated: true) {
            // ...
        }
    }
    
    

}

extension LoginViewController {
    
    func setScreeName(name: String) {
        self.title = name
        self.sendScreenView(name)
    }
    
    func sendScreenView(screenName: String) {
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: self.title)
        let build = GAIDictionaryBuilder.createScreenView().set(screenName, forKey: kGAIScreenName).build() as NSDictionary

        tracker.send(build as [NSObject: AnyObject])
    }
    
    func trackEvent(category: String, action: String, label: String, value: NSNumber?) {
        let tracker = GAI.sharedInstance().defaultTracker
        let trackDictionary = GAIDictionaryBuilder.createEventWithCategory(category, action: action, label: label, value: value).build()
        tracker.send(trackDictionary as [NSObject: AnyObject])
    }
    
}


