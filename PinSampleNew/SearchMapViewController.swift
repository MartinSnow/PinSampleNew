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
        StudentInformation.newStudent.mediaURL = self.shareLink.text!
        self.mapView.showAnnotations([InformationPuttingViewController.placeMarks[0]], animated: false)
    }
    
    @IBAction func submit(_ sender: AnyObject) {
        
        if StudentInformation.newStudent.objectId == "" {
            self.searchLocationAndPost()
        } else {
            self.searchLocationAndPut()
        }
    }
    @IBAction func cancel(_ sender: AnyObject) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func searchLocationAndPost() {
        UdacityClient.sharedInstance().postAStudentLocation(newUniqueKey: StudentInformation.newStudent.newUniqueKey, newFirstName: StudentInformation.newStudent.newFirstName, newLastName: StudentInformation.newStudent.newLastName, newAddress: StudentInformation.newStudent.newAddress, newLat: StudentInformation.newStudent.newLat, newLon: StudentInformation.newStudent.newLon, mediaURL: StudentInformation.newStudent.mediaURL)
        
        let controller = self.storyboard!.instantiateViewController(withIdentifier: "TabBarController")
        self.present(controller, animated: true, completion: nil)
    }
    
    func searchLocationAndPut() {
        UdacityClient.sharedInstance().putAStudentLocation(newUniqueKey: StudentInformation.newStudent.newUniqueKey, newFirstName: StudentInformation.newStudent.newFirstName, newLastName: StudentInformation.newStudent.newLastName, newAddress: StudentInformation.newStudent.newAddress, newLat: StudentInformation.newStudent.newLat, newLon: StudentInformation.newStudent.newLon, objectId: StudentInformation.newStudent.objectId, mediaURL: StudentInformation.newStudent.mediaURL)
        
        let controller = self.storyboard!.instantiateViewController(withIdentifier: "TabBarController")
        self.present(controller, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
