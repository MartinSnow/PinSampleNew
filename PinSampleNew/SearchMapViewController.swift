//
//  SearchMapViewController.swift
//  PinSample
//
//  Created by Ma Ding on 17/4/23.
//  Copyright © 2017年 Udacity. All rights reserved.
//

import UIKit
import MapKit

class SearchMapViewController: UIViewController, UITextFieldDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var shareLink: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shareLink.delegate = self
        self.mapView.showAnnotations([InformationPuttingViewController.placeMarks[0]], animated: false)
    }
    
    //submit Internet address
    @IBAction func submit(_ sender: AnyObject) {
        StudentInformation.newStudent.mediaURL = self.shareLink.text!
        if StudentInformation.newStudent.objectId == "" {
            self.searchLocationAndPost()
            print ("post")
        } else {
            self.searchLocationAndPut()
            print("put")
        }
    }
    @IBAction func cancel(_ sender: AnyObject) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func searchLocationAndPost() {
        UdacityClient.sharedInstance().postAStudentLocation(newUniqueKey: StudentInformation.newStudent.newUniqueKey, newFirstName: StudentInformation.newStudent.newFirstName, newLastName: StudentInformation.newStudent.newLastName, newAddress: StudentInformation.newStudent.newAddress, newLat: StudentInformation.newStudent.newLat, newLon: StudentInformation.newStudent.newLon, mediaURL: StudentInformation.newStudent.mediaURL){(success, errorString) in
            
            if success == false {
                self.alert(message: errorString!)
            } else {
                //return to MapsTabBarController
                self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func searchLocationAndPut() {
        UdacityClient.sharedInstance().putAStudentLocation(newUniqueKey: StudentInformation.newStudent.newUniqueKey, newFirstName: StudentInformation.newStudent.newFirstName, newLastName: StudentInformation.newStudent.newLastName, newAddress: StudentInformation.newStudent.newAddress, newLat: StudentInformation.newStudent.newLat, newLon: StudentInformation.newStudent.newLon, objectId: StudentInformation.newStudent.objectId, mediaURL: StudentInformation.newStudent.mediaURL){(success, errorString) in
            
            if success == false {
                self.alert(message: errorString!)
            } else {
                //return to MapsTabBarController
                self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func alert(message: String){
        let alert = UIAlertController(title: nil, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.destructive, handler: nil)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
}
