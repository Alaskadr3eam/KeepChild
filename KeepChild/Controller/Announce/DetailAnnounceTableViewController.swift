//
//  DetailAnnounceTableViewController.swift
//  KeepChild
//
//  Created by Clément Martin on 17/09/2019.
//  Copyright © 2019 Clément Martin. All rights reserved.
//

import UIKit
import MapKit
import FirebaseAuth
import FirebaseFirestore
import CodableFirebase
import CoreLocation

class DetailAnnounceTableViewController: UITableViewController {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var cpLabel: UILabel!
    @IBOutlet weak var locMapKit: MKMapView!
    @IBOutlet weak var pseudoLabel: UILabel!
    @IBOutlet weak var modifyButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    var detailAnnounce = DetailAnnounce()
    var mapKitAnnounce = MapKitAnnounce()

  
    
    //var profilGestion = ProfilGestion()
    
    //var manageFireBase = ManageFireBase()

    //var userId = String()
    //var profil: ProfilUser!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locMapKit.delegate = self
        createAnnotationMapView()
        initLocMapView()
        adresseString()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        request()
    }
    
    private func centerMapOnLocation(location: CLLocation, regionRadius: CLLocationDistance) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        locMapKit.setRegion(coordinateRegion, animated: true)
    }
    
    private func createAnnotationMapView() {
        let announceLoc = mapKitAnnounce.transformAnnounceIntoAnnounceLocation(announce: detailAnnounce.announce)
        mapKitAnnounce.announceDetailLocation = announceLoc
        locMapKit.addAnnotation(announceLoc)
    }
    
    private func initializeRegionViewMapView() {
        let lat = mapKitAnnounce.announceDetailLocation.coordinate.latitude
        let longitude = mapKitAnnounce.announceDetailLocation.coordinate.longitude
        let initialisation = CLLocation(latitude: lat, longitude: longitude)
        let regionRadius: CLLocationDistance = 10000
        centerMapOnLocation(location: initialisation, regionRadius: regionRadius)
    }
    
    private func initLocMapView() {
        initializeRegionViewMapView()
    }
    private func adresseString() {
        let geocoder = CLGeocoder()
        let lat = mapKitAnnounce.announceDetailLocation.coordinate.latitude
        let longitude = mapKitAnnounce.announceDetailLocation.coordinate.longitude
        let location = CLLocation(latitude: lat, longitude: longitude)
        detailAnnounce.retrieveAdresseWithLocation(location: location, geocoder: geocoder) { [weak self] (error, placemark) in
            guard let self = self else { return }
            guard error == nil else { return }
            guard placemark != nil else { return }
            self.initLabelCp()
        }
    }
    private func request() {
       // guard let idUser = detailAnnounce.idUser else { return }
        let idUser = detailAnnounce.announce.idUser
        detailAnnounce.retrieveProfilUser(collection: "ProfilUser", field: "iDuser", equal: idUser) { [weak self] (error, profilUser) in
            guard let self = self else { return }
            guard error == nil else { return }
            guard profilUser != nil else { return }
            self.initView()
        }
    }
    // MARK: - Table view data source

    private func initView() {
        let announce = detailAnnounce.announce
        titleLabel.text = announce?.title
        priceLabel.text = announce?.price
        descriptionLabel.text = announce?.description
        pseudoLabel.text = detailAnnounce.profil.pseudo
        
        image.download(idUserImage: detailAnnounce.announce.idUser, contentMode: .scaleToFill)
    }
    
    private func initLabelCp() {
        cpLabel.text = "\(detailAnnounce.postalCode),\(detailAnnounce.locality)"
    }
    
    @IBAction func deleteAnnounce() {
        if detailAnnounce.idUser == detailAnnounce.announce.idUser {
        detailAnnounce.deleteAnnounce(announceId: detailAnnounce.announce.id)
        }
    }

}

extension DetailAnnounceTableViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // 2
        guard let annotation = annotation as? AnnounceLocation else { return nil }
        // 3
        let identifier = "marker"
        var view: MKMarkerAnnotationView
        // 4
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            // 5
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            //view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            let mapsButton = UIButton(type: .detailDisclosure)
            view.rightCalloutAccessoryView = mapsButton
        }
        return view
    }
}
/*extension DetailAnnounceTableViewController: ProfilGestionDelegate {
    func initViewEditProfil() {
    }
    
    func initViewDetailAnnounce() {
        initView()
    }
    
    
}*/
