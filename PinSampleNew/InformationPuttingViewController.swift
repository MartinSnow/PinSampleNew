//
//  InformationPuttingViewController.swift
//  PinSampleNew
//
//  Created by Ma Ding on 17/5/12.
//  Copyright © 2017年 Ma Ding. All rights reserved.
//

import UIKit
import MapKit

class InformationPuttingViewController: UIViewController, UIApplicationDelegate, UINavigationControllerDelegate,UITextFieldDelegate, MKMapViewDelegate {

    var mapView: MKMapView!
    
    
    @IBOutlet weak var LocationText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LocationText.delegate = self
        
    }
    
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
