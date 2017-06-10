//
//  Alert.swift
//  PinSampleNew
//
//  Created by Ma Ding on 17/6/10.
//  Copyright © 2017年 Ma Ding. All rights reserved.
//

import Foundation
import UIKit

class alert: UIViewController {
    
    func alert(fromController controller:UIViewController, message: String){
        let alert = UIAlertController(title: nil, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.destructive, handler: nil)
        alert.addAction(cancelAction)
        controller.present(alert, animated: true, completion: nil)
    }

}
