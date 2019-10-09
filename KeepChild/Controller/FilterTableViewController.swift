//
//  FilterTableViewController.swift
//  KeepChild
//
//  Created by Clément Martin on 30/09/2019.
//  Copyright © 2019 Clément Martin. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation

class FilterTableViewController: UITableViewController {
    
    let tabBar = UITabBar()

    @IBOutlet weak var buttonSearch: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var resetButton: UIBarButtonItem!
    
    @IBOutlet weak var sliderDistance: UISlider!
    @IBOutlet weak var distanceLabel: UILabel!
    var distanceMile = Double()
    
    @IBOutlet weak var positionActuelleButton: UIButton!
    @IBOutlet weak var positionProfilButton: UIButton!
    let locationManager = CLLocationManager()
    var latDouble = Double()
    var longDouble = Double()
    
    @IBOutlet var switchDay: [UISwitch]!
    var jour = [String:Bool]()
    @IBOutlet var switchJourNuit: [UISwitch]!
    var momentDay = [String:Bool]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       initView()
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
    
    func getCoordinate( addressString : String,
                        completionHandler: @escaping(CLLocationCoordinate2D, NSError?) -> Void ) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressString) { [weak self] (placemarks, error) in
            guard let self = self else { return }
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
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        FilterSearch.shared.regionRadius = nil
        let currentValue = Int(sender.value)
        distanceLabel.text = "\(currentValue) Km"
       distanceMile = Double(currentValue) / 1.60934
        FilterSearch.shared.regionRadius = Double(currentValue) * 1000
    }
    
    func switchDayIsClicked(_ sender: UISwitch) {
        
            if sender.isOn {
                let result = returnForSwitch(sender)
                for (key,value) in result {
                FilterSearch.shared.dayFilter[key] = value
                }
            }
    }

    func switchMomentDayIsClicked(_ sender: UISwitch) {
        if sender.isOn {
            let result = returnForSwitch(sender)
            
            for (key,value) in result {
                FilterSearch.shared.momentDay[key] = value
            }
        }
    }

   
    
    func returnForSwitch(_ sender: UISwitch) -> [String:Bool] {
        switch sender.tag {
        case 0: return ["lundi":true]
        case 1: return ["mardi":true]
        case 2: return ["mercredi":true]
        case 3: return ["jeudi":true]
        case 4: return ["vendredi":true]
        case 5: return ["samedi":true]
        case 6: return ["dimanche":true]
        case 7: return ["day":true]
        case 8: return ["night":true]
        default : return ["":false]
        }
    }

    
    func createJourForKeep() {
        for switchButton in switchDay {
            switchDayIsClicked(switchButton)
        }
        for switchButton in switchJourNuit {
            switchMomentDayIsClicked(switchButton)
        }
    }


    @IBAction func searchButtonIsClicked(_ sender: UIBarButtonItem) {
        FilterSearch.shared.dayFilter = [String:Bool]()
        FilterSearch.shared.momentDay = [String:Bool]()
        FilterSearch.shared.greaterGeopoint = nil
        FilterSearch.shared.lesserGeopoint = nil
        prepareQueryLoc(latitude: Double(FilterSearch.shared.latChoice), longitude: Double(FilterSearch.shared.longChoice), distanceMile: distanceMile)
        createJourForKeep()
        //let jourSearch = jour.createString()
        //let momentDaySearch = momentDay.createString()
       // FilterSearch.shared.day = "semaine.lundi"
        //FilterSearch.shared.boolDay = true
        print(FilterSearch.shared.lesserGeopoint)
        print(FilterSearch.shared.greaterGeopoint)
        dismiss(animated: true, completion: nil)
        //print(jour.enumerated())
        print(FilterSearch.shared.momentDay.enumerated())
    }
    
    func initView() {
        if FilterSearch.shared.dayFilter.count != 0 && FilterSearch.shared.momentDay.count != 0 {
            DispatchQueue.main.async {
        for (key,value) in FilterSearch.shared.dayFilter {
            self.initSwitchDay(key: key, switchDay: self.switchDay[0], day: "lundi")
            self.initSwitchDay(key: key, switchDay: self.switchDay[1], day: "mardi")
            self.initSwitchDay(key: key, switchDay: self.switchDay[2], day: "mercredi")
            self.initSwitchDay(key: key, switchDay: self.switchDay[3], day: "jeudi")
            self.initSwitchDay(key: key, switchDay: self.switchDay[4], day: "vendredi")
            self.initSwitchDay(key: key, switchDay: self.switchDay[5], day: "samedi")
            self.initSwitchDay(key: key, switchDay: self.switchDay[6], day: "dimanche")
          /*  initOneSwitchDay(key: key, switchDay: switchDay[0])
            initOneSwitchDay(key: key, switchDay: switchDay[1])
            initOneSwitchDay(key: key, switchDay: switchDay[2])
            initOneSwitchDay(key: key, switchDay: switchDay[3])
            initOneSwitchDay(key: key, switchDay: switchDay[4])
            initOneSwitchDay(key: key, switchDay: switchDay[5])
            initOneSwitchDay(key: key, switchDay: switchDay[6])*/
           // initAllSwitchDay(key: key)
        }
        for (key,value) in FilterSearch.shared.momentDay {
            self.initSwitchMomentDay(key: key, switchMomentDay: self.switchJourNuit[0], momentDay: "day")
            self.initSwitchMomentDay(key: key, switchMomentDay: self.switchJourNuit[1], momentDay: "night")
        }
        }
        }
    }
    func initAllSwitchDay(key: String) {
        for i in 0..<switchDay.count {
            initOneSwitchDay(key: key, switchDay: switchDay[i])
        }
    }
    func initOneSwitchDay(key: String, switchDay: UISwitch) {
        let day = ["lundi","mardi","mercredi","jeudi","vendredi","samedi","dimanche"]
        for i in 0..<day.count {
            initSwitchDay(key: key, switchDay: switchDay, day: day[i])
        }
    }
    func initSwitchDay(key: String, switchDay: UISwitch, day: String) {
        if key == day {
            switchDay.setOn(true, animated: true)
        } else {
            switchDay.setOn(false, animated: true)
        }
    }
    
    func initSwitchMomentDay(key: String, switchMomentDay: UISwitch, momentDay: String) {
        if key == momentDay {
            switchMomentDay.isOn = true
        } else {
            switchMomentDay.isOn = false
        }
    }
    //let regionRadius: CLLocationDistance = 10000
    func checkLocationAuthorizationStatus() {
        FilterSearch.shared.latChoice = nil
        FilterSearch.shared.longChoice = nil
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
           // locationManager.distanceFilter = 100000
            guard let lat = locationManager.location?.coordinate.latitude else { return }
            guard let long = locationManager.location?.coordinate.longitude else { return }
            FilterSearch.shared.latChoice = lat
            FilterSearch.shared.longChoice = long
            longDouble = Double(long)
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }

    func prepareQueryLoc(latitude: Double, longitude: Double, distanceMile: Double) {
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
    // MARK: - Table view data source

   

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

class FilterSearch {
    
    static var shared = FilterSearch()
    
    private init () {}
    
    var dayFilter = [String:Bool]()
    var momentDay = [String:Bool]()
    var latChoice: CLLocationDegrees!
    var longChoice: CLLocationDegrees!
    var lesserGeopoint: GeoPoint!
    var greaterGeopoint: GeoPoint!
    var regionRadius: CLLocationDistance!
    var profilLocIsSelected = false
    
}


