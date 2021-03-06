//
//  StaffNetworkCall.swift
//  MediBand
//
//  Created by Kehinde Shittu on 8/4/15.
//  Copyright (c) 2015 Johnson Ejezie. All rights reserved.
//

import UIKit
import AFNetworking
import Alamofire


class StaffNetworkCall{
    
    var allStaff = [Staff]()
    var isCreatingStaff = false


    let operationManger = AFHTTPRequestOperationManager()
        
    func create(staff:Staff, image:UIImage?, isCreatingNewStaff:Bool, completionBlock:(success:Bool)->Void){
        isCreatingStaff = true
        var url:String = ""
        self.operationManger.requestSerializer = AFJSONRequestSerializer()
        self.operationManger.responseSerializer = AFJSONResponseSerializer()
        self.operationManger.responseSerializer.acceptableContentTypes = NSSet(objects: "text/html") as Set<NSObject>
        var data : [String:AnyObject] = [
            "medical_facility_id":sharedDataSingleton.user.clinic_id,
            "speciality_id":staff.speciality,
            "general_practitioner_id":staff.general_practional_id,
            "member_id":staff.member_id,
            "role_id":staff.role,
            "email":staff.email,
            "surname":staff.surname,
            "firstname":staff.firstname
        ];
        
        if isCreatingNewStaff == true {
            url = sharedDataSingleton.baseURL + "create_staff"
        }else {
            url = sharedDataSingleton.baseURL + "edit_staff"
        }
        
        if let anImage:UIImage = image {
            let imageData = UIImageJPEGRepresentation(image!, 0.6)
            let mm = NetData(data: imageData!, mimeType: MimeType.ImageJpeg, filename: "staff_picture.jpg")
            var parameters : [String:AnyObject] = [
                "medical_facility_id":sharedDataSingleton.user.clinic_id,
                "speciality_id":staff.speciality,
                "general_practitioner_id":staff.general_practional_id,
                "member_id":staff.member_id,
                "role_id":staff.role,
                "email":staff.email,
                "surname":staff.surname,
                "firstname":staff.firstname,
                "image":mm
            ]
            
           
            let urlRequest = self.urlRequestWithComponents(url, parameters: parameters)
            Alamofire.upload(urlRequest.0, data: urlRequest.1)
                .progress { (bytesWritten, totalBytesWritten, totalBytesExpectedToWrite) in
                }.responseJSON { _, _, result in
                    if (result.value != nil) {
                        if let resultDict:AnyObject = result.value {
                        if let dict:[String: AnyObject] = resultDict["data"] as? [String: AnyObject]{
                          self.parseDict(dict)
                        }
                    }
                        completionBlock(success: true)
                    }else {
                        completionBlock(success: false)
                        
                    }
            }

        }else {
            self.operationManger.POST(url, parameters: data, success: { (requestOperation, responseObject) -> Void in
                let result:AnyObject = responseObject
                    if let dict:[String: AnyObject] = result["data"] as? [String: AnyObject] {
                        self.parseDict(dict)
                        completionBlock(success: true)
                    }else {
                        completionBlock(success: false)
                }
               
                }, failure:{ (requestOperation, error) -> Void in
                    completionBlock(success: false)
            })
        }

    }
    func viewStaff(email:String!, completionBlock:(Staff?, NSError?)->()){
       
        self.operationManger.requestSerializer = AFJSONRequestSerializer()
        self.operationManger.responseSerializer = AFJSONResponseSerializer()
        self.operationManger.responseSerializer.acceptableContentTypes = NSSet(objects: "text/html") as Set<NSObject>
        let data : [String:String] = ["email":email]
        let url = sharedDataSingleton.baseURL + "view_staff"
        self.operationManger.POST(url, parameters: data, success: { (requestOperation, responseObject) -> Void in
            let result:AnyObject = responseObject
            if let dict:[String: AnyObject] = result["data"] as? [String: AnyObject] {
                self.parseDict(dict)
            }else {
                
            }
            }, failure:{ (requestOperation, error) -> Void in
        })
    }
    
    
    func getStaffs(medical_facility_id:String!, inPageNumber pageNumber:String, completionBlock:(done:Bool)->Void){
        self.operationManger.requestSerializer = AFJSONRequestSerializer()
        self.operationManger.responseSerializer = AFJSONResponseSerializer()
        self.operationManger.responseSerializer.acceptableContentTypes = NSSet(objects: "text/html") as Set<NSObject>
        let data : [String:String] = ["medical_facility_id":medical_facility_id]
        let url = sharedDataSingleton.baseURL + "get_staff"
        self.operationManger.POST(url, parameters: data, success: { (requestOperation, responseObject) -> Void in
            let responseDicts = responseObject as! [String:AnyObject]
            if let arrayDict:AnyObject = responseDicts["data"]{
            
                self.parseStaffs(arrayDict as! [AnyObject], completionBlock: { (done) -> Void in
                    if (done) {
                        sharedDataSingleton.allStaffs = self.allStaff
                         completionBlock(done:true)
                    }
                })
            }else {
               completionBlock(done:false)
            }
            }, failure:{ (requestOperation, error) -> Void in
             
                  completionBlock(done:false)
        })
    }
    
    
    func parseStaffs(staffArray:[AnyObject], completionBlock:(done:Bool)->Void)-> Void{
        
        var result = [Staff]()
        for data in staffArray as [AnyObject]{
            if let dict = data as? [String:AnyObject] {
                self.parseDict(dict)
            }
        }
//        sharedDataSingleton.allStaffs = result
        completionBlock(done:true)
    }
    
