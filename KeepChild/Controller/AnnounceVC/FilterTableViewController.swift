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
    //outlet for switch
    @IBOutlet var switchDay: [UISwitch]!
    @IBOutlet var switchJourNuit: [UISwitch]!

    
    override func viewDidLoad() {
        super.viewDidLoad()
       // initView()
       //initViewButton()
    }
    // MARK: -Action
    @IBAction func buttonResetIsClicked(_ sender: UIBarButtonItem) {
        FilterSearch.shared.initFilterSearch()
    }
    
    @IBAction func buttonCancelIsClicked(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func buttonIsClicked(_ sender: UIButton) {
        switch sender {
        case positionActuelleButton:
            positionActuelleButton.backgroundColor = UIColor.green
            positionProfilButton.backgroundColor = UIColor.white
            checkLocationAuthorizationStatus()
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
        distanceMile = Double(currentValue) / 1.60934
        FilterSearch.shared.regionRadius = Double(currentValue) * 1000
    }

    @IBAction func searchButtonIsClicked(_ sender: UIBarButtonItem) {
        if FilterSearch.shared.latChoice == nil && FilterSearch.shared.longChoice == nil {
            presentAlert(title: "Attention", message: "Parametre de localisation manquant, recherche impossible.")
            return
        }
        //!FilterSearch.shared.filterSearchIsComplete() ? prepareSearchList() : self.presentAlert(title: "Attention", message: "Vous n'avez pas choisie tout les critères de recherche.")
        FilterSearch.shared.initFilterSearch()
        prepareQueryLoc(latitude: Double(FilterSearch.shared.latChoice), longitude: Double(FilterSearch.shared.longChoice), distanceMile: distanceMile)
        createDayFilterForKeep()
        dismiss(animated: true, completion: nil)
        
    }

    func prepareSearchList() {
        FilterSearch.shared.initFilterSearch()
        prepareQueryLoc(latitude: Double(FilterSearch.shared.latChoice), longitude: Double(FilterSearch.shared.longChoice), distanceMile: distanceMile)
        createDayFilterForKeep()
    }

    // MARK: -Location With Profil
    //retrieve lat and long with profil adress
    func locationWithProfil() {
        FilterSearch.shared.latChoice = nil
        FilterSearch.shared.longChoice = nil
        let adressString = CurrentUserManager.shared.profil.city + CurrentUserManager.shared.profil.postalCode
        getCoordinate(addressString: adressString) { (coordinate, error) in
            guard error == nil else { return }
            guard coordinate != nil else { return }
            self.presentAlert(title: "Location", message: "Votre localisation à été trouvé.")
        }
    }
    //request geocoder for transalte adress string in CLLlocation
    func getCoordinate( addressString : String,
                        completionHandler: @escaping(CLLocationCoordinate2D, NSError?) -> Void ) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressString) { (placemarks, error) in
            guard error == nil else {
                completionHandler(kCLLocationCoordinate2DInvalid, error as NSError?)
                return
            }
            guard let placemark = placemarks?[0] else { return }
            let location = placemark.location!
            FilterSearch.shared.latChoice = location.coordinate.latitude
            FilterSearch.shared.longChoice = location.coordinate.longitude
            completionHandler(location.coordinate, nil)
        }
    }
    
    
    // MARK: - Helpers Func for UISwitch
    //func returns the UISwitchDay value following the position
    private func switchDayIsClicked(_ sender: UISwitch) {
        
        if sender.isOn {
            let result = returnForSwitch(sender)
            for (key,value) in result {
                //add result in FilterSearch
                FilterSearch.shared.dayFilter[key] = value
            }
        }
    }
    //func returns the UISwitchMomentDay value following the position
    private func switchMomentDayIsClicked(_ sender: UISwitch) {
        if sender.isOn {
            let result = returnForSwitch(sender)
            for (key,value) in result {
                //add result in FilterSearch
                FilterSearch.shared.momentDay[key] = value
            }
        }
    }
    //value returned from UISwitch
    private func returnForSwitch(_ sender: UISwitch) -> [String:Bool] {
        switch sender.tag {
        case 0:
            //sender.setValue("lundi", forKey: "lundi")
            return ["lundi":true]
        case 1:
            //sender.setValue("mardi", forKey: "mardi")
            return ["mardi":true]
        case 2:
            //sender.setValue("mercredi", forKey: "mercredi")
            return ["mercredi":true]
        case 3:
            //sender.setValue("jeudi", forKey: "jeudi")
            return ["jeudi":true]
        case 4:
            //sender.setValue("vendredi", forKey: "vendredi")
            return ["vendredi":true]
        case 5:
            //sender.setValue("samedi", forKey: "samedi")
            return ["samedi":true]
        case 6:
            //sender.setValue("dimanche", forKey: "dimanche")
            return ["dimanche":true]
        case 7:
            return ["day":true]
        case 8:
            return ["night":true]
        default : return ["":false]
        }
    }

    private func createDayFilterForKeep() {
        for switchButton in switchDay {
            switchDayIsClicked(switchButton)
        }
        for switchButton in switchJourNuit {
            switchMomentDayIsClicked(switchButton)
        }
    }

    // MARK: - Init View
    private func initViewButton() {
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
            positionActuelleButton.isEnabled = true
        }
        
        !FilterSearch.shared.filterSearchIsComplete() ? (buttonSearch.isEnabled = true) : (buttonSearch.isEnabled = false)
    }

    private func initView() {
        if FilterSearch.shared.dayFilter.count != 0 && FilterSearch.shared.momentDay.count != 0 {
            for sender in switchDay {
                for key in FilterSearch.shared.dayFilter {
                    if sender.value(forKey: key.key) as! String == key.key {
                        sender.isOn = true
                    } else {
                        sender.isOn = false
                    }
                }
            }
  /*      for (key,value) in FilterSearch.shared.dayFilter {
           /* self.initSwitchDay(key: key, switchDay: self.switchDay[0], day: "lundi")
            self.initSwitchDay(key: key, switchDay: self.switchDay[1], day: "mardi")
            self.initSwitchDay(key: key, switchDay: self.switchDay[2], day: "mercredi")
            self.initSwitchDay(key: key, switchDay: self.switchDay[3], day: "jeudi")
            self.initSwitchDay(key: key, switchDay: self.switchDay[4], day: "vendredi")
            self.initSwitchDay(key: key, switchDay: self.switchDay[5], day: "samedi")
            self.initSwitchDay(key: key, switchDay: self.switchDay[6], day: "dimanche")
          /*  initOneSwitchDay(key: key, switchDay: switchDay[0])*/
            initOneSwitchDay(key: key, switchDay: switchDay[1])
            initOneSwitchDay(key: key, switchDay: switchDay[2])
            initOneSwitchDay(key: key, switchDay: switchDay[3])
            initOneSwitchDay(key: key, switchDay: switchDay[4])
            initOneSwitchDay(key: key, switchDay: switchDay[5])
            initOneSwitchDay(key: key, switchDay: switchDay[6])*/
           // initAllSwitchDay(key: key)
            if key == day {
                switchDay.setOn(true, animated: true)
            } else {
                switchDay.setOn(false, animated: true)
            }
            
        }*/
      /*  for (key,value) in FilterSearch.shared.momentDay {
            self.initSwitchMomentDay(key: key, switchMomentDay: self.switchJourNuit[0], momentDay: "day")
            self.initSwitchMomentDay(key: key, switchMomentDay: self.switchJourNuit[1], momentDay: "night")
        }*/
        }
    }

    private func initAllSwitchDay(key: String) {
        for i in 0..<switchDay.count {
            initOneSwitchDay(key: key, switchDay: switchDay[i])
        }
    }

    private func initOneSwitchDay(key: String, switchDay: UISwitch) {
        let day = ["lundi","mardi","mercredi","jeudi","vendredi","samedi","dimanche"]
        for i in 0..<day.count {
            initSwitchDay(key: key, switchDay: switchDay, day: day[i])
        }
    }
    
    private func initSwitchDay(key: String, switchDay: UISwitch, day: String) {
        if key == day {
            switchDay.setOn(true, animated: true)
        } else {
            switchDay.setOn(false, animated: true)
        }
    }
    
    private func initSwitchMomentDay(key: String, switchMomentDay: UISwitch, momentDay: String) {
        if key == momentDay {
            switchMomentDay.isOn = true
        } else {
            switchMomentDay.isOn = false
        }
    }

    // MARK: - Location With position
    //Autoristion for location user
    private func checkLocationAuthorizationStatus() {
        FilterSearch.shared.removeLocationValue()
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
           // locationManager.distanceFilter = 100000
            guard let lat = locationManager.location?.coordinate.latitude else {
                presentAlert(title: "Attention Probleme", message: "Impossible de vous localiser, vérifiez vos parametres.")
                buttonSearch.isEnabled = true
                return }
            guard let long = locationManager.location?.coordinate.longitude else {
                buttonSearch.isEnabled = true
                return }
            FilterSearch.shared.addLocationValue(lat: lat,long: long)
            //longDouble = Double(long)
        } else {
            locationManager.requestWhenInUseAuthorization()
            positionActuelleButton.isEnabled = true
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


