//
//  MapKitAnnounceViewController.swift
//  KeepChild
//
//  Created by Clément Martin on 19/09/2019.
//  Copyright © 2019 Clément Martin. All rights reserved.
//

import UIKit
import MapKit

class MapKitAnnounceViewController: UIViewController {
    
    var mapKitAnnounce = MapKitAnnounce()
    
    @IBOutlet weak var mapKitViewAnnounce: MKMapView!
    
   // let locationManager = CLLocationManager()
   // let regionRadius: CLLocationDistance = 10000
  /*  func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationManager.distanceFilter = 100000
            guard let lat = locationManager.location?.coordinate.latitude else { return }
            guard let long = locationManager.location?.coordinate.longitude else { return }
           // guard lat != nil, long != nil else { return }
            let initialLocation = CLLocation(latitude: lat, longitude: long)
            centerMapOnLocation(location: initialLocation)
            mapKitViewAnnounce.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }*/

    func centerMapOnLocation() {
        if FilterSearch.shared.latChoice != nil && FilterSearch.shared.longChoice != nil && FilterSearch.shared.regionRadius != nil {
        let initialLocation = CLLocation(latitude: FilterSearch.shared.latChoice, longitude: FilterSearch.shared.longChoice)
        let coordinateRegion = MKCoordinateRegion(center: initialLocation.coordinate,
                                                  latitudinalMeters: FilterSearch.shared.regionRadius, longitudinalMeters: FilterSearch.shared.regionRadius)
        mapKitViewAnnounce.setRegion(coordinateRegion, animated: true)
        mapKitViewAnnounce.showsUserLocation = true
        }
        let announce = mapKitAnnounce.announceListLocation
        mapKitViewAnnounce.addAnnotations(announce)
        if FilterSearch.shared.profilLocIsSelected == true {
            let userHome = ProfilMapKit(coordinate: CLLocationCoordinate2D(latitude: FilterSearch.shared.latChoice, longitude: FilterSearch.shared.longChoice), title: "Home")
            
            mapKitViewAnnounce.addAnnotation(userHome)
            mapKitViewAnnounce.showsUserLocation = false
          //  mapKitViewAnnounce.userLocation.
        } else {
           // mapKitViewAnnounce.showsUserLocation = true
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //checkLocationAuthorizationStatus()
        mapKitViewAnnounce.delegate = self
       // mapKitAnnounce.toFillTheLocationAnnounceArray()
        //let announce = mapKitAnnounce.announceListLocation
        //mapKitViewAnnounce.addAnnotations(announce)
        //centerMapOnLocation(location: initialLocation)
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        centerMapOnLocation()
      /*  let announce = mapKitAnnounce.announceListLocation
        mapKitViewAnnounce.addAnnotations(announce)*/
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailAnnounce" {
            if let vcDestination = segue.destination as? DetailAnnounceTableViewController {
                vcDestination.detailAnnounce.announce = mapKitAnnounce.announceDetail
            }
        }
    }
 
    

}

class ProfilMapKit: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    let title: String?
    init(coordinate: CLLocationCoordinate2D, title: String) {
        self.coordinate = coordinate
        self.title = title
        super.init()
    }
}
extension MapKitAnnounceViewController: MKMapViewDelegate {

    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // 2
        guard let annotation = annotation as? AnnounceLocation else { return nil }
        //guard let annotationProfil = annotation as? ProfilMapKit else { return nil }
        // 3
        let identifier = "marker"
        var view: MKPinAnnotationView
        // 4
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKPinAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            // 5
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
           
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            //view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            let mapsButton = UIButton(type: .detailDisclosure)
            view.rightCalloutAccessoryView = mapsButton
            
        }
       // view.setSelected(true, animated: true)
        view.animatesDrop = true
        return view
    }

   /* func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var view: MKPinAnnotationView!
        // 2
        if let annotation = annotation as? AnnounceLocation {
        // 3
        let identifier = "marker"
        
        // 4
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKPinAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            // 5
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            //view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            let mapsButton = UIButton(type: .detailDisclosure)
            view.rightCalloutAccessoryView = mapsButton
            }
        } else if let annotationProfil = annotation as? ProfilMapKit {
            let identifier = "marker"
            
            // 4
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
                as? MKPinAnnotationView {
                dequeuedView.annotation = annotationProfil
                view = dequeuedView
            } else {
                // 5
                view = MKPinAnnotationView(annotation: annotationProfil, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                //view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
                view.pinTintColor = UIColor.blue
                
            }
        }
        // view.setSelected(true, animated: true)
        view.animatesDrop = true
        return view
    }*/
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView{
            guard let announceLoc = view.annotation as? AnnounceLocation else { return }
            mapKitAnnounce.announceDetail = mapKitAnnounce.transformAnnounceLocationIntoAnnounce(announceLoc: announceLoc)
            performSegue(withIdentifier: "DetailAnnounce", sender: nil)
        }
    }

    

    
    
}

/*class MKPinAnnotationView: MKAnnotationView {
    var animatesDrop = true
    
}*/
