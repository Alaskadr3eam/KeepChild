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

    

    override func viewDidLoad() {
        super.viewDidLoad()
        mapKitViewAnnounce.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       // centerMapOnLocation()
    }
    
    func centerMapOnLocation() {
            if mapKitAnnounce.filter.latChoice != nil && mapKitAnnounce.filter.longChoice != nil && mapKitAnnounce.filter.regionRadius != nil {
            let initialLocation = CLLocation(latitude: mapKitAnnounce.filter.latChoice!, longitude: mapKitAnnounce.filter.longChoice!)
            let coordinateRegion = MKCoordinateRegion(center: initialLocation.coordinate,
                                                      latitudinalMeters: mapKitAnnounce.filter.regionRadius!, longitudinalMeters: mapKitAnnounce.filter.regionRadius!)
            mapKitViewAnnounce.setRegion(coordinateRegion, animated: true)
            mapKitViewAnnounce.showsUserLocation = true
        }
        let announce = mapKitAnnounce.announceListLocation
        mapKitViewAnnounce.addAnnotations(announce)
        if mapKitAnnounce.filter.profilLocIsSelected == true {
            let userHome = ProfilMapKit(coordinate: CLLocationCoordinate2D(latitude: mapKitAnnounce.filter.latChoice!, longitude: mapKitAnnounce.filter.longChoice!), title: "Home")
            
            mapKitViewAnnounce.addAnnotation(userHome)
            mapKitViewAnnounce.showsUserLocation = false
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segue.segueDetailAnnounce {
            let navVC = segue.destination as! UINavigationController
            let detailAnnounceVC = navVC.viewControllers.first as! DetailAnnounceTableViewController
            detailAnnounceVC.detailAnnounce.announce = mapKitAnnounce.announceDetail
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
            if annotation.title == "Home" {
                view.pinTintColor = UIColor.blue
            }
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            if annotation.title != "Home" {
                let mapsButton = UIButton(type: .detailDisclosure)
                view.rightCalloutAccessoryView = mapsButton
            }
        }
       // view.setSelected(true, animated: true)
        view.animatesDrop = true
        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView{
            guard let announceLoc = view.annotation as? AnnounceLocation else { return }
            mapKitAnnounce.announceDetail = mapKitAnnounce.transformAnnounceLocationIntoAnnounce(announceLoc: announceLoc)
            performSegue(withIdentifier: Constants.Segue.segueDetailAnnounce, sender: nil)
        }
    }

    
    
    
}

