//
//  Semaine2TableViewController.swift
//  KeepChild
//
//  Created by Clément Martin on 26/09/2019.
//  Copyright © 2019 Clément Martin. All rights reserved.
//

import UIKit

class SemaineTableViewController: UITableViewController {

    @IBOutlet var switchDay: [UISwitch]!
    var navigationBar: UINavigationBar!
    
    var jour = [String]()
    var announceEdit = AnnounceEdit()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    func switchTelIsClicked(_ sender: UISwitch) -> Bool {
        
        if sender.isOn {
            //jour.append(returnDayForSwitch(sender))
            return true
        } else {
            return false
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
        default : return ""
        }
    }

    func createJourForKeep() {
        for switchButton in switchDay {
            switchTelIsClicked(switchButton)
        }
    }

    func createSemaine() -> Semaine {
        let semaine = Semaine(idUser: nil, lundi: switchTelIsClicked(switchDay[0]), mardi: switchTelIsClicked(switchDay[1]), mercredi: switchTelIsClicked(switchDay[2]), jeudi: switchTelIsClicked(switchDay[3]), vendredi: switchTelIsClicked(switchDay[4]), samedi: switchTelIsClicked(switchDay[5]), dimanche: switchTelIsClicked(switchDay[6]))
        return semaine
    }
    @IBAction func saveSemaineSelection(_ sender: UIBarButtonItem) {
    announceEdit.encodeObjectInData(semaine: createSemaine())
    //UserDefaults.standard.set(jour, forKey: "jour")
    dismiss(animated: true, completion: nil)
    self.navigationController?.popViewController(animated: true)
    }
 

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
