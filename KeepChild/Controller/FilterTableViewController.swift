//
//  FilterTableViewController.swift
//  KeepChild
//
//  Created by Clément Martin on 30/09/2019.
//  Copyright © 2019 Clément Martin. All rights reserved.
//

import UIKit

class FilterTableViewController: UITableViewController {
    
    let tabBar = UITabBar()

    @IBOutlet weak var buttonSearch: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var resetButton: UIBarButtonItem!
    
    @IBOutlet var switchDay: [UISwitch]!
    var jour = [String]()
    
    @IBOutlet var switchJourNuit: [UISwitch]!
    var momentDay = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    func switchDayIsClicked(_ sender: UISwitch) {
        
            if sender.isOn {
                jour.append(returnDayForSwitch(sender))
            }/* else {
                jour.append("")
        }*/

    }

    func switchMomentDayIsClicked(_ sender: UISwitch) {
        if sender.isOn {
            momentDay.append(returnDayForSwitch(sender))
        }
    }

   
    
    func returnDayForSwitch(_ sender: UISwitch) -> String {
        switch sender.tag {
        case 0: return "Lundi"
        case 1: return "Mardi"
        case 2: return "Mercredi"
        case 3: return "Jeudi"
        case 4: return "Vendredi"
        case 5: return "Samedi"
        case 6: return "Dimanche"
        case 7: return "Jour"
        case 8: return "Nuit"
        default : return ""
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
        FilterSearch.shared.day = nil
        FilterSearch.shared.boolDay = nil
        //createJourForKeep()
        //let jourSearch = jour.createString()
        //let momentDaySearch = momentDay.createString()
        FilterSearch.shared.day = "semaine.lundi"
        FilterSearch.shared.boolDay = true
        dismiss(animated: true, completion: nil)
        //print(jour.enumerated())
        //print(momentDay.enumerated())
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
    
    var day: String!
    var boolDay: Bool!
}
