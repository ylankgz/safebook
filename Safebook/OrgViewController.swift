////
////  OrgViewController.swift
////  Safebook
////
////  Created by Ulan on 11/11/17.
////  Copyright © 2017 SafebookApp. All rights reserved.
////
//
//import UIKit
//import MapKit
//
//class OrgViewController: UIViewController {
//
//    var data:[Any] = []
//    @IBOutlet weak var mapView: MKMapView!
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        mapView.showsUserLocation = true
//
//        mapView.centerCoordinate = CLLocationCoordinate2D(latitude: 41.0, longitude: 75.0)
//    }
//
//    func loadData() {
////        let specCLLocation = CLLocation(latitude: specLocation.latitude, longitude: specLocation.longitude)
////        let userCLLocation = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
////
//        mapView.removeAnnotations(mapView.annotations)
//
//        data = [
//            Org(name:"ОФ Подруга", email:"podruga_osh@mail.ru", phone:"+996 3222 22478"),
//            Org(name:"ОО «МСРО Y-PEER»", email:"podruga_osh@mail.ru", phone:"+996 (3222)24156"),
//            Org(name:"ОФ Подруга", email:"podruga_osh@mail.ru", phone:"+996 03222 22478"),
//
//
//        ]
//
//        let userAnno = MKPointAnnotation()
//        userAnno.coordinate = userLocation
//        userAnno.title = "You are here!"
//        map.addAnnotations([userAnno, specAnno])
//    }
//
//    @IBAction func doneTapped(_ sender: Any) {
//        navigationController?.dismiss(animated: true, completion: nil)
//    }
//}
//
//struct Org {
//    var name:String
//    var email:String
//    var phone:String
//}