    func parseDict(dict:[String:AnyObject]) {
        let staffData = Staff()
        staffData.id = dict["id"] as! String
        if let general_practional_id:String = dict["general_practitioner_id"]  as? String{
            staffData.general_practional_id = general_practional_id;
        }else{
            staffData.general_practional_id = ""
        }
        
        if let speciality:String = dict["speciality"]  as? String{
            staffData.speciality = speciality;
        }else{
            staffData.speciality = ""
        }
        
        if let member_id:String = dict["member_id"]  as? String{
            staffData.member_id = member_id;
        }else{
            staffData.member_id = ""
        }
        if let role:String = dict["role"]  as? String{
            staffData.role = role;
        }else{
            staffData.role = ""
        }
        staffData.firstname = dict["firstname"] as! String
        staffData.surname = dict["surname"] as! String
        if let image:String = dict["image"]  as? String{
            staffData.image = image;
        }else{
            staffData.image = ""
        }
        staffData.email = dict["email"] as! String
        
        if isCreatingStaff == true {
            sharedDataSingleton.selectedStaff = staffData
        }
        
        self.allStaff.append(staffData)
    }
    
    
    func urlRequestWithComponents(urlString:String, parameters:NSDictionary) -> (URLRequestConvertible, NSData) {
        
        // create url request to send
        var mutableURLRequest = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        mutableURLRequest.HTTPMethod = Alamofire.Method.POST.rawValue
        //let boundaryConstant = "myRandomBoundary12345"
        let boundaryConstant = "NET-POST-boundary-\(arc4random())-\(arc4random())"
        let contentType = "multipart/form-data;boundary="+boundaryConstant
        mutableURLRequest.setValue(contentType, forHTTPHeaderField: "Content-Type")
        
        
        // create upload data to send
        let uploadData = NSMutableData()
        
        // add parameters
        for (key, value) in parameters {
            
            uploadData.appendData("\r\n--\(boundaryConstant)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            
            if value is NetData {
                // add image
                var postData = value as! NetData
                
                
                //uploadData.appendData("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(postData.filename)\"\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
                
                // append content disposition
                var filenameClause = " filename=\"\(postData.filename)\""
                let contentDispositionString = "Content-Disposition: form-data; name=\"\(key)\";\(filenameClause)\r\n"
                let contentDispositionData = contentDispositionString.dataUsingEncoding(NSUTF8StringEncoding)
                uploadData.appendData(contentDispositionData!)
                
                
                // append content type
                //uploadData.appendData("Content-Type: image/png\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!) // mark this.
                let contentTypeString = "Content-Type: \(postData.mimeType.getString())\r\n\r\n"
                let contentTypeData = contentTypeString.dataUsingEncoding(NSUTF8StringEncoding)
                uploadData.appendData(contentTypeData!)
                uploadData.appendData(postData.data)
                
            }else{
                uploadData.appendData("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n\(value)".dataUsingEncoding(NSUTF8StringEncoding)!)
            }
        }
        uploadData.appendData("\r\n--\(boundaryConstant)--\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        
        
        
        // return URLRequestConvertible and NSData
        return (Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: nil).0, uploadData)
    }
    
    
}