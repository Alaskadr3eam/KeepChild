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
    //MARK: - Outlet
    @IBOutlet weak var searchTableView: CustomTableView!

    let searchController = UISearchController(searchResultsController: nil)
    //MARK: - Properties
    var announceList = AnnounceEdit()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchTableView.restore()
    }
    //MARK: - Init View
    func setUpView() {
        if announceList.announceList == nil {
            searchTableView.setEmptyMessage("Aucune annonce pour le moment. Pour effectuer une recherche cliquez sur ", messageEnd: " en haut à droite de l'écran", imageName: "filtered" )
        } else if announceList.announceList.count == 0 {
            searchTableView.setEmptyMessage("Pas de résultat !", messageEnd: "Changez vos filtres.", imageName: "smileyPleure")
        } else {
            searchTableView.restore()
        }
    }

    func setUpViewPostRequest() {
        if announceList.announceList.count == 0 {
            searchTableView.setEmptyMessage("Pas de résultat !", messageEnd: "Changez vos filtres.", imageName: "smileyContent")
        } else {
            searchTableView.restore()
        }
    }

    // MARK: - Search Controller
    private func initSearchController() {
       
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Announce"
        navigationController?.navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.tintColor = UIColor.black
        searchController.searchBar.barTintColor = UIColor.black
        //createButtonForFiltered()
    }

   /* private func createButtonForFiltered() {
        searchController.searchBar.showsBookmarkButton = true
        searchController.searchBar.setImage(UIImage(named: "filtered"), for: .bookmark, state: .normal)
        // MARK: You may change position of bookmark button.
        //searchController.searchBar.setPositionAdjustment(UIOffset(horizontal: 0, vertical: 0), for: .bookmark)
        
    }*/
    
    private func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        announceList.announceSearch = announceList.announceList.filter({( announce : Announce) -> Bool in
            let name = announce.title/* else {
             return false
             }*/
            return name.lowercased().contains(searchText.lowercased())
        })
        self.tableView.reloadData()
    }
    
    private func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
   /* func request() {
        searchTableView.setLoadingScreen()
        announceList.readData(collection: "Announce2") { [weak self] (error, announceList) in
            guard let self = self else { return }
            guard error == nil else { return }
            guard announceList != nil else { return }
            self.searchTableView.reloadData()
            self.searchTableView.removeLoadingScreen()
        }
        
    }*/

    @objc func mapAccess() {
        announceList.announceList = announceList.announceList
        performSegue(withIdentifier: Constants.Segue.segueMapKit, sender: nil)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if announceList.announceList == nil {
            return 0
        } else {
            return announceList.announceList.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomCell
        let announce = announceList.announceList[indexPath.row]
        cell.titleLabel.text = announce.title
        cell.semaineDayLabel.text = "\(announceList.transformateSemaineInString(semaine: announce.semaine))"
        cell.momentDayLabel.text = "\(announceList.transformeMomentDayInString(announce: announce))"
        cell.imageProfil.downloadCustom(idUserImage: announce.idUser, contentMode: .scaleToFill)
       
        return cell
    }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = Constants.Color.bleu
        return footerView
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        announceList.announce = announceList.announceList[indexPath.row]
        performSegue(withIdentifier: Constants.Segue.segueDetailAnnounce, sender: nil)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segue.segueDetailAnnounce {
            let navVC = segue.destination as! UINavigationController
            let detailAnnounceVC = navVC.viewControllers.first as! DetailAnnounceTableViewController
            detailAnnounceVC.detailAnnounce.announce = announceList.announce
        }
        if segue.identifier == Constants.Segue.segueMapKit {
            if let vcDestination = segue.destination as? MapKitAnnounceViewController {
                vcDestination.mapKitAnnounce.announceList = announceList.announceList
                vcDestination.mapKitAnnounce.filter = announceList.filter
            }
        }
    }
    

}

extension AnnounceSearchTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        filterContentForSearchText(text)
    }
}

extension AnnounceSearchTableViewController: UISearchBarDelegate {
}
