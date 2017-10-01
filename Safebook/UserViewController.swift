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
            })
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coord = manager.location?.coordinate {
            let center = CLLocationCoordinate2D(latitude:coord.latitude, longitude:coord.longitude)
            userLocation = center
            let region = MKCoordinateRegion(center:center, span:MKCoordinateSpan(latitudeDelta:0.01, longitudeDelta:0.01))
            map.setRegion(region, animated: true)
            map.removeAnnotations(map.annotations)
            let annotation = MKPointAnnotation()
            annotation.coordinate = center
            annotation.title = "You are here"
            map.addAnnotation(annotation)
            print("annotation added \(coord.latitude) \(coord.longitude)")
        }
    }
    
    @IBAction func callTapped(_ sender: Any) {
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
    @IBAction func logoutTapped(_ sender: Any) {
        try? FIRAuth.auth()?.signOut()
        navigationController?.dismiss(animated: true, completion: nil)
    }
}
