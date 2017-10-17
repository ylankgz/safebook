//
//  SpecViewController.swift
//  Safebook
//
//  Created by Ulan on 10/1/17.
//  Copyright © 2017 SafebookApp. All rights reserved.
//

import UIKit
import FirebaseDatabase
import MapKit

class SpecViewController: UITableViewController, CLLocationManagerDelegate {
    
    var specRequests: [FIRDataSnapshot] = []
    var locationManager = CLLocationManager()
    var specLocation = CLLocationCoordinate2D()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

//        FIRDatabase.database().reference().child("SpecRequests").observeSingleEvent(of: .childAdded) { (snapshot) in
//            if let specRequestDict = snapshot.value as? [String: Any] {
//                if let _ = specRequestDict["specLat"] as? Double {
//                } else {
//                    self.specRequests.append(snapshot)
//                    self.tableView.reloadData()
//                }
//            }
//        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        specRequests = []
        FIRDatabase.database().reference().child("SpecRequests").observe(.childAdded) { (snapshot) in
            if let specRequestDict = snapshot.value as? [String: Any] {
                if let _ = specRequestDict["specLat"] as? Double {
                } else {
                    self.specRequests.append(snapshot)
                    self.tableView.reloadData()
                }
            }
        }
        
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { (timer) in
            self.tableView.reloadData()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coord = manager.location?.coordinate {
            specLocation = coord
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return specRequests.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "specRequestCell", for: indexPath)
        
        let snapshot = specRequests[indexPath.row]
        if let specRequestDict = snapshot.value as? [String: Any] {
            if let name = specRequestDict["name"] as? String {
                if let lat = specRequestDict["lat"] as? Double {
                    if let lon = specRequestDict["lon"] as? Double {
                        let specCLLocation = CLLocation(latitude: specLocation.latitude, longitude: specLocation.longitude)
                        let userCLLocation = CLLocation(latitude: lat, longitude: lon)
                        let distance = specCLLocation.distance(from: userCLLocation) / 1000
                        let roundedDistance = round(distance * 100) / 100
                        cell.textLabel?.text = "\(name) - \(roundedDistance)km away"
                    }
                }
            }
        }

        return cell
    }
    
    
    @IBAction func backTapped(_ sender: Any) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let snapshot = specRequests[indexPath.row]
        performSegue(withIdentifier: "acceptSegue", sender: snapshot)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let acceptVC = segue.destination as? AcceptViewController {
            if let snapshot = sender as? FIRDataSnapshot {
                if let specRequestDict = snapshot.value as? [String: Any] {
                    if let email = specRequestDict["email"] as? String {
                        if let lat = specRequestDict["lat"] as? Double {
                            if let lon = specRequestDict["lon"] as? Double {
                                acceptVC.requestEmail = email
                                let location = CLLocationCoordinate2DMake(lat, lon)
                                acceptVC.requestLocation = location
                                acceptVC.specLocation = specLocation
                            }
                        }
                    }
                }
            }
        }
    }
}
