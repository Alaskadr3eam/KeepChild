//
//  FilterTableViewController.swift
//  KeepChild
//
//  Created by Clément Martin on 30/09/2019.
//  Copyright © 2019 Clément Martin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import CoreLocation

class FilterTableViewController: UITableViewController, CLLocationManagerDelegate {
    
    //MARK: - Outlet
    //outlet bar button item
    @IBOutlet weak var buttonSearch: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var resetButton: UIBarButtonItem!
    //outlet for distance
    @IBOutlet weak var sliderDistance: UISlider!
    @IBOutlet weak var distanceLabel: UILabel!
    var distanceMile = Double()
    //outlet for choice location
    @IBOutlet weak var positionActuelleButton: UIButton!
    @IBOutlet weak var positionProfilButton: UIButton!
    let locationManager = CLLocationManager()
    //outlet for switch week
    @IBOutlet weak var lundiSwitch: UISwitch!
    @IBOutlet weak var mardiSwitch: UISwitch!
    @IBOutlet weak var mercrediSwitch: UISwitch!
    @IBOutlet weak var jeudiSwitch: UISwitch!
    @IBOutlet weak var vendrediSwitch: UISwitch!
    @IBOutlet weak var samediSwitch: UISwitch!
    @IBOutlet weak var dimancheSwitch: UISwitch!
    //outlet for moment day
    @IBOutlet weak var jourSwitch: UISwitch!
    @IBOutlet weak var nuitSwitch: UISwitch!
    
