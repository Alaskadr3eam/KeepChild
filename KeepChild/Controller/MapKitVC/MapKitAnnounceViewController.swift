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
    //MARK: - Outlet
    @IBOutlet weak var mapKitViewAnnounce: MKMapView!
    //MARK: - Properties
    var mapKitAnnounce = MapKitAnnounceGestion()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapKitViewAnnounce.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if mapKitAnnounce.filter != nil {
            centerMapOnLocation()
        }
    }
    //MARK: - Func
    private func centerMapOnLocation() {
        if mapKitAnnounce.filter.latChoice != nil && mapKitAnnounce.filter.longChoice != nil && mapKitAnnounce.filter.regionRadius != nil {
            guard
                let lat = mapKitAnnounce.filter.latChoice,
                let long = mapKitAnnounce.filter.longChoice,
                let regionRadius = mapKitAnnounce.filter.regionRadius else { return }
            
            let initialLocation = CLLocation(latitude: lat, longitude: long)
            let coordinateRegion = MKCoordinateRegion(center: initialLocation.coordinate,
                                                      latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
            mapKitViewAnnounce.setRegion(coordinateRegion, animated: true)

        }
        let announce = mapKitAnnounce.announceListLocation
        mapKitViewAnnounce.addAnnotations(announce)
        if mapKitAnnounce.filter.profilLocIsSelected == true {
            guard
                let lat = mapKitAnnounce.filter.latChoice,
                let long = mapKitAnnounce.filter.longChoice else { return }
            let userHome = ProfilMapKit(coordinate: CLLocationCoordinate2D(latitude: lat, longitude: long), title: "Home")
            mapKitViewAnnounce.addAnnotation(userHome)
            mapKitViewAnnounce.showsUserLocation = false
        } else {
            mapKitViewAnnounce.showsUserLocation = true
        }
    }
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segue.segueDetailAnnounce {
            let navVC = segue.destination as! UINavigationController
            let detailAnnounceVC = navVC.viewControllers.first as! DetailAnnounceTableViewController
            detailAnnounceVC.detailAnnounce.announce = mapKitAnnounce.announceDetail
        }
    }
}

extension MapKitAnnounceViewController: MKMapViewDelegate {
    //func for prepare pinAnnotation In MapView
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? AnnounceLocation else { return nil }
        let identifier = "marker"
        var view: MKPinAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKPinAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
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
//objet for geoLoc profil for Pin Home on mapView
class ProfilMapKit: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    let title: String?
    init(coordinate: CLLocationCoordinate2D, title: String) {
        self.coordinate = coordinate
        self.title = title
        super.init()
    }
}
