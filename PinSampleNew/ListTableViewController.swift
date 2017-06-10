//
//  ListTableViewController.swift
//  PinSample
//
//  Created by Ma Ding on 17/4/12.
//  Copyright © 2017年 Udacity. All rights reserved.
//

import UIKit

class ListTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIApplicationDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func logout(_ sender: AnyObject) {
        UdacityClient.sharedInstance().deleteViewController() {(success, errorString) in
            if success {
                performUIUpdatesOnMain {
                    self.dismiss(animated: true, completion: nil)
                }
            } else {
                print (errorString)
            }
        }
    }
    
    @IBAction func postPin(_ sender: AnyObject) {
        if StudentInformation.newStudent.objectId == "" {
            let controller = self.storyboard!.instantiateViewController(withIdentifier: "InformationPuttingViewController")
            self.present(controller, animated: true, completion: nil)
        } else {
            self.postPinAlert()
        }
    }
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    override func viewDidAppear(_ animated: Bool) {
        tableView?.reloadData()
    }
    
    override func viewDidLoad() {
        tableView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentProperty.studentInformation.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentCell", for: indexPath)
        let match = studentProperty.studentInformation[(indexPath as IndexPath).row]
        let firstName = match.firstName
        let lastName = match.lastName
        cell.textLabel!.text = "\(firstName) \(lastName)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let app = UIApplication.shared
        let studentInformation = studentProperty.studentInformation[(indexPath as IndexPath).row]
        if let toOpen = studentInformation.mediaURL as? String {
            print ("toOpen is \(toOpen)")
            app.openURL(URL(string: toOpen)!)
        }
    }
    
    func postPinAlert() {
        let alertController = UIAlertController(title: nil, message: "You Have Already Posted a Student Location. Would You Like to Overwrite Your Current Location?", preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "Overwrite", style: UIAlertActionStyle.cancel){(action) in
            let controller = self.storyboard!.instantiateViewController(withIdentifier: "InformationPuttingViewController")
            self.present(controller, animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil)
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
