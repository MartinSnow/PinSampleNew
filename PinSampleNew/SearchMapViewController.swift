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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    var address = StudentInformation.newStudent.address
    let localSearchRequest = MKLocalSearchRequest()
    
    var newLat = ""
    var newLon = ""
    var newAddress = ""
    var newUniqueKey = ""
    var newFirstName = ""
    var newLastName = ""
    var mediaURL = ""
    var objectId = ""
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var shareLink: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shareLink.delegate = self
        
        localSearchRequest.naturalLanguageQuery = address
        localSearchRequest.region = mapView.region
        
        let search = MKLocalSearch(request: localSearchRequest)
        search.start(completionHandler: {(localSearchResponse, error) in
            
            var placeMarks = [MKPlacemark]()
            if error != nil {
                self.alert()
                return
            } else {
                for item in localSearchResponse!.mapItems {
                    placeMarks.append(item.placemark)
                    print ("item is \(item)")
                }
                self.mapView.showAnnotations([placeMarks[0]], animated: false)
                
                self.newLat = String(placeMarks[0].coordinate.latitude)
                self.newLon = String(placeMarks[0].coordinate.longitude)
                self.newAddress = placeMarks[0].description
                self.newUniqueKey = StudentInformation.newStudent.uniqueKey
                self.newFirstName = StudentInformation.newStudent.name
                self.newLastName = StudentInformation.newStudent.name
                self.mediaURL = self.shareLink.text!
                self.objectId = StudentInformation.newStudent.objectId
            }
        })
        
    }
    
    @IBAction func submit(_ sender: AnyObject) {
        
        if StudentInformation.newStudent.objectId == "" {
            self.searchLocationAndPost(localSearchRequest:localSearchRequest)
            print("use post")
        } else {
            self.searchLocationAndPut(localSearchRequest:localSearchRequest)
            print("use put")
        }
    }
    @IBAction func cancel(_ sender: AnyObject) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func searchLocationAndPost(localSearchRequest:MKLocalSearchRequest) {
        UdacityClient.sharedInstance().postAStudentLocation(newUniqueKey: newUniqueKey, newFirstName: newFirstName, newLastName: newLastName, newAddress: newAddress, newLat: newLat, newLon: newLon, mediaURL: mediaURL)
        
        let controller = self.storyboard!.instantiateViewController(withIdentifier: "TabBarController")
        self.present(controller, animated: true, completion: nil)
    }
    
    func searchLocationAndPut(localSearchRequest:MKLocalSearchRequest) {
        UdacityClient.sharedInstance().putAStudentLocation(newUniqueKey: newUniqueKey, newFirstName: newFirstName, newLastName: newLastName, newAddress: newAddress, newLat: newLat, newLon: newLon, objectId: objectId, mediaURL: mediaURL)
        
        let controller = self.storyboard!.instantiateViewController(withIdentifier: "TabBarController")
        self.present(controller, animated: true, completion: nil)
    }
    
    private func alert(){
        let alert = UIAlertController(title: nil, message: "Place not found", preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.destructive, handler: nil)
        alert.addAction(cancelAction)
        alert.show(alert, sender: Any.self)
    }
    
}