    @IBOutlet var switchAll: [UISwitch]!
    //MARK: - Properties
    var delegate: isAbleToReceiveFilter?
    var filter = FilterManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        Constants.configureTilteTextNavigationBar(view: self, title: .filterAnnounce)
        self.navigationItem.rightBarButtonItem?.tintColor = Constants.Color.titleNavBar
        self.navigationItem.leftBarButtonItem?.tintColor = Constants.Color.titleNavBar
        initView()
    }
    // MARK: -Action
    @IBAction func lundiIsSwitched(_ sender: UISwitch) {
        isDaySwitched(sender, day: "lundi")
    }
    @IBAction func mardiIsSwitched(_ sender: UISwitch) {
        isDaySwitched(sender, day: "mardi")
    }
    @IBAction func mercrediIsSwitched(_ sender: UISwitch) {
        isDaySwitched(sender, day: "mercredi")
    }
    @IBAction func jeudiIsSwitched(_ sender: UISwitch) {
        isDaySwitched(sender, day: "jeudi")
    }
    @IBAction func vendrediIsSwitched(_ sender: UISwitch) {
        isDaySwitched(sender, day: "vendredi")
    }
    @IBAction func samediIsSwitched(_ sender: UISwitch) {
        isDaySwitched(sender, day: "samedi")
    }
    @IBAction func dimancheIsSwitched(_ sender: UISwitch) {
        isDaySwitched(sender, day: "dimanche")
    }
    
    @IBAction func jourIsSwitched(_ sender: UISwitch) {
        isMomentDaySwitched(sender, moment: "day")
    }
    @IBAction func nuitIsSwitched(_ sender: UISwitch) {
        isMomentDaySwitched(sender, moment: "night")
    }
    @IBAction func buttonResetIsClicked(_ sender: UIBarButtonItem) {
        resetSwitchAllAndSlider(senderArray: switchAll)
    }
    @IBAction func buttonCancelIsClicked(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func buttonIsClicked(_ sender: UIButton) {
        switch sender {
        case positionActuelleButton:
            location()
        case positionProfilButton:
            positionProfilButton.isSelected = true
            positionActuelleButton.isSelected = false
            locationWithProfil()
            filter.profilLocIsSelected = true
        default:break
        }
    }
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        let currentValue = Int(sender.value)
        distanceLabel.text = "\(currentValue) Km"
        filter.distanceInMile(value: sender.value)
        filter.distanceInMetersForRegionRadiusMapKit(value: sender.value)
    }
    @IBAction func searchButtonIsClicked(_ sender: UIBarButtonItem) {
      /*  if filter.filter != nil {
            filter.createFilterForSearch()
            delegate?.pass(filter: filter.filter)
            dismiss(animated: true, completion: nil)
        } else {*/
            filter.prepareQueryIsPossibleOrNot() ? filter.prepareQueryLoc() : presentAlert(title: "Attention", message: "Parametre de localisation manquant, recherche impossible.")
            filterIsComplete()
       // }
    }
    // MARK: -Location With Profil
    //retrieve lat and long with profil adress
    func locationWithProfil() {
        let adressString = CurrentUserManager.shared.profil.city + CurrentUserManager.shared.profil.postalCode
        filter.getCoordinate(addressString: adressString) { (coordinate, error) in
            guard error == nil, coordinate != nil else {
                self.positionProfilButton.isSelected = false
                self.presentAlert(title: "Location", message: "Votre localisation n'a pas été trouvé.")
                return }
        }
    }
    
    //MARK: - Location with position
    private func location() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            // locationManager.distanceFilter = 100000
            guard let lat = locationManager.location?.coordinate.latitude, let long = locationManager.location?.coordinate.longitude else {
                self.presentAlert(title: "Attention Probleme", message: "Impossible de vous localiser, vérifiez vos parametres.")
                self.positionActuelleButton.isSelected = false
                self.positionProfilButton.isSelected = true
                return }
            self.positionActuelleButton.isSelected = true
            self.positionProfilButton.isSelected = false
            self.filter.profilLocIsSelected = false
            self.filter.latChoice = lat
            self.filter.longChoice = long
        } else {
            self.presentAlert(title: "Attention Probleme", message: "Impossible de vous localiser, vérifiez vos parametres.")
            self.positionActuelleButton.isSelected = false
            self.positionProfilButton.isSelected = true
            locationManager.requestWhenInUseAuthorization()
        }
    }

    // MARK: - Helpers Func for UISwitch
    private func isDaySwitched(_ sender: UISwitch, day: String) {
        if sender.isOn {
            filter.dayFilter[day] = true
        } else {
            guard let index1 = filter.dayFilter.index(forKey: day) else { return }
            filter.dayFilter.remove(at: index1)
        }
    }
    
    private func isMomentDaySwitched(_ sender: UISwitch, moment: String) {
        if sender.isOn {
            filter.momentDay[moment] = true
        } else {
            guard let index1 = filter.momentDay.index(forKey: moment) else { return }
            filter.momentDay.remove(at: index1)
        }
    }
    //MARK: - Helpers
    private func resetSwitchAllAndSlider(senderArray: [UISwitch]) {
        filter.filter = nil
        for sender in senderArray {
            sender.setOn(false, animated: true)
        }
        sliderDistance.setValue(50.0, animated: true)
        filter.distanceInMetersForRegionRadiusMapKit(value: 50.0)
        filter.distanceInMile(value: 50.0)
        distanceLabel.text = "\(Int(sliderDistance.value)) Km"
    }
    
    private func filterOkPassAndDismiss() {
        filter.createFilterForSearch()
        delegate?.pass(filter: filter.filter)
        dismiss(animated: true, completion: nil)
    }
    
    private func filterIsComplete() {
        filter.filterSearchIsComplete() ? filterOkPassAndDismiss() : presentAlert(title: "Attention", message: "Vous n'avez pas choisie tout les critères de recherche.")
    }
    // MARK: - Init View
    private func initView() {
      /*  if filter.filter != nil {
            initViewSwitchDay()
            initViewSwitchMomentDay()
            if filter.filter.profilLocIsSelected == true {
                positionProfilButton.isSelected = true
                positionActuelleButton.isSelected = false
            } else {
                positionActuelleButton.isSelected = true
                positionProfilButton.isSelected = false
            }
            filter.latChoice = filter.filter.latChoice
            filter.longChoice = filter.filter.longChoice
            filter.dayFilter = filter.filter.dayFilter
            filter.momentDay = filter.filter.momentDay
            filter.lesserGeopoint = filter.filter.lesserGeopoint
            filter.greaterGeopoint = filter.filter.greaterGeopoint
            filter.regionRadius = filter.filter.regionRadius
            filter.profilLocIsSelected = filter.filter.profilLocIsSelected
            guard let value = filter.disTanceForSlider() else { return }
            sliderDistance.setValue(value, animated: true)
            distanceLabel.text = "\(Int(value)) Km"
        } else {
            sliderDistance.setValue(50.0, animated: true)
            filter.distanceInMetersForRegionRadiusMapKit(value: 50.0)
            filter.distanceInMile(value: 50.0)
            distanceLabel.text = "\(Int(sliderDistance.value)) Km"
        }*/
        sliderDistance.setValue(50.0, animated: true)
        filter.distanceInMetersForRegionRadiusMapKit(value: 50.0)
        filter.distanceInMile(value: 50.0)
        distanceLabel.text = "\(Int(sliderDistance.value)) Km"
    }
    
    private func initViewSwitchDay() {
        for key in filter.filter.dayFilter {
            keyEqualSwitch(key: key.key, day: "lundi", sender: lundiSwitch)
            keyEqualSwitch(key: key.key, day: "mardi", sender: mardiSwitch)
            keyEqualSwitch(key: key.key, day: "mercredi", sender: mercrediSwitch)
            keyEqualSwitch(key: key.key, day: "jeudi", sender: jeudiSwitch)
            keyEqualSwitch(key: key.key, day: "vendredi", sender: vendrediSwitch)
            keyEqualSwitch(key: key.key, day: "samedi", sender: samediSwitch)
            keyEqualSwitch(key: key.key, day: "dimanche", sender: dimancheSwitch)
        }
    }
    
    private func initViewSwitchMomentDay() {
        for key in filter.filter.momentDay {
            keyEqualSwitch(key: key.key, day: "day", sender: jourSwitch)
            keyEqualSwitch(key: key.key, day: "night", sender: nuitSwitch)
        }
    }
    
    private func keyEqualSwitch(key: String,day: String, sender: UISwitch) {
        if key == day {
            sender.setOn(true, animated: true)
        }
    }
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segue.segueSearch {
            let navVC = segue.destination as! UINavigationController
            let masterVC = navVC.viewControllers.first as! MasterViewController
            masterVC.announceList.filter = filter.filter
        }
    }
}

protocol isAbleToReceiveFilter {
    func pass(filter: Filter)
}

