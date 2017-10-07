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
import Mapbox

class AcceptViewController: UIViewController, MGLMapViewDelegate {

    @IBOutlet weak var map: MGLMapView!
    
    var requestLocation = CLLocationCoordinate2D()
    var specLocation = CLLocationCoordinate2D()
    var requestEmail = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        map.delegate = self
        map.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Set the map’s center coordinate and zoom level.
        map.setCenter(requestLocation, zoomLevel: 13, animated: false)

//        let region = MKCoordinateRegion(center: requestLocation, span: MKCoordinateSpanMake(0.5, 0.5))
//        map.setRegion(region, animated: false)
        
        let annotation = MGLPointAnnotation()
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

    func mapView(_ mapView: MGLMapView, imageFor annotation: MGLAnnotation) -> MGLAnnotationImage? {
        var annotationImage = mapView.dequeueReusableAnnotationImage(withIdentifier: "Pin")
        if annotationImage == nil {
            var image = UIImage(named: "Pin")!
            image = image.withAlignmentRectInsets(UIEdgeInsets(top: 0, left: 0, bottom: image.size.height/2, right: 0))
            annotationImage = MGLAnnotationImage(image: image, reuseIdentifier: "Pin")
        }
        return annotationImage
    }
    
    // Allow callout view to appear when an annotation is tapped.
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
}

