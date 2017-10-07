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
import Mapbox

class UserViewController: UIViewController, MGLMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var map: MGLMapView!
    //    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var callButton: UIButton!
    var locationManager = CLLocationManager()
    var userLocation = CLLocationCoordinate2D()
    var specHasBeenCalled:Bool = false
    var specLocation = CLLocationCoordinate2D()
    var specOnTheWay = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        map.delegate = self
        map.autoresizingMask = [.flexibleWidth, .flexibleHeight]

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
                self.callButton.setTitle("Cancel share", for: .normal)
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

//        let latDelta = abs(specLocation.latitude - userLocation.latitude) * 2 + 0.5
//        let lonDelta = abs(specLocation.longitude - userLocation.longitude) * 2 + 0.5
//
        if let annos = map.annotations {map.removeAnnotations(annos)}

//        print("loc \(latDelta) and \(lonDelta)")
//        let region = MKCoordinateRegionMake(userLocation, MKCoordinateSpanMake(latDelta, lonDelta))
//        map.setRegion(region, animated: true)

        let specAnno = MGLPointAnnotation()
        specAnno.coordinate = specLocation
        specAnno.title = "Your target!"
//        let userAnno = MGLPointAnnotation()
//        userAnno.coordinate = userLocation
//        userAnno.title = "You are here!"
        map.addAnnotation(specAnno)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coord = manager.location?.coordinate {
            let center = CLLocationCoordinate2D(latitude:coord.latitude, longitude:coord.longitude)
            userLocation = center

            if specHasBeenCalled {
                self.checkSpecLocation()
            } else {
//                let region = MKCoordinateRegion(center:center, span:MKCoordinateSpan(latitudeDelta:0.5, longitudeDelta:0.5))
//                map.setRegion(region, animated: true)
                
                if let annos = map.annotations {map.removeAnnotations(annos)}

                map.setCenter(center, zoomLevel: 13, direction: 0, animated: false)
//                let annotation = MGLPointAnnotation()
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
                    callButton.setTitle("Share location", for: .normal)
                    callButton.setBackgroundImage(#imageLiteral(resourceName: "Share"), for: .normal)
                    FIRDatabase.database().reference().child("SpecRequests").queryOrdered(byChild: "email").queryEqual(toValue: email).observe(.childAdded, with: { (snapshot) in
                        snapshot.ref.removeValue()
                        FIRDatabase.database().reference().child("SpecRequests").removeAllObservers()
                    })
                } else {
                    let specRequestDict = ["email": email, "lat": userLocation.latitude, "lon": userLocation.longitude, "name": name] as [String : Any]
                    FIRDatabase.database().reference().child("SpecRequests").childByAutoId().setValue(specRequestDict)
                    
                    specHasBeenCalled = true
                    callButton.setTitle("Cancel share", for: .normal)
                    callButton.setBackgroundImage(#imageLiteral(resourceName: "Cancel"), for: .normal)
                }
            } else {
                self.displayAlert(title: "Warning", message: "You want to drop meeting?", email: email)
            }
        }
    }
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        return nil
    }
    
    // Allow callout view to appear when an annotation is tapped.
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }

    @IBAction func logoutTapped(_ sender: Any) {
        try? FIRAuth.auth()?.signOut()
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func displayAlert(title: String, message: String, email: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let destroyAction = UIAlertAction(title: "Drop", style: .destructive) { (result : UIAlertAction) -> Void in
//            FIRDatabase.database().reference().child("SpecRequests\(self.key)").removeValue()
            // Drop meeting
            self.specHasBeenCalled = false
            self.callButton.setTitle("Share location", for: .normal)
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
