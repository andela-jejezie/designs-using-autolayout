//
//  SettingsViewController.swift
//  MediBand
//
//  Created by Johnson Ejezie on 9/20/15.
//  Copyright © 2015 Johnson Ejezie. All rights reserved.
//

import UIKit
import XLForm
import SwiftSpinner
class SettingsViewController: XLFormViewController {

    @IBOutlet var navBar: UIBarButtonItem!
    
    private enum Tags : String {
        
        case emptyname = "emptyname"
        case profile = "profile"
        case password = "password"
        case HideRow = "HideRow"
        case themeSection = "themeSection"
        case theme1 = "theme1"
        case theme2 = "theme2"
        case theme3 = "theme3"
        case theme4 = "theme4"
        case theme5 = "theme5"
    }
    
    override func viewDidLoad() {
        
        if self.revealViewController() != nil {
            navBar.target = self.revealViewController()
            navBar.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        super.viewDidLoad()
        self.tableView.contentInset = UIEdgeInsetsMake(75, 0, 0, 0)
        self.tableView.backgroundColor = UIColor.whiteColor()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        self.setScreeName("Settings")
   
    }
    
    override func viewWillAppear(animated: Bool) {
          UINavigationBar.appearance().barTintColor = sharedDataSingleton.theme
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initializeForm()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.initializeForm()
    }
    
    
    @IBAction func saveActionButton() {
        
    }
    
    func initializeForm() {
        
        let form : XLFormDescriptor
        var section : XLFormSectionDescriptor
        var row : XLFormRowDescriptor
        
        
        form = XLFormDescriptor(title: "Patient Form")
        
        section = XLFormSectionDescriptor.formSection()
        form.addFormSection(section)
        
        section.title = "ACOUNT SETTING"
        row = XLFormRowDescriptor(tag: Tags.password.rawValue, rowType: XLFormRowDescriptorTypeButton, title: "Change Password")
        row.action.formSelector = "loadResetPasswordAlert"
        section.addFormRow(row)
        
        row = XLFormRowDescriptor(tag: Tags.profile.rawValue, rowType: XLFormRowDescriptorTypeButton, title: "Change Profile Picture")
        row.action.formSegueIdenfifier = "changeProfilePicture"
        section.addFormRow(row)
        
        row = XLFormRowDescriptor(tag: Tags.themeSection.rawValue, rowType: XLFormRowDescriptorTypeBooleanSwitch, title: "Show theme")
        row.hidden = "$\(Tags.HideRow.rawValue)==0"
        row.value = 0
        section.addFormRow(row)
        
        section = XLFormSectionDescriptor()
        section.title = "Theme"
        section.footerTitle = "Select theme"
        section.hidden = "$\(Tags.themeSection.rawValue)==0"
        form.addFormSection(section)
        
        row = XLFormRowDescriptor(tag: Tags.theme1.rawValue, rowType: XLFormRowDescriptorTypeButton, title: "Purple")
        row.action.formSelector = "purpleColor"
        section.addFormRow(row)
        
        row = XLFormRowDescriptor(tag: Tags.theme2.rawValue, rowType: XLFormRowDescriptorTypeButton, title: "Orange")
        row.action.formSelector = "orangeColor"
        section.addFormRow(row)
        
        row = XLFormRowDescriptor(tag: Tags.theme3.rawValue, rowType: XLFormRowDescriptorTypeButton, title: "Sky Blue")
        row.action.formSelector = "skyblue"
        section.addFormRow(row)
        
        row = XLFormRowDescriptor(tag: Tags.theme4.rawValue, rowType: XLFormRowDescriptorTypeButton, title: "Brown")
        row.action.formSelector = "brownColor"
        section.addFormRow(row)
        self.form = form
    }
        
    func purpleColor(){
        NSUserDefaults.standardUserDefaults().setColor(UIColor.purpleColor(), forKey: "themeColor");
        sharedDataSingleton.theme = UIColor.purpleColor()
        self.viewDidLoad()
        self.viewWillAppear(true)
    }
    
    func orangeColor(){
        NSUserDefaults.standardUserDefaults().setColor(UIColor.orangeColor(), forKey: "themeColor");
        sharedDataSingleton.theme = UIColor.orangeColor()
        self.viewDidLoad()
        self.viewWillAppear(true)
    }
    func skyblue(){
        NSUserDefaults.standardUserDefaults().setColor(UIColor(red: 0.16, green: 0.89, blue: 0.98, alpha: 1.0), forKey: "themeColor");
        sharedDataSingleton.theme = UIColor(red: 0.16, green: 0.89, blue: 0.98, alpha: 1.0)
        self.viewDidLoad()
        self.viewWillAppear(true)
    }
    func brownColor(){
        NSUserDefaults.standardUserDefaults().setColor(UIColor.brownColor(), forKey: "themeColor");
        sharedDataSingleton.theme = UIColor.brownColor()
        self.viewDidLoad()
        self.viewWillAppear(true)
    }
    
    
    func loadResetPasswordAlert(){
        let alertView = SCLAlertView()
        let emailTextField: UITextField = alertView.addTextField("email")
        let oldPasswordTextField: UITextField = alertView.addTextField("old password")
        let newPasswordTextField: UITextField = alertView.addTextField("new password")
        alertView.addButton("Reset", validationBlock: { () -> Bool in
            let passedValidation:Bool = !emailTextField.text!.isEmpty && !oldPasswordTextField.text!.isEmpty && !newPasswordTextField.text!.isEmpty
            return passedValidation
            }) { () -> Void in
                print("validated")
                self.resetPassword(emailTextField.text!, oldPassword: oldPasswordTextField.text!, newPassword: newPasswordTextField.text!)
        }
        alertView.showEdit(self, title: "Password Reset", subTitle: "", closeButtonTitle: "Cancel", duration: 2000)
        
        alertView.alertIsDismissed { () -> Void in
//            self.performSegueWithIdentifier("LoginToPatients", sender: nil)
        }
        
    }
    
    func resetPassword(email: String, oldPassword: String, newPassword: String) {
        SwiftSpinner.show("Resetting Password", animated: true)
        let loginAPI = Login()
        loginAPI.resetPassword(email, oldPassword: oldPassword, newPassword: newPassword) { (success) -> Void in
            if success == true {
//                SwiftSpinner.show("loading patient", animated: true)
                SwiftSpinner.hide()
//                self.performSegueWithIdentifier("LoginToHome", sender: nil)
            }else {
                SwiftSpinner.hide()
            }
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     
    }
    
}

extension NSUserDefaults {
    
    func colorForKey(key: String) -> UIColor? {
        var color: UIColor?
        if let colorData = dataForKey(key) {
            color = NSKeyedUnarchiver.unarchiveObjectWithData(colorData) as? UIColor
        }
        return color
    }
    
    func setColor(color: UIColor?, forKey key: String) {
        var colorData: NSData?
        if let color = color {
            colorData = NSKeyedArchiver.archivedDataWithRootObject(color)
        }
        setObject(colorData, forKey: key)
    }
    
}

extension SettingsViewController {
    
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
