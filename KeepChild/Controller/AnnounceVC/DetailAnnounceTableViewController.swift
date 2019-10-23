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
    //MARK: - Outlet
    @IBOutlet weak var image: CustomImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var cpLabel: UILabel!
    @IBOutlet weak var locMapKit: CustomMKMapView!
    @IBOutlet weak var pseudoLabel: UILabel!
    @IBOutlet weak var telLabel: UILabel!
    @IBOutlet weak var mailLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var detailTableView: CustomTableView!
    //MARK: - Properties
    var detailAnnounce = AnnounceGestion(firebaseServiceSession: FirebaseService(dataManager: ManagerFirebase()))
    var mapKitAnnounce = MapKitAnnounceGestion()
    var profilGestion = ProfilGestion(firebaseServiceSession: FirebaseService(dataManager: ManagerFirebase()))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "< Retour", style: .plain, target: self, action: #selector(backIsClicked))
        Constants.configureTilteTextNavigationBar(view: self, title: .detailAnnounce)
        self.navigationItem.rightBarButtonItem?.tintColor = Constants.Color.titleNavBar
        detailTableView.tableHeaderView?.isHidden = true
        detailTableView.allowsSelection = false
        detailTableView.setLoadingScreen()
        locMapKit.delegate = self
        request()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        request()
    }
    //MARK: -Action func
    @objc func backIsClicked() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func deleteAnnounce() {
        //metter a l'initView
        if CurrentUserManager.shared.user.senderId == detailAnnounce.announce.idUser {
            guard let id = detailAnnounce.announce.id else { return }
            detailAnnounce.deleteAnnounce(announceId: id) { (error) in
                guard error == nil else {
                    self.presentAlert(title: "Erreur Suppression.", message: "Annonce non supprimée, vérifiez votre connexion internet.")
                    return
                }
                self.presentAlertWithActionDismiss(title: "Annonce Supprimée.", message: "Announce supprimé avec success.")
            }
        }
        
    }
    
    @IBAction func sendMessage(_ sender: Any) {
        if !itsAnnounceOfUserForMessage() {
            performSegue(withIdentifier: Constants.Segue.segueSendMessage, sender: nil)
        }
    }
    
    @IBAction func call() {
        if !itsAnnounceOfUserForTel() {
            if detailAnnounce.announce.tel == true {
                if let url = URL(string: "tel://\(profilGestion.profil.tel)"), UIApplication.shared.canOpenURL(url) {
                    if #available(iOS 10, *)
                    {
                        UIApplication.shared.open(url)
                    } else {
                        UIApplication.shared.open(url)
                    }
                }
            }
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
        guard let announceLoc = mapKitAnnounce.transformAnnounceIntoAnnounceLocation(announce: detailAnnounce.announce) else { return }
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
    // request geocoder for mapKit
    private func retrieveCoordinateAnnounce() {
        let adresseString = ("\(profilGestion.profil.city) \(profilGestion.profil.postalCode)")
        print(adresseString)
        detailAnnounce.getCoordinate(addressString: adresseString) { [weak self] (coordinate, error) in
            guard let self = self else { return }
            guard error == nil else { return }
            guard coordinate != nil else { return }
            //une fois les coordonées trouvé on initialise makKitView
            self.initLocMapView()
            //on initialise la vue complete
            self.initView()
            self.detailTableView.removeLoadingScreen()
        }
    }
    //MARK: - Helpers
    //on verifie que l'annonce n'appartient pas a l'utilisateur avant d'ouvrir l'envoie message
    private func itsAnnounceOfUserForMessage() -> Bool {
        if detailAnnounce.announce.idUser == CurrentUserManager.shared.user.senderId {
            self.presentAlert(title: "Attention", message: "Ceci est votre annonce, vous ne pouvez pas vous envoyer un message.")
            return true
        }
        return false
    }
    
    private func itsAnnounceOfUserForTel() -> Bool {
        if profilGestion.profil.tel == CurrentUserManager.shared.profil.tel {
            self.presentAlert(title: "Attention", message: "Ceci est votre annonce, vous ne pouvez pas vous appeler.")
            return true
        }
        return false
    }
    
    private func telLabelInit() {
        (detailAnnounce.announce.tel == true) ? (telLabel.text = String(profilGestion.profil.tel)) : (telLabel.text = "Le correspondant souhaite etre contacté uniquement par mail.")
    }
    
    private func buttonDeleteInitView() {
        if CurrentUserManager.shared.user.senderId == detailAnnounce.announce.idUser {
            deleteButton.isHidden = false
        } else {
            deleteButton.isHidden = true
        }
    }
    //MARK: -Prepare Display Announce Detail
    private func request() {
        //mise en place d'une page de chargement(on l'enleve une fois l'image uploadé)
        locMapKit.setLoadingScreen()
        let idUser = detailAnnounce.announce.idUser
        profilGestion.retrieveProfilAnnounce(field: "iDuser", equal: idUser) { [weak self] (error, profil) in
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
        descriptionTextView.text = announce?.description
        pseudoLabel.text = profilGestion.profil.pseudo
        let city = profilGestion.profil.city
        let postalCode = profilGestion.profil.postalCode
        cpLabel.text = "\(postalCode),\(city)"
        telLabelInit()
        mailLabel.text = profilGestion.profil.mail
        image.downloadCustom(idUserImage: detailAnnounce.announce.idUser, contentMode: .scaleToFill)
        buttonDeleteInitView()
    }
    //MARK: -Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segue.segueSendMessage {
            if let vcDestination = segue.destination as? FirstMessageTableViewController {
                vcDestination.manageConversation.announce = detailAnnounce.announce
            }
        }
    }
}

extension DetailAnnounceTableViewController: MKMapViewDelegate {
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
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            let mapsButton = UIButton(type: .detailDisclosure)
            view.rightCalloutAccessoryView = mapsButton
        }
        view.animatesDrop = true
        return view
    }
}

