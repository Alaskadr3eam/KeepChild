//
//  AnnounceSearchTableViewController.swift
//  KeepChild
//
//  Created by Clément Martin on 13/09/2019.
//  Copyright © 2019 Clément Martin. All rights reserved.
//

import UIKit
import Firebase


class AnnounceSearchTableViewController: UITableViewController {

    @IBOutlet weak var searchTableView: CustomTableView!

    //let searchController = UISearchController(searchResultsController: nil)
    
    //@IBOutlet weak var controlSegmented: UISegmentedControl!

   /* @IBAction func actionSegmentedControl(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:break
        case 1:break
        default:break
        }
    }*/
    var announceList = AnnounceList()
   // var manageFireBase = ManageFireBase()
    override func viewDidLoad() {
        super.viewDidLoad()
        //initSearchController()
       // self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "map"), style: .plain, target: self, action: #selector(mapAccess))
        //announceList.delegateAnnounceList = self
       // manageFireBase.queryAnnounceAll = manageFireBase.createQueryAll(collection: "Announce2")
       // announceList.observeQuery()
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchTableView.reloadData()
         //manageFireBase.readDataAnnounce()
        //announceList.readData()
        //request()
    }
    // MARK: - Search Controller
   /* private func initSearchController() {
       
        //searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = true
        searchController.searchBar.placeholder = "Search Announce"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.tintColor = UIColor.black
        searchController.searchBar.barTintColor = UIColor.black
        //searchController.searchBar.text
        //searchController.searchBar.showsBookmarkButton = true
        //searchController.searchBar.setImage(UIImage(named: "filtered"), for: .bookmark, state: .normal)
        createButtonForFiltered()
    }

    private func createButtonForFiltered() {
        searchController.searchBar.showsBookmarkButton = true
        searchController.searchBar.setImage(UIImage(named: "filtered"), for: .bookmark, state: .normal)
        // MARK: You may change position of bookmark button.
        //searchController.searchBar.setPositionAdjustment(UIOffset(horizontal: 0, vertical: 0), for: .bookmark)
        
    }
    
    private func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        /*recipeFavorite.recipeSearch = recipeFavorite.recipeArray.filter({( announce : Announce) -> Bool in
            guard let name = recipe.label else {
                return false
            }
            return name.lowercased().contains(searchText.lowercased())
        })
        
        tableView.reloadData()*/
    }
    
    private func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }*/
    
    func request() {
        searchTableView.setLoadingScreen()
        announceList.readData(collection: "Announce2") { [weak self] (error, announceList) in
            guard let self = self else { return }
            guard error == nil else { return }
            guard announceList != nil else { return }
            self.searchTableView.reloadData()
            self.searchTableView.removeLoadingScreen()
        }
        
    }

    @objc func mapAccess() {
        announceList.announceList = announceList.announceList
        performSegue(withIdentifier: "mapKitView", sender: nil)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return announceList.announceList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomCell
        let announce = announceList.announceList[indexPath.row]
        cell.titleLabel.text = announce.title
        cell.priceLabel.text = announce.price
        cell.imageProfil.downloadCustom(idUserImage: announce.idUser, contentMode: .scaleToFill)
       
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomCell
        announceList.announceDetail = announceList.announceList[indexPath.row]
        encodedProfilUser(announce: announceList.announceDetail)
        performSegue(withIdentifier: "DetailAnnounce", sender: nil)
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
    func encodedProfilUser(announce: Announce) {
        if let encodedProfil = try? JSONEncoder().encode(announce) {
            UserDefaults.standard.set(encodedProfil, forKey: "announce")
        }
    }
    //func for decode object in userDefault
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailAnnounce" {
            if let vcDestination = segue.destination as? DetailAnnounceTableViewController {
                
            }
        }
        if segue.identifier == "mapKitView" {
            if let vcDestination = segue.destination as? MapKitAnnounceViewController {
                vcDestination.mapKitAnnounce.announceList = announceList.announceList
            }
        }
    }
    

}
/*extension AnnounceSearchTableViewController: AnnounceListDelegate {
    func updateTableView() {
        tableView.reloadData()
    }
}*/

/*extension AnnounceSearchTableViewController: ManageFireBaseDelegateAnnounceSearch {
    func resultForRequestAnnounceSearch() {
        tableView.reloadData()
    }
}*/

extension AnnounceSearchTableViewController: UISearchBarDelegate {
}
