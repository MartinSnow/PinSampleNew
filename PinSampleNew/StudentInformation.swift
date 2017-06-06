//
//  Constants.swift
//  MyFavoriteMovies
//
//  Created by Jarrod Parkes on 11/5/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

import UIKit

// MARK: - Constants

struct StudentInformation {
    
    // properties
    var objectId: String
    var latitude: Float
    var longitude: Float
    var mediaURL: String
    var firstName: String
    var lastName: String
    var mapString: String
    var uniqueKey: String

    
    // UdacityClient authenticate
    struct UdacityClient {
        static var username = ""
        static var password = ""
    }
    
    //StudentInformation
    struct student {
        static var studentInformation = [[String:AnyObject]]()
    }
    

    
    // MARK: UI
    struct UI {
        static let LoginColorTop = UIColor(red: 0.345, green: 0.839, blue: 0.988, alpha: 1.0).cgColor
        static let LoginColorBottom = UIColor(red: 0.023, green: 0.569, blue: 0.910, alpha: 1.0).cgColor
        static let GreyColor = UIColor(red: 0.702, green: 0.863, blue: 0.929, alpha:1.0)
        static let BlueColor = UIColor(red: 0.0, green:0.502, blue:0.839, alpha: 1.0)
    }
    
    struct newStudent {
        static var address = ""
        static var uniqueKey = ""
        static var objectId = ""
    }
}


