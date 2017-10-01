//
//  AcceptViewController.swift
//  Safebook
//
//  Created by Ulan on 10/1/17.
//  Copyright © 2017 SafebookApp. All rights reserved.
//

import UIKit
import MapKit
import FirebaseDatabase

class AcceptViewController: UIViewController {

    @IBOutlet weak var map: MKMapView!
    var requestLocation = CLLocationCoordinate2D()
    var specLocation = CLLocationCoordinate2D()
    var requestEmail = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        let region = MKCoordinateRegion(center: requestLocation, span: MKCoordinateSpanMake(0.01, 0.01))
        map.setRegion(region, animated: false)
        let annotation = MKPointAnnotation()
        annotation.coordinate = requestLocation
        annotation.title = requestEmail
        map.addAnnotation(annotation)
    }
    
    @IBAction func acceptTapped(_ sender: Any) {
        // Update the request
        FIRDatabase.database().reference().child("SpecRequests").queryOrdered(byChild: "email").queryEqual(toValue: requestEmail).observe(.childAdded) { (snapshot) in
            snapshot.ref.updateChildValues(["specLat": self.specLocation.latitude, "specLon": self.specLocation.longitude])
            FIRDatabase.database().reference().child("SpecRequests").removeAllObservers()
        }
        // Give directions
        let requestCLLocation = CLLocation(latitude:requestLocation.latitude, longitude: requestLocation.longitude)
        CLGeocoder().reverseGeocodeLocation(requestCLLocation) { (placemarks, error) in
            if let placemarks = placemarks {
                if placemarks.count > 0 {
                    let mapItem = MKMapItem(placemark: MKPlacemark(placemark: placemarks[0]))
                    mapItem.name = self.requestEmail
                    mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
                }
            }
        }
    }
}
