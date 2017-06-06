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
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var shareLink: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shareLink.delegate = self
    }
    
    @IBAction func submit(_ sender: AnyObject) {
        
        if StudentInformation.newStudent.objectId == "" {
            self.searchLocationAndPost(address: address)
        } else {
            self.searchLocationAndPut(address: address)
        }
    }
    
    func searchLocationAndPost(address:String) {
        
        let localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = address
        localSearchRequest.region = mapView.region
        
        let search = MKLocalSearch(request: localSearchRequest)
        search.start(completionHandler: {(localSearchResponse, error) in
            
            var placeMarks = [MKPlacemark]()
            if error != nil {
                self.alert()
                return
            }
            for item in localSearchResponse!.mapItems {
                placeMarks.append(item.placemark)
                print ("item is \(item)")
            }
            self.mapView.showAnnotations([placeMarks[0]], animated: false)
            
            let newLat = String(placeMarks[0].coordinate.latitude)
            let newLon = String(placeMarks[0].coordinate.longitude)
            let newAddress = placeMarks[0].description
            let newUniqueKey = StudentInformation.newStudent.uniqueKey
            let mediaURL = self.shareLink.text!
            
            UdacityClient.sharedInstance().postAStudentLocation(newUniqueKey: newUniqueKey, newAddress: newAddress, newLat: newLat, newLon: newLon, mediaURL: mediaURL)
            
            //self.dismiss(animated: true, completion: nil)
            
            let controller = self.storyboard!.instantiateViewController(withIdentifier: "TabBarController")
            self.present(controller, animated: true, completion: nil)
        })
    }
    
    func searchLocationAndPut(address:String) {
        
        let localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = address
        localSearchRequest.region = mapView.region
        
        let search = MKLocalSearch(request: localSearchRequest)
        search.start(completionHandler: {(localSearchResponse, error) in
            
            var placeMarks = [MKPlacemark]()
            if error != nil {
                self.alert()
                return
            }
            for item in localSearchResponse!.mapItems {
                placeMarks.append(item.placemark)
                print ("item is \(item)")
            }
            self.mapView.showAnnotations([placeMarks[0]], animated: false)
            
            let newLat = String(placeMarks[0].coordinate.latitude)
            let newLon = String(placeMarks[0].coordinate.longitude)
            let newAddress = placeMarks[0].description
            let newUniqueKey = StudentInformation.newStudent.uniqueKey
            let mediaURL = self.shareLink.text!
            let objectId = StudentInformation.newStudent.objectId
            
            UdacityClient.sharedInstance().putAStudentLocation(newUniqueKey: newUniqueKey, newAddress: newAddress, newLat: newLat, newLon: newLon, objectId: objectId, mediaURL: mediaURL)
            
            let controller = self.storyboard!.instantiateViewController(withIdentifier: "TabBarController")
            self.present(controller, animated: true, completion: nil)
        })
    }
    
    private func alert(){
        let alert = UIAlertController(title: nil, message: "Place not found", preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.destructive, handler: nil)
        alert.addAction(cancelAction)
        alert.show(alert, sender: Any.self)
    }
    
}
