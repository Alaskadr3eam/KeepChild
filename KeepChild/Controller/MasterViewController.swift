//
//  MasterViewController.swift
//  KeepChild
//
//  Created by Clément Martin on 28/09/2019.
//  Copyright © 2019 Clément Martin. All rights reserved.
//

import UIKit

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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        initSearchController()
        request()
        //request()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        requestWithFilter()
    }
    
    func request() {
        
            announceSearchTableViewController.searchTableView.setLoadingScreen()
        master.readData(collection: "Announce2") { [weak self] (error, announceList) in
            guard let self = self else { return }
            guard error == nil else { return }
            guard announceList != nil else { return }
            self.prepareViewForChildViewController(vc1: self.announceSearchTableViewController, vc2: self.mapKitAnnounceViewController)
        }
        
    }
    
    func requestWithFilter() {
        if FilterSearch.shared.day != nil || FilterSearch.shared.boolDay != nil {
            master.searchAnnounceFiltered(dayFilter: FilterSearch.shared.day, boolFilter: FilterSearch.shared.boolDay) { [weak self] (error, announceList) in
                guard let self = self else { return }
                guard error == nil else { return }
                guard announceList != nil else { return }
                self.prepareViewForChildViewController(vc1: self.announceSearchTableViewController, vc2: self.mapKitAnnounceViewController)
            }
        }
    }
    
   /* func requestWithFilter() {
        if FilterSearch.shared.day != nil || FilterSearch.shared.momentDay != nil {
            master.searchAnnounceFiltered(searchDay: FilterSearch.shared.day) { [weak self] (error, announceList) in
                guard let self = self else { return }
                guard error == nil else { return }
                guard announceList != nil else { return }
                self.prepareViewForChildViewController(vc1: self.announceSearchTableViewController, vc2: self.mapKitAnnounceViewController)
            }
        }
    }*/
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
        let announce = vc.mapKitAnnounce.announceListLocation
        vc.mapKitViewAnnounce.addAnnotations(announce)
    }

     // MARK: - Search Controller
    
    private func initSearchController() {
        
        //searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
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
        addChild(childController)
        
        view.addSubview(childController.view)
        
        childController.view.frame = view.bounds
        childController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        childController.didMove(toParent: self)
    }
    
    private func removeViewControllerAsChildViewController(childController: UIViewController) {
        childController.willMove(toParent: nil)
        
        childController.view.removeFromSuperview()
        
        childController.removeFromParent()
    }
   /* internal override func addChildViewController(_ childController: UIViewController) {
        addChild(childController)
        
        view.addSubview(childController.view)
        
        childController.view.frame = view.bounds
        childController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        childController.didMove(toParent: self)
    }*/

    
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
        print("cliçckeed")
        performSegue(withIdentifier: "filtered", sender: nil)
        //filterTableViewController.view.isHidden = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
   
}
