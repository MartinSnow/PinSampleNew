//
//  UdacityClient.swift
//  PinSample
//
//  Created by Ma Ding on 17/4/13.
//  Copyright © 2017年 Udacity. All rights reserved.
//

import Foundation
import UIKit

class UdacityClient: NSObject {
    
    // MARK: Properties
    
    // shared session
    var session = URLSession.shared
    
    // authentication state
    var accountId: String? = nil
    var accountRegistered: Bool? = nil
    var sessionId: String? = nil
    var sessionExpiration: String? = nil
    
    // MARK: Initializers
    
    override init() {
        super.init()
    }
    
    func postSessionWithUdAPI(completionHandlerForPostWithUdAPI: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(StudentInformation.UdacityClient.username)\", \"password\": \"\(StudentInformation.UdacityClient.password)\"}}".data(using: String.Encoding.utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil { // Handle error…
                completionHandlerForPostWithUdAPI(nil,error! as NSError)
                return
            }
            
            let range = Range(uncheckedBounds: (5, data!.count))
            let newData = data?.subdata(in: range) /* subset response data! */
            //print(NSString(data: newData!, encoding: String.Encoding.utf8.rawValue)!)
            self.convertDataWithCompletionHandler(newData!, completionHandlerForConvertData: completionHandlerForPostWithUdAPI)
            
        }
        task.resume()
        return task
    }
    
    func getPublicUserData(userId: String?, completionHandlerForPublicUserData: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        let userId = userId!
        
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/users/\(userId)")!)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil { // Handle error...
                return
            }
            let range = Range(uncheckedBounds: (5, data!.count))
            let newData = data?.subdata(in: range) /* subset response data! */
            //print(NSString(data: newData!, encoding: String.Encoding.utf8.rawValue)!)
            self.convertDataWithCompletionHandler(newData!, completionHandlerForConvertData: completionHandlerForPublicUserData)
        }
        task.resume()
        return task
    }
    
    func deleteASession(completionHandlerForDeleteSession: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            let range = Range(uncheckedBounds: (5, data!.count))
            let newData = data?.subdata(in: range) /* subset response data! */
            self.convertDataWithCompletionHandler(newData!, completionHandlerForConvertData: completionHandlerForDeleteSession)
        }
        task.resume()
        return task
    }
    
    func taskGetStudentLocations(_ completionHandlerForStudentLocations: @escaping (_ success: Bool, _ locationJSON: [studentProperty]?, _ errorString: String?) -> Void) {
        let request = NSMutableURLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation?limit=100&order=-updatedAt")!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil { // Handle error...
                completionHandlerForStudentLocations(false, nil, "Fail to get studentLocations.")
                return
            }
            
            let parsedResult: [String:AnyObject]!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:AnyObject]
            } catch {
                completionHandlerForStudentLocations(false, nil, "Could not parse the data as JSON: \(data)")
                return
            }

            guard let results = parsedResult["results"] as? [[String:AnyObject]] else {
                completionHandlerForStudentLocations(false, nil, "There is no reslut.")
                return
            }
            
            studentProperty.studentInformation = [studentProperty]()
            
            for studentInformation in results {
                studentProperty.studentInformation.append(studentProperty(dictionary: studentInformation))
            }
            
            completionHandlerForStudentLocations(true, studentProperty.studentInformation, nil)
        }
        task.resume()
    }
    
    func postAStudentLocation(newUniqueKey: String, newFirstName: String, newLastName: String, newAddress: String, newLat: String, newLon: String, mediaURL: String, _ completionHandlerForPostAStudentLocation: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        let request = NSMutableURLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
        request.httpMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"\(newUniqueKey)\", \"firstName\": \"\(newFirstName)\", \"lastName\": \"\(newLastName)\",\"mapString\": \"\(newAddress)\", \"mediaURL\": \"https://\(mediaURL)\",\"latitude\": \(newLat), \"longitude\": \(newLon)}".data(using: String.Encoding.utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil { // Handle error…
                completionHandlerForPostAStudentLocation(false, "post failed 1.")
                return
            }
            let parsedResult: [String:AnyObject]!
            
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:AnyObject]
            } catch {
                completionHandlerForPostAStudentLocation(false, "Could not parse the data as JSON: \(data).")
                return
            }
            
            guard let objectId = parsedResult["objectId"] as? String else {
                completionHandlerForPostAStudentLocation(false, "There is no objectId.")
                return
            }
            
            StudentInformation.newStudent.objectId = objectId
            completionHandlerForPostAStudentLocation(true, nil)
            
        }
        task.resume()
        
    }
    
    func putAStudentLocation(newUniqueKey: String, newFirstName: String, newLastName: String, newAddress: String, newLat: String, newLon: String, objectId: String, mediaURL: String, _ completionHandlerForPutAStudentLocation: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        let urlString = "https://parse.udacity.com/parse/classes/StudentLocation/\(objectId)"
        let url = URL(string: urlString)
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "PUT"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"\(newUniqueKey)\", \"firstName\": \"\(newFirstName)\", \"lastName\": \"\(newLastName)\",\"mapString\": \"\(newAddress)\", \"mediaURL\": \"https://\(mediaURL)\",\"latitude\": \(newLat), \"longitude\": \(newLon)}".data(using: String.Encoding.utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil { // Handle error…
                completionHandlerForPutAStudentLocation(false, "put failed 1.")
                return
            }
            let parsedResult: [String:AnyObject]!
            
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:AnyObject]
            } catch {
                completionHandlerForPutAStudentLocation(false, "Could not parse the data as JSON: \(data).")
                return
            }
            
            guard let updateAt = parsedResult["updatedAt"] as? String else {
                completionHandlerForPutAStudentLocation(false, "There is no updatedAt.")
                return
            }
            
            StudentInformation.newStudent.updateAt = updateAt
            completionHandlerForPutAStudentLocation(true, nil)
        }
        task.resume()
    }

    
    func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        var parsedResult: AnyObject! = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        completionHandlerForConvertData(parsedResult, nil)
    }
    
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }

}
