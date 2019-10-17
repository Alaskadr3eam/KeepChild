//
//  MasterViewController.swift
//  KeepChild
//
//  Created by Clément Martin on 28/09/2019.
//  Copyright © 2019 Clément Martin. All rights reserved.
//

import UIKit
import Firebase
import CodableFirebase

class MasterViewController: UIViewController {
    //MARK: - Properties
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    let searchController = UISearchController(searchResultsController: nil)
    //model for vc
    var announceList = AnnounceEdit()
    //properties vc
    lazy var announceSearchTableViewController: AnnounceSearchTableViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "AnnounceSearchTableViewController") as! AnnounceSearchTableViewController
        self.addViewControllerAsChildViewController(childController: viewController)
        return viewController
    }()
    
    lazy var mapKitAnnounceViewController: MapKitAnnounceViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "MapKitAnnounceViewController") as! MapKitAnnounceViewController
        self.addViewControllerAsChildViewController(childController: viewController)
        return viewController
    }()

    lazy var filterTableViewController: FilterTableViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "FilterTableViewController") as! FilterTableViewController
        self.addViewControllerAsChildViewController(childController: viewController)
        return viewController
    }()
    
    //let group = DispatchGroup()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "filtered"), style: .plain, target: self, action: #selector(filteredButtonIsClicked))
        setupView()
        initSearchController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        requestWithFilter()
    }
    
    @objc func filteredButtonIsClicked() {
        performSegue(withIdentifier: "filtered", sender: nil)
    }
    // MARK: - Request
    private func request() {
        //view for loading result
        announceSearchTableViewController.searchTableView.setLoadingScreen()
        announceList.readData { [weak self] (error, announceList) in
            guard let self = self else { return }
            guard error == nil else { return }
            guard announceList != nil else { return }
            self.prepareViewForChildViewController(vc1: self.announceSearchTableViewController, vc2: self.mapKitAnnounceViewController)
        }
        
    }

    private func requestWithFilter() {
        if FilterSearch.shared.lesserGeopoint != nil && FilterSearch.shared.greaterGeopoint != nil {
            let lesserGeopoint = FilterSearch.shared.lesserGeopoint
            let greaterGeopoint = FilterSearch.shared.greaterGeopoint
            //view for loading result
            announceSearchTableViewController.searchTableView.setLoadingScreen()
            self.announceList.searchAnnounceFiltered(lesserGeopoint: lesserGeopoint!, greaterGeopoint: greaterGeopoint!) { [weak self] (error, announceList) in
                guard let self = self else { return }
                guard error == nil else { return }
                guard announceList != nil else { return }
                self.announceList.filteredAnnounce()
                self.prepareViewForChildViewController(vc1: self.announceSearchTableViewController, vc2: self.mapKitAnnounceViewController)
                }
            }
    }
    //MARK: -Helpers for filters announce
  /*  private func filteredAnnounce() {
        //filter of the search
        let dayFilter = FilterSearch.shared.dayFilter
        let momentDay = FilterSearch.shared.momentDay
        //var for transition
        var announceWithFilterDay = [Announce]()
        var announceWithAllFilter = [Announce]()
        //boucle for day filter
        for announce in master.announceTransition {
            if announce.semaine.lundi == dayFilter["lundi"] {
                announceWithFilterDay.append(announce)
            }
            if announce.semaine.mardi == dayFilter["mardi"] {
                announceWithFilterDay.append(announce)
            }
            if announce.semaine.mercredi == dayFilter["mercredi"] {
                announceWithFilterDay.append(announce)
            }
            if announce.semaine.jeudi == dayFilter["jeudi"] {
                announceWithFilterDay.append(announce)
            }
            if announce.semaine.vendredi == dayFilter["vendredi"] {
                announceWithFilterDay.append(announce)
            }
            if announce.semaine.samedi == dayFilter["samedi"] {
                announceWithFilterDay.append(announce)
            }
            if announce.semaine.dimanche == dayFilter["dimanche"] {
                announceWithFilterDay.append(announce)
            }
        }
        //boucle for momentDay filter
        for announce in announceWithFilterDay {
            if announce.day == momentDay["day"] {
                announceWithAllFilter.append(announce)
            }
            if announce.night == momentDay["night"] {
                announceWithAllFilter.append(announce)
            }
        }
        master.announceList = announceWithAllFilter.removeDuplicates()
    }*/

     // MARK: - prepare ViewController
    private func prepareViewForChildViewController(vc1: AnnounceSearchTableViewController, vc2: MapKitAnnounceViewController) {
        prepareSearchTableView(vc: vc1)
        prepareMapKit(vc: vc2)
    }
    
    private func prepareSearchTableView(vc: AnnounceSearchTableViewController) {
        vc.announceList.announceList = announceList.announceList
        vc.searchTableView.reloadData()
        //remove view loading
        vc.searchTableView.removeLoadingScreen()
    }
    private func prepareMapKit(vc: MapKitAnnounceViewController) {
        vc.mapKitAnnounce.announceList = self.announceList.announceList
        vc.mapKitAnnounce.toFillTheLocationAnnounceArray()
    }

     // MARK: - Search Controller
    private func initSearchController() {
        searchController.searchBar.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Announce"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.tintColor = UIColor.black
        searchController.searchBar.barTintColor = UIColor.black
    }

    private func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    private func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        announceList.announceSearch = announceList.announceList.filter({( announce : Announce) -> Bool in
         let name = announce.title/* else {
         return false
         }*/
         return name.lowercased().contains(searchText.lowercased())
         })
         announceSearchTableViewController.tableView.reloadData()
    }
    
    private func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
     // MARK: - View
    
    private func setupView() {
        setupSegmentedControl()
        updateView()
    }
    
    private func updateView() {
        announceSearchTableViewController.view.isHidden = !(segmentedControl.selectedSegmentIndex == 0)
        mapKitAnnounceViewController.view.isHidden = !(segmentedControl.selectedSegmentIndex == 1)
        //active viewWillAppear in launch vc for animation mapkit
        mapKitAnnounceViewController.viewWillAppear(true)
    }

    private func setupSegmentedControl() {
        segmentedControl.removeAllSegments()
        segmentedControl.insertSegment(withTitle: "Liste", at: 0, animated: false)
        segmentedControl.insertSegment(withTitle: "Map", at: 1, animated: false)
        segmentedControl.addTarget(self, action: #selector(selectionDidChange(sender:)), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 0
    }
    
    @objc func selectionDidChange(sender: UISegmentedControl) {
        updateView()
    }
    
    private func addViewControllerAsChildViewController(childController: UIViewController) {
        view.addSubview(childController.view)
        childController.view.frame = view.bounds
        childController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    private func removeViewControllerAsChildViewController(childController: UIViewController) {
        childController.willMove(toParent: nil)
        childController.view.removeFromSuperview()
        childController.removeFromParent()
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "filtered" {
            if segue.destination is FilterTableViewController {
            }
        }
    }
    

}

extension MasterViewController: UISearchBarDelegate {
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        performSegue(withIdentifier: "filtered", sender: nil)
        //filterTableViewController.view.isHidden = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
