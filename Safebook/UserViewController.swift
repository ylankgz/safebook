//
//  UserViewController.swift
//  Safebook
//
//  Created by Ulan on 9/30/17.
//  Copyright © 2017 SafebookApp. All rights reserved.
//

import UIKit
import MapKit
import FirebaseDatabase
import FirebaseAuth

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

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        if let email = FIRAuth.auth()?.currentUser?.email {
            FIRDatabase.database().reference().child("SpecRequests").queryOrdered(byChild: "email").queryEqual(toValue: email).observe(.childAdded, with: { (snapshot) in
                self.specHasBeenCalled = true
                self.callButton.setTitle("Cancel Call", for: .normal)
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
        self.callButton.setTitle("Your Client is \(roundedDistance)km away", for: .normal)
        
        let latDelta = abs(specLocation.latitude - userLocation.latitude) * 2 + 0.5
        let lonDelta = abs(specLocation.longitude - userLocation.longitude) * 2 + 0.5
        map.removeAnnotations(map.annotations)
        print("loc \(latDelta) and \(lonDelta)")
        let region = MKCoordinateRegionMake(userLocation, MKCoordinateSpanMake(latDelta, lonDelta))
        map.setRegion(region, animated: true)
        
        let specAnno = MKPointAnnotation()
        specAnno.coordinate = specLocation
        specAnno.title = "Your client!"

        let userAnno = MKPointAnnotation()
        userAnno.coordinate = userLocation
        userAnno.title = "You are here!"
        map.addAnnotations([userAnno, specAnno])
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coord = manager.location?.coordinate {
            let center = CLLocationCoordinate2D(latitude:coord.latitude, longitude:coord.longitude)
            userLocation = center
            
            if specHasBeenCalled {
                self.displayUserAndSpec()
            } else {
                let region = MKCoordinateRegion(center:center, span:MKCoordinateSpan(latitudeDelta:0.5, longitudeDelta:0.5))
                map.setRegion(region, animated: true)
                map.removeAnnotations(map.annotations)
                let annotation = MKPointAnnotation()
                annotation.coordinate = center
                annotation.title = "You are here"
                map.addAnnotation(annotation)
                //print("annotation added \(coord.latitude) \(coord.longitude)")
            }
        }
    }
    
    @IBAction func callTapped(_ sender: Any) {
        if !specOnTheWay {
            if let email = FIRAuth.auth()?.currentUser?.email {
                if specHasBeenCalled {
                    specHasBeenCalled = false
                    callButton.setTitle("Call Spec", for: .normal)
                    FIRDatabase.database().reference().child("SpecRequests").queryOrdered(byChild: "email").queryEqual(toValue: email).observe(.childAdded, with: { (snapshot) in
                        snapshot.ref.removeValue()
                        FIRDatabase.database().reference().child("SpecRequests").removeAllObservers()
                    })
                } else {
                    let specRequestDict = ["email": email, "lat": userLocation.latitude, "lon": userLocation.longitude] as [String : Any]
                    FIRDatabase.database().reference().child("SpecRequests").childByAutoId().setValue(specRequestDict)
                    specHasBeenCalled = true
                    callButton.setTitle("Cancel Call", for: .normal)
                }
            }
        }
    }
    @IBAction func logoutTapped(_ sender: Any) {
        try? FIRAuth.auth()?.signOut()
        navigationController?.dismiss(animated: true, completion: nil)
    }
}
