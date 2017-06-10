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

    var keyboardOnScreen = false
    static var placeMarks = [MKPlacemark]()
    let localSearchRequest = MKLocalSearchRequest()
    let indicator = UIActivityIndicatorView()
    
    @IBOutlet weak var LocationText: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LocationText.delegate = self
        
        subscribeToNotification(.UIKeyboardWillShow, selector: #selector(keyboardWillShow))
        subscribeToNotification(.UIKeyboardWillHide, selector: #selector(keyboardWillHide))
        subscribeToNotification(.UIKeyboardDidShow, selector: #selector(keyboardDidShow))
        subscribeToNotification(.UIKeyboardDidHide, selector: #selector(keyboardDidHide))
        
        //add an activity indicator
        view.addSubview(indicator)
        indicator.center = view.center
        indicator.hidesWhenStopped = true
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        
    }
    
    @IBAction func findOnTheMap(_ sender: AnyObject) {
        
        localSearchRequest.naturalLanguageQuery = LocationText.text!
        localSearchRequest.region = mapView.region
        
        //start indicator
        indicator.startAnimating()
        
        let search = MKLocalSearch(request: localSearchRequest)
        search.start(completionHandler: {(localSearchResponse, error) in
            
            
            if error != nil {
                self.alert()
                
                //stop indicator
                self.indicator.stopAnimating()
                
                return
            } else {
                for item in localSearchResponse!.mapItems {
                    InformationPuttingViewController.placeMarks.append(item.placemark)
                }
                
                StudentInformation.newStudent.newLat = String(InformationPuttingViewController.placeMarks[0].coordinate.latitude)
                StudentInformation.newStudent.newLon = String(InformationPuttingViewController.placeMarks[0].coordinate.longitude)
                StudentInformation.newStudent.newAddress = InformationPuttingViewController.placeMarks[0].description
                
                //stop indicator
                self.indicator.stopAnimating()
                
                let controller = self.storyboard!.instantiateViewController(withIdentifier: "SearchMapViewController")
                self.present(controller, animated: true, completion: nil)
            }
        })
        
    }
    
    @IBAction func dismissViewController(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: Show/Hide Keyboard
    
    func keyboardWillShow(_ notification: Notification) {
        if !keyboardOnScreen {
            view.frame.origin.y -= 166
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        if keyboardOnScreen {
            view.frame.origin.y += 166
        }
    }
    
    func keyboardDidShow(_ notification: Notification) {
        keyboardOnScreen = true
    }
    
    func keyboardDidHide(_ notification: Notification) {
        keyboardOnScreen = false
    }
    
    private func keyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = (notification as NSNotification).userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeToNotification(_ notification: NSNotification.Name, selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: notification, object: nil)
    }
    
    private func alert(){
        let alert = UIAlertController(title: nil, message: "Place not found", preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.destructive, handler: nil)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
}
