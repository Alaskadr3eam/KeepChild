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
    //MARK: -Properties Outlet
    @IBOutlet weak var image: CustomImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var cpLabel: UILabel!
    @IBOutlet weak var locMapKit: CustomMKMapView!
    @IBOutlet weak var pseudoLabel: UILabel!
    @IBOutlet weak var telLabel: UILabel!
    @IBOutlet weak var mailLabel: UILabel!
    @IBOutlet weak var modifyButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var detailTableView: CustomTableView!

    //MARK: -Properties models
    var detailAnnounce = DetailAnnounce()
    var mapKitAnnounce = MapKitAnnounce()
    var profilGestion = ProfilGestion()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "< Back", style: .plain, target: self, action: #selector(backIsClicked))
        detailTableView.tableHeaderView?.isHidden = true
        
        detailTableView.allowsSelection = false
        detailTableView.setLoadingScreen()
        decodeProfilSaved()
        locMapKit.delegate = self
        request()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        request()
    }
    
  /*  override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        request()
    }*/
    //MARK: -Action func
    @objc func backIsClicked() {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func deleteAnnounce() {
        if CurrentUserManager.shared.user.senderId == detailAnnounce.announce.idUser {
            guard let id = detailAnnounce.announce.id else { return }
            detailAnnounce.deleteAnnounce(announceId: id)
        } else {
            self.presentAlert(title: "Attention", message: "Ceci n'est pas votre annonce.")
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sendMessage(_ sender: Any) {
        if !itsAnnounceOfUser() {
        performSegue(withIdentifier: "SendMessage", sender: nil)
        }
    }

    //MARK: -PrepareMapKit
    //func for prepare mapKitView
    private func centerMapOnLocation(location: CLLocation, regionRadius: CLLocationDistance) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        locMapKit.setRegion(coordinateRegion, animated: true)
        
    }
    //func for create annotation for mapKitView
    private func createAnnotationMapView() {
        let announceLoc = mapKitAnnounce.transformAnnounceIntoAnnounceLocation(announce: detailAnnounce.announce)
        mapKitAnnounce.announceDetailLocation = announceLoc
        locMapKit.addAnnotation(announceLoc)
    }
    //func for initialize mapKitView
    private func initializeRegionViewMapView() {
        createAnnotationMapView()
        let lat = mapKitAnnounce.announceDetailLocation.coordinate.latitude
        let longitude = mapKitAnnounce.announceDetailLocation.coordinate.longitude
        let initialisation = CLLocation(latitude: lat, longitude: longitude)
        let regionRadius: CLLocationDistance = 10000
        centerMapOnLocation(location: initialisation, regionRadius: regionRadius)
        //on enleve la possibilité d'interagir avec la mapKitView
        locMapKit.isUserInteractionEnabled = false
    }
    //func initialisation MapKitView
    private func initLocMapView() {
        initializeRegionViewMapView()
        //on enleve la page de chargement mapKit
        locMapKit.removeLoadingScreen()
    }

    private func retrieveCoordinateAnnounce() {
        let adresseString = ("\(profilGestion.profil.city) \(profilGestion.profil.postalCode)")
        print(adresseString)
        detailAnnounce.getCoordinate(addressString: adresseString) { [weak self] (coordinate, error) in
            guard let self = self else { return }
            guard error == nil else { return }
            guard coordinate != nil else { return }
            //une fois les coordonées trouvé on initialise makKitView
            self.initLocMapView()
            print(coordinate.latitude)
            print(coordinate.longitude)
            //on initialise la vue complete
            self.initView()
            self.detailTableView.removeLoadingScreen()
        }
    }
    
    func decodeProfilSaved(){
        if let savedProfil = UserDefaults.standard.object(forKey: "announce") as? Data {
            if let profilLoaded = try? JSONDecoder().decode(Announce.self, from: savedProfil) {
                self.detailAnnounce.announce = profilLoaded
            }
        }
    }
    //on verifie que l'annonce n'appartient pas a l'utilisateur avant d'ouvrir l'envoie message
    private func itsAnnounceOfUser() -> Bool {
        if detailAnnounce.announce.idUser == CurrentUserManager.shared.user.senderId {
            self.presentAlert(title: "Attention", message: "Ceci est votre annonce, vous ne pouvez pas vous envoyer un message.")
            return true
        }
        return false
    }
    
    //MARK: -Prepare Display Announce Detail
    private func request() {
      //mise en place d'une page de chargement(on l'enleve une fois l'image uploadé)
        //detailTableView.setLoadingScreen()
        locMapKit.setLoadingScreen()
        let idUser = detailAnnounce.announce.idUser
        profilGestion.retrieveProfilAnnounce(collection: "ProfilUser", field: "iDuser", equal: idUser) { [weak self] (error, profil) in
            guard let self = self else { return }
            guard error == nil else { return }
            guard profil != nil else { return }
            //une fois le prfil trouvé on trouve les coordonnées grace a l'adresse du profil
            self.retrieveCoordinateAnnounce()
        }
    }
    // MARK: - Prepare the view for display
    private func initView() {
        let announce = detailAnnounce.announce
        titleLabel.text = announce?.title
        priceLabel.text = announce?.price
        descriptionLabel.text = announce?.description
        pseudoLabel.text = profilGestion.profil.pseudo
        let city = profilGestion.profil.city
        let postalCode = profilGestion.profil.postalCode
        cpLabel.text = "\(postalCode),\(city)"
        telLabelInit()
        mailLabel.text = profilGestion.profil.mail
        image.downloadCustom(idUserImage: detailAnnounce.announce.idUser, contentMode: .scaleToFill)
       // self.detailTableView.removeLoadingScreen()

    }
    
    private func telLabelInit() {
        (detailAnnounce.announce.tel == true) ? (telLabel.text = String(profilGestion.profil.tel)) : (telLabel.text = "Le correspondant souhaite etre contacté uniquement par mail.")
    }

    //MARK: -Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SendMessage" {
            if let vcDestination = segue.destination as? FirstMessageTableViewController {
                vcDestination.idAnnounceUser = detailAnnounce.announce.idUser
                vcDestination.announce = detailAnnounce.announce
            }
        }
    }
    
    
}

extension DetailAnnounceTableViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // 2
        guard let annotation = annotation as? AnnounceLocation else { return nil }
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
        view.animatesDrop = true
        return view
    }
}

