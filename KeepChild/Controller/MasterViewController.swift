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
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    let searchController = UISearchController(searchResultsController: nil)
    
    var announceList = AnnounceList()
    var master = Master()

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
    
    let group = DispatchGroup()
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
        
            announceSearchTableViewController.searchTableView.setLoadingScreen()
        master.readData(collection: "Announce2") { [weak self] (error, announceList) in
            guard let self = self else { return }
            guard error == nil else { return }
            guard announceList != nil else { return }
            self.prepareViewForChildViewController(vc1: self.announceSearchTableViewController, vc2: self.mapKitAnnounceViewController)
        }
        
    }

    private func requestWithFilter() {
        //let myGroup = DispatchGroup()
        if FilterSearch.shared.lesserGeopoint != nil && FilterSearch.shared.greaterGeopoint != nil {
        let lesserGeopoint = FilterSearch.shared.lesserGeopoint
        let greaterGeopoint = FilterSearch.shared.greaterGeopoint
       /* for (day,bool) in dayFilter {
            myGroup.enter()*/
            self.master.searchAnnounceFiltered(lesserGeopoint: lesserGeopoint!, greaterGeopoint: greaterGeopoint!) { [weak self] (error, announceList) in
                guard let self = self else { return }
                guard error == nil else { return }
                guard announceList != nil else { return }
                //print("Finished request\(day)")
                //myGroup.leave()
                self.filteredAnnounce()
                self.prepareViewForChildViewController(vc1: self.announceSearchTableViewController, vc2: self.mapKitAnnounceViewController)
                }
              //  myGroup.leave()
                //self.prepareViewForChildViewController(vc1: self.announceSearchTableViewController, vc2: self.mapKitAnnounceViewController)
            
            }
        
       /* myGroup.notify(queue: .main) {
            print("Finished all request")
            self.filteredAnnounce()
            //self.master.announceList = self.master.announceTransition.removeDuplicates()
            print(self.master.announceTransition.count)
            print(self.master.announceList.count)
            self.prepareViewForChildViewController(vc1: self.announceSearchTableViewController, vc2: self.mapKitAnnounceViewController)
        
        }*/
    }
    
    private func filteredAnnounce() {
        let dayFilter = FilterSearch.shared.dayFilter
        let momentDay = FilterSearch.shared.momentDay
        var announceWithFilterDay = [Announce]()
        var announceWithAllFilter = [Announce]()
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
        for announce in announceWithFilterDay {
            if announce.day == momentDay["day"] {
                announceWithAllFilter.append(announce)
            }
            if announce.night == momentDay["night"] {
                announceWithAllFilter.append(announce)
            }
        }
        master.announceList = announceWithAllFilter.removeDuplicates()
    }

     // MARK: - prepare ViewController
    private func prepareViewForChildViewController(vc1: AnnounceSearchTableViewController, vc2: MapKitAnnounceViewController) {
        prepareSearchTableView(vc: vc1)
        prepareMapKit(vc: vc2)
    }
    
    private func prepareSearchTableView(vc: AnnounceSearchTableViewController) {
        vc.announceList.announceList = master.announceList
        vc.searchTableView.reloadData()
        vc.searchTableView.removeLoadingScreen()
    }
    private func prepareMapKit(vc: MapKitAnnounceViewController) {
        vc.mapKitAnnounce.announceList = self.master.announceList
        vc.mapKitAnnounce.toFillTheLocationAnnounceArray()
        //let announce = vc.mapKitAnnounce.announceListLocation
        //vc.mapKitViewAnnounce.addAnnotations(announce)
    }

     // MARK: - Search Controller
    
    private func initSearchController() {
        searchController.searchBar.delegate = self
        searchController.dimsBackgroundDuringPresentation = true
        searchController.searchBar.placeholder = "Search Announce"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.tintColor = UIColor.black
        searchController.searchBar.barTintColor = UIColor.black
      //  createButtonForFiltered()
    }

    private func createButtonForFiltered() {
        searchController.searchBar.showsBookmarkButton = true
        searchController.searchBar.setImage(UIImage(named: "filtered"), for: .bookmark, state: .normal)
        // MARK: You may change position of bookmark button.
        //searchController.searchBar.setPositionAdjustment(UIOffset(horizontal: 0, vertical: 0), for: .bookmark)
    }
    
    @objc func buttonFilteredIsClicked() {
        
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
    }
    
     // MARK: - View
    
    private func setupView() {
        setupSegmentedControl()
        updateView()
    }
    
    private func updateView() {
        announceSearchTableViewController.view.isHidden = !(segmentedControl.selectedSegmentIndex == 0)
        //announceSearchTableViewController.announceList.announceList = master.announceList
        mapKitAnnounceViewController.view.isHidden = !(segmentedControl.selectedSegmentIndex == 1)
        mapKitAnnounceViewController.viewWillAppear(true)
        //mapKitAnnounceViewController.mapKitAnnounce.announceList = master.announceList
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
        //addChild(childController)
        view.addSubview(childController.view)
        childController.view.frame = view.bounds
        childController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        //childController.didMove(toParent: self)
    }
    
    private func removeViewControllerAsChildViewController(childController: UIViewController) {
        childController.willMove(toParent: nil)
        childController.view.removeFromSuperview()
        childController.removeFromParent()
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "filtered" {
            if segue.destination is FilterTableViewController {
                //vcDestination.detailAnnounce.announce = announceList.announceDetail
            }
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
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
