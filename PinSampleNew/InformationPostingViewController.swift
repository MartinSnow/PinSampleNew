//
//  InformationPostingViewController.swift
//  PinSample
//
//  Created by Ma Ding on 17/4/21.
//  Copyright © 2017年 Udacity. All rights reserved.
//

import UIKit
import MapKit

class InformationPostingViewController: UIViewController, UIApplicationDelegate, UINavigationControllerDelegate,UITextFieldDelegate, MKMapViewDelegate {
    
    var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LocationText.delegate = self
        
    }
        

    
    @IBOutlet weak var LocationText: UITextField!
    
    
    @IBAction func findOnTheMap(_ sender: AnyObject) {
        
        StudentInformation.newStudent.address = LocationText.text!
        
    }

    @IBAction func dismissViewController(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}



