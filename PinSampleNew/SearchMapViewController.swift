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
            
            self.postAStudentLocation(newUniqueKey: newUniqueKey, newAddress: newAddress, newLat: newLat, newLon: newLon, mediaURL: mediaURL)
            
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
            
            self.putAStudentLocation(newUniqueKey: newUniqueKey, newAddress: newAddress, newLat: newLat, newLon: newLon, objectId: objectId, mediaURL: mediaURL)
            
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
    
    private func postAStudentLocation(newUniqueKey: String, newAddress: String, newLat: String, newLon: String, mediaURL: String) {
        
        let request = NSMutableURLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
        request.httpMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"\(newUniqueKey)\", \"firstName\": \"马\", \"lastName\": \"丁\",\"mapString\": \"\(newAddress)\", \"mediaURL\": \"www.google.com\",\"latitude\": \(newLat), \"longitude\": \(newLon)}".data(using: String.Encoding.utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            print ("post student location:")
            print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!)
            
            let parsedResult: [String:AnyObject]!
            
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:AnyObject]
            } catch {
                print ("Could not parse the data as JSON: '\(data)'")
                return
            }
            
            guard let objectId = parsedResult["objectId"] as? String else {
                print ("There is no objectId")
                return
            }
            
            StudentInformation.newStudent.objectId = objectId
            
        }
        task.resume()
    
    }
    
    private func putAStudentLocation(newUniqueKey: String, newAddress: String, newLat: String, newLon: String, objectId: String, mediaURL: String) {
        
        let urlString = "https://parse.udacity.com/parse/classes/StudentLocation/\(objectId)"
        let url = URL(string: urlString)
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "PUT"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"\(newUniqueKey)\", \"firstName\": \"Ma\", \"lastName\": \"Ding\",\"mapString\": \"\(newAddress)\", \"mediaURL\": \"\(mediaURL)\",\"latitude\": \(newLat), \"longitude\": \(newLat)}".data(using: String.Encoding.utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            print ("Put A StudentLocation Information.")
            print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!)
        }
        task.resume()
    }
}
