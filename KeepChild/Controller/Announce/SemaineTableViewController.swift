//
//  SemaineTableViewController.swift
//  KeepChild
//
//  Created by Clément Martin on 26/09/2019.
//  Copyright © 2019 Clément Martin. All rights reserved.
//

import UIKit

enum semaineDataSource {
    case lundi,mardi,mercredi,jeudi,vendredi,samedi,dimanche
    
    var labelEnum: String {
        switch self {
        case .lundi:
            return "Lundi"
        case .mardi:
            return "Mardi"
        case.mercredi:
            return "Mercredi"
        case .jeudi:
            return "Jeudi"
        case .vendredi:
            return "vendredi"
        case .samedi:
            return "Samedi"
        case .dimanche:
            return "Dimanche"
        }
    }

    var isSelected: Bool {
       return true
    }
    
    var noSelected: Bool {
        return false
    }
    
    
}

struct Jour {
    var title: String
    
  
}

class JourItem {
    private var item: Jour
    var isSelected = false
    var title: String {
        return item.title
    }

    init(item: Jour) {
        self.item = item
    }
}

class ViewJour {
    var items = [JourItem]()
   
    init() {
        items = dataSource.map { JourItem(item: $0) }
    }
    
    var selectedItems: [JourItem] {
        return items.filter { return $0.isSelected }
    }
    
    var itemBool = [Bool]()
    let dataSource = [
        Jour(title: "Lundi"),
        Jour(title: "Mardi"),
        Jour(title: "Mercredi"),
        Jour(title: "Jeudi"),
        Jour(title: "Vendredi"),
        Jour(title: "Samedi"),
        Jour(title: "Dimanche")
    ]
   
}

    


class SemaineTableViewController: UITableViewController {
    
    var viewJour = ViewJour()
   // var dataSource = ["Lundi", "Mardi", "Mercredi", "Jeudi", "Vendredi", "Samedi", "Dimanche"]
    var semaine: Semaine!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsMultipleSelection = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveAnnounce))
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    @objc func saveAnnounce() {
        print(viewJour.selectedItems.map { $0.title })
        print(viewJour.itemBool.enumerated())
     
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return viewJour.items.count
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SemaineCell", for: indexPath) as? SemaineCell {
            cell.item = viewJour.items[indexPath.row] // (2)
            // select/deselect the cell
            if viewJour.items[indexPath.row].isSelected {
                tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none) // (3)
            } else {
                tableView.deselectRow(at: indexPath, animated: false) // (4)
            }
            return cell
        }
        return UITableViewCell()
    }

    
    
    
    /*override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedIndexes = tableView.indexPathsForSelectedRows {
            
        }
    }*/
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewJour.items[indexPath.row].isSelected = true
        viewJour.itemBool.append(true)
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        viewJour.items[indexPath.row].isSelected = false
        viewJour.itemBool.append(false)
    }
    
    func conversion() {
        
    }
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


class SemaineCell: UITableViewCell {
    
    var item: JourItem? {
        didSet {
            textLabel?.text = item?.title
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // update UI
        accessoryType = selected ? .checkmark : .none
    }
}
