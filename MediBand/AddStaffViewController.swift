//
//  AddStaffViewController.swift
//  MediBand
//
//  Created by Johnson Ejezie on 7/7/15.
//  Copyright (c) 2015 Johnson Ejezie. All rights reserved.
//

import UIKit

protocol addStaffControllerDelegate: class {
    func addStaffViewController(controller: AddStaffViewController,
        finishedAddingStaff staff: Staff)
}

class AddStaffViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    weak var delegate: addStaffControllerDelegate!

//    
    @IBOutlet var navBar: UIBarButtonItem!
    var tap:UITapGestureRecognizer!
    var imagePicker = UIImagePickerController()
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var topContainerView: UIView!
    @IBOutlet weak var staffImageView: UIImageView!
    
    @IBOutlet weak var editPicButton: UIButton!
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var generalPracIDTextView: UITextField!
    @IBOutlet var roleIDTextView: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var specialityTextField: UITextField!

    @IBOutlet weak var GeneralPractitionerIDLabel: UILabel!
    @IBOutlet weak var staffID: UITextField!

    @IBOutlet weak var GeneralPracticeIDLabel: UILabel!
    
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBAction func editButtonAction(sender: AnyObject) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum){
            println("Button capture")
            
            
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum;
            imagePicker.allowsEditing = false
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
        
    }

    @IBAction func saveButtonAction(sender: AnyObject) {
        
        let dataImage:NSData = UIImagePNGRepresentation(staffImageView.image)
        let imageString = dataImage.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)

        var firstname:String = firstNameTextField.text!
        var surname:String = lastNameTextField.text!
        var gpID:String = generalPracIDTextView.text!
        var specialityID:String = specialityTextField.text!
        var member_id:String = staffID.text!
        var role_id:String = roleIDTextView.text!
        var email:String = emailTextField.text!
    
        
        var staff = Staff()
        staff.medical_facility_id = "4"
        staff.speciality_id = specialityID
        staff.general_practional_id = gpID
        staff.member_id = member_id
        staff.role_id = role_id
        staff.email = email
        staff.surname=surname
        staff.firstname = firstname
        staff.image = "N/A"
        
        var staffMethods = StaffNetworkCall()
        staffMethods.create(staff)
//        var staff:Dictionary<String, String> = [
//            "name": name,
//            "staffID": staffID.text,
//            "staffImage": imageString,
//            "generalPractitionerID": gpID,
//            "generalPracticeID": gpID,
//            "speciality": specialityTextField.text
//            
//        ]
        
        self.trackEvent("UX", action: "Create new staff", label: "Save button: create new staff", value: nil)
        
        delegate?.addStaffViewController(self, finishedAddingStaff: staff)
        self.dismissViewControllerAnimated(true, completion: nil)
    
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navBar.target = self.revealViewController()
        navBar.action = Selector("revealToggle:")
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
//        GeneralPracticeIDLabel.text = " \(arc4random_uniform(1000))"
//        GeneralPractitionerIDLabel.text = " \(arc4random_uniform(100000))"

        
        tap = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)

        firstNameTextField.layer.cornerRadius = 5
//        GeneralPracticeIDLabel.backgroundColor = UIColor(red: 0.94, green: 0.94, blue: 0.95, alpha: 1);
//        GeneralPractitionerIDLabel.clipsToBounds = true
//        GeneralPracticeIDLabel.clipsToBounds = true
//         GeneralPractitionerIDLabel.backgroundColor = UIColor(red: 0.94, green: 0.94, blue: 0.95, alpha: 1);
        
        
//        GeneralPractitionerIDLabel.layer.cornerRadius = 5
//        
//        GeneralPracticeIDLabel.layer.cornerRadius = 5
//        
//        GeneralPracticeIDLabel.textColor = UIColor(red: 0.73, green: 0.73, blue: 0.76, alpha: 1)
//        GeneralPractitionerIDLabel.textColor = UIColor(red: 0.73, green: 0.73, blue: 0.76, alpha: 1)
//
//
        emailTextField.layer.cornerRadius = 5
        roleIDTextView.layer.cornerRadius = 5
        generalPracIDTextView.layer.cornerRadius = 5
        lastNameTextField.layer.cornerRadius = 5
        specialityTextField.layer.cornerRadius = 5
        staffID.layer
        
        firstNameTextField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0)
        lastNameTextField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0)
        specialityTextField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0)

        
        saveButton.layer.cornerRadius = 4

        // Do any additional setup after loading the view.
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
        
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        setScreeName("Add staff")
    }
    
    override func viewWillLayoutSubviews() {
        staffImageView.layer.masksToBounds = false
        staffImageView.layer.cornerRadius = staffImageView.frame.size.width / 2
        staffImageView.clipsToBounds = true
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            println("done")
        })
        staffImageView.image = image
    }


    func handleSingleTap(sender:UITapGestureRecognizer){
        self.view.endEditing(true)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            self.view.frame.origin.y -= keyboardSize.height
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            self.view.frame.origin.y += keyboardSize.height
        }
    }
    

}

extension AddStaffViewController {
    
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





