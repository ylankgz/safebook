//
//  UserViewController.swift
//  Safebook
//
//  Created by Ulan on 9/30/17.
//  Copyright © 2017 SafebookApp. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import MapKit

class UserViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var callButton: UIButton!
    var locationManager = CLLocationManager()
    var userLocation = CLLocationCoordinate2D()
    var specHasBeenCalled:Bool = false
    var specLocation = CLLocationCoordinate2D()
    var specOnTheWay = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        map.showsUserLocation = true

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

        checkSpecLocation()
    }
    
    func checkSpecLocation() {
        if let email = FIRAuth.auth()?.currentUser?.email {
            FIRDatabase.database().reference().child("SpecRequests").queryOrdered(byChild: "email").queryEqual(toValue: email).observe(.childAdded, with: { (snapshot) in
                self.specHasBeenCalled = true
                self.callButton.setTitle("Cancel share".localize, for: .normal)
                self.callButton.setBackgroundImage(#imageLiteral(resourceName: "Cancel"), for: .normal)
                FIRDatabase.database().reference().child("SpecRequests").removeAllObservers()
                
                if let specRequestDict = snapshot.value as? [String: Any] {
                    if let specLat = specRequestDict["specLat"] as? Double {
                        if let specLon = specRequestDict["specLon"] as? Double {
                            self.specLocation = CLLocationCoordinate2DMake(specLat, specLon)
                            self.specOnTheWay = true
                            self.displayUserAndSpec()
                            
                            FIRDatabase.database().reference().child("SpecRequests").queryOrdered(byChild: "email").queryEqual(toValue: email).observe(.childChanged, with: { (snapshot) in
                                if let specRequestDict = snapshot.value as? [String: Any] {
                                    if let specLat = specRequestDict["specLat"] as? Double {
                                        if let specLon = specRequestDict["specLon"] as? Double {
                                            self.specLocation = CLLocationCoordinate2DMake(specLat, specLon)
                                            self.specOnTheWay = true
                                            self.displayUserAndSpec()
                                        }
                                    }
                                }
                            })
                            
                        }
                    }
                }
            })
        }
    }
    
    func displayUserAndSpec() {
        let specCLLocation = CLLocation(latitude: specLocation.latitude, longitude: specLocation.longitude)
        let userCLLocation = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)

        let distance = specCLLocation.distance(from: userCLLocation) / 1000
        let roundedDistance = round(distance * 100) / 100
        self.callButton.setTitle("Your target is \(roundedDistance)km away", for: .normal)
        self.callButton.setBackgroundImage(#imageLiteral(resourceName: "Waiting"), for: .normal)

        let latDelta = abs(specLocation.latitude - userLocation.latitude) * 2 + 0.01
        let lonDelta = abs(specLocation.longitude - userLocation.longitude) * 2 + 0.01
        map.removeAnnotations(map.annotations)
        let region = MKCoordinateRegionMake(userLocation, MKCoordinateSpanMake(latDelta, lonDelta))
        map.setRegion(region, animated: true)

        let specAnno = MKPointAnnotation()
        specAnno.coordinate = specLocation
        specAnno.title = "Your target!"
        let userAnno = MKPointAnnotation()
        userAnno.coordinate = userLocation
        userAnno.title = "You are here!"
        map.addAnnotations([userAnno, specAnno])
        print(userLocation, specLocation)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coord = manager.location?.coordinate {
            let center = CLLocationCoordinate2D(latitude:coord.latitude, longitude:coord.longitude)
            userLocation = center

            if specHasBeenCalled {
                self.displayUserAndSpec()
            } else {
                let region = MKCoordinateRegion(center:center, span:MKCoordinateSpan(latitudeDelta:0.01, longitudeDelta:0.01))
                map.setRegion(region, animated: true)
                
                
//                let annotation = MKPointAnnotation()
//                annotation.coordinate = center
//                annotation.title = "You are here"
//                map.addAnnotation(annotation)

                //print("annotation added \(coord.latitude) \(coord.longitude)")
            }
        }
    }
    
    @IBAction func callTapped(_ sender: Any) {
        if let email = FIRAuth.auth()?.currentUser?.email, let name = FIRAuth.auth()?.currentUser?.displayName {
            if !specOnTheWay {
                if specHasBeenCalled {
                    specHasBeenCalled = false
                    callButton.setTitle("Share location".localize, for: .normal)
                    callButton.setBackgroundImage(#imageLiteral(resourceName: "Share"), for: .normal)
                    FIRDatabase.database().reference().child("SpecRequests").queryOrdered(byChild: "email").queryEqual(toValue: email).observe(.childAdded, with: { (snapshot) in
                        snapshot.ref.removeValue()
                        FIRDatabase.database().reference().child("SpecRequests").removeAllObservers()
                    })
                } else {
                    let specRequestDict = ["email": email, "lat": userLocation.latitude, "lon": userLocation.longitude, "name": name] as [String : Any]
                    FIRDatabase.database().reference().child("SpecRequests").childByAutoId().setValue(specRequestDict)
                    
                    specHasBeenCalled = true
                    callButton.setTitle("Cancel share".localize, for: .normal)
                    callButton.setBackgroundImage(#imageLiteral(resourceName: "Cancel"), for: .normal)
                }
            } else {
                self.displayAlert(title: "Warning".localize, message: "You want to drop meeting?".localize, email: email)
            }
        }
    }

    @IBAction func logoutTapped(_ sender: Any) {
        try? FIRAuth.auth()?.signOut()
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func displayAlert(title: String, message: String, email: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel".localize, style: .cancel)
        let destroyAction = UIAlertAction(title: "Drop".localize, style: .destructive) { (result : UIAlertAction) -> Void in
//            FIRDatabase.database().reference().child("SpecRequests\(self.key)").removeValue()
            // Drop meeting
            self.specHasBeenCalled = false
            self.specOnTheWay = false
            self.callButton.setTitle("Share location".localize, for: .normal)
            self.callButton.setBackgroundImage(#imageLiteral(resourceName: "Share"), for: .normal)
            FIRDatabase.database().reference().child("SpecRequests").queryOrdered(byChild: "email").queryEqual(toValue: email).observe(.value, with: { (snapshot) in
                snapshot.ref.removeValue()
                FIRDatabase.database().reference().child("SpecRequests").removeAllObservers()
            })
//            FIRDatabase.database().reference().child("SpecRequests").queryOrdered(byChild: "email").queryEqual(toValue: email).observe(.childChanged, with: { (snapshot) in
//                snapshot.ref.removeValue()
//                FIRDatabase.database().reference().child("SpecRequests").removeAllObservers()
//            })
        }
        alertController.addAction(cancelAction)
        alertController.addAction(destroyAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
