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

class FilterTableViewController: UITableViewController {
    
    //MARK: - Properie
    let tabBar = UITabBar()
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
    
    
    
    var filter = Filter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
       initViewButton()
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
        resetSwitchAll(senderArray: switchAll)
        sliderDistance.setValue(50.0, animated: true)
        distanceLabel.text = "\(Int(sliderDistance.value)) Km"
        FilterSearch.shared.initLocFilterSearch()
    }
    
    @IBAction func buttonCancelIsClicked(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func buttonIsClicked(_ sender: UIButton) {
        switch sender {
        case positionActuelleButton:
            positionActuelleButton.backgroundColor = UIColor.green
            location()
            
            positionProfilButton.backgroundColor = UIColor.white
            //checkLocationAuthorizationStatus()
            FilterSearch.shared.profilLocIsSelected = false
        case positionProfilButton:
            positionProfilButton.backgroundColor = UIColor.green
            positionActuelleButton.backgroundColor = UIColor.white
            locationWithProfil()
            FilterSearch.shared.profilLocIsSelected = true
        default:break
        }
    }

    @IBAction func sliderValueChanged(_ sender: UISlider) {
        FilterSearch.shared.regionRadius = nil
        let currentValue = Int(sender.value)
        distanceLabel.text = "\(currentValue) Km"
        filter.distanceInMile(value: currentValue)
        /*distanceMile = Double(currentValue) / 1.60934
        FilterSearch.shared.regionRadius = Double(currentValue) * 1000*/
    }

    @IBAction func searchButtonIsClicked(_ sender: UIBarButtonItem) {
        if FilterSearch.shared.latChoice == nil && FilterSearch.shared.longChoice == nil {
            presentAlert(title: "Attention", message: "Parametre de localisation manquant, recherche impossible.")
            return
        }

        prepareSearchList()
        print(FilterSearch.shared.dayFilter)
        print(FilterSearch.shared.momentDay)
        FilterSearch.shared.filterSearchIsComplete() ? dismiss(animated: true, completion: nil) : self.presentAlert(title: "Attention", message: "Vous n'avez pas choisie tout les critères de recherche.")
    }

    func prepareSearchList() {
        FilterSearch.shared.initLocFilterSearch()
        filter.prepareQueryLoc()
        //createDayFilterForKeep()
    }

    // MARK: -Location With Profil
    //retrieve lat and long with profil adress
    func locationWithProfil() {
        FilterSearch.shared.removeLocationValue()
        let adressString = CurrentUserManager.shared.profil.city + CurrentUserManager.shared.profil.postalCode
        filter.getCoordinate(addressString: adressString) { (coordinate, error) in
            guard error == nil else { return }
            guard coordinate != nil else { return }
            self.presentAlert(title: "Location", message: "Votre localisation à été trouvé.")
        }
    }

    // MARK: - Helpers Func for UISwitch

    private func isDaySwitched(_ sender: UISwitch, day: String) {
        if sender.isOn {
            FilterSearch.shared.dayFilter[day] = true
        } else {
            guard let index = FilterSearch.shared.dayFilter.index(forKey: day) else { return }
            FilterSearch.shared.dayFilter.remove(at: index)
        }
    }
    
    private func isMomentDaySwitched(_ sender: UISwitch, moment: String) {
        if sender.isOn {
            FilterSearch.shared.momentDay[moment] = true
        } else {
            guard let index = FilterSearch.shared.momentDay.index(forKey: moment) else { return }
            FilterSearch.shared.momentDay.remove(at: index)
        }
    }

    // MARK: - Init View
    private func initView() {
        initViewSwitchDay()
        initViewSwitchMomentDay()
        if FilterSearch.shared.regionRadius != nil {
            let value: Float = filter.disTanceForSlider()
            sliderDistance.setValue(value, animated: true)
            distanceLabel.text = "\(Int(value)) Km"
        } else {
        sliderDistance.setValue(50.0, animated: true)
        distanceLabel.text = "\(Int(sliderDistance.value)) Km"
        }
    }
    private func initViewButton() {
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
            //positionActuelleButton.isEnabled = true
            positionActuelleButton.isHidden = true
            positionProfilButton.isSelected = true
        }
        
        //FilterSearch.shared.filterSearchIsComplete() ? (buttonSearch.isEnabled = true) : (buttonSearch.isEnabled = false)
    }
//var day = ["lundi","mardi","mercredi","jeudi","vendredi","samedi" "dimanche"]
    private func initViewSwitchDay() {
        for key in FilterSearch.shared.dayFilter {
            
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
        for key in FilterSearch.shared.momentDay {
            keyEqualSwitch(key: key.key, day: "day", sender: jourSwitch)
            keyEqualSwitch(key: key.key, day: "night", sender: nuitSwitch)
        }
    }
    private func keyEqualSwitch(key: String,day: String, sender: UISwitch) {
        if key == day {
            sender.setOn(true, animated: true)
        }
    }
    private func resetSwitchAll(senderArray: [UISwitch]) {
        for sender in senderArray {
        sender.setOn(false, animated: true)
        }
        FilterSearch.shared.initFilterDayAndMoment()
    }
    
    
    private func location() {
        filter.checkLocationAuthorizationStatus { [weak self] (bool) in
            guard let self = self else { return }
            guard bool == true else {
                self.presentAlert(title: "Attention Probleme", message: "Impossible de vous localiser, vérifiez vos parametres.")
                self.positionActuelleButton.backgroundColor = .white
                return
            }
        }
    }
    //prepare queryLoc for request
    private func prepareQueryLoc(latitude: Double, longitude: Double, distanceMile: Double) {
        let lat = 0.0144927536231884
        let lon = 0.0181818181818182
        
        let lowerLat = latitude - (lat * distanceMile)
        let lowerLon = longitude - (lon * distanceMile)
        
        let greaterLat = latitude + (lat * distanceMile)
        let greaterLon = longitude + (lon * distanceMile)
        
        let lesserGeopoint = GeoPoint(latitude: lowerLat, longitude: lowerLon)
        let greaterGeopoint = GeoPoint(latitude: greaterLat, longitude: greaterLon)
        FilterSearch.shared.lesserGeopoint = lesserGeopoint
        FilterSearch.shared.greaterGeopoint = greaterGeopoint
    }

}


