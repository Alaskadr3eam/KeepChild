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
    //model for vc
    var announceList = AnnounceManager(firebaseServiceSession: FirebaseService(dataManager: ManagerFirebase()))
    //properties vc
    lazy var announceSearchTableViewController: AnnounceSearchTableViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: Constants.VCIdentifier.announceSearchTableViewController) as! AnnounceSearchTableViewController
        self.addViewControllerAsChildViewController(childController: viewController)
        return viewController
    }()
    
    lazy var mapKitAnnounceViewController: MapKitAnnounceViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: Constants.VCIdentifier.mapKitAnnounceViewController) as! MapKitAnnounceViewController
        self.addViewControllerAsChildViewController(childController: viewController)
        return viewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let buttonFilter = UIButton(type: .custom)
        buttonFilter.frame = CGRect(x: 0.0, y: 0.0, width: 10, height: 10)
        buttonFilter.setImage(UIImage(named: "filtered"), for: .normal)
        buttonFilter.addTarget(self, action: #selector(filteredButtonIsClicked), for: .touchUpInside)
        let menuBarItem = UIBarButtonItem(customView: buttonFilter)
        self.navigationItem.rightBarButtonItem = menuBarItem
        self.navigationItem.rightBarButtonItem?.tintColor = Constants.Color.titleNavBar
        
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestWithFilter()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    //MARK: - Action
    @objc func filteredButtonIsClicked() {
        performSegue(withIdentifier: Constants.Segue.segueFiltered, sender: nil)
    }
    
    @objc func selectionDidChange(sender: UISegmentedControl) {
        updateView()
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
        guard let filterSecure = announceList.filter else { return }
        if announceList.filter != nil {
            guard let lesserGeopoint = filterSecure.lesserGeopoint else { return }
            guard let greaterGeopoint = filterSecure.greaterGeopoint else { return }
            //view for loading result
            announceSearchTableViewController.searchTableView.setLoadingScreen()
            self.announceList.searchAnnounceFiltered(lesserGeopoint: lesserGeopoint, greaterGeopoint: greaterGeopoint) { [weak self] (error, announceList) in
                guard let self = self else { return }
                guard error == nil else {
                    self.announceSearchTableViewController.searchTableView.setEmptyMessage("Une erreur s'est produite, ", messageEnd: " vérifiez votre connexion internet. Si le problème persiste contactez le développeur", imageName: "smileyPleure")
                    return
                }
                guard announceList?.count != 0 else {
                    self.prepareViewForChildViewController(vc1: self.announceSearchTableViewController, vc2: self.mapKitAnnounceViewController)
                    return
                }
                self.prepareViewForChildViewController(vc1: self.announceSearchTableViewController, vc2: self.mapKitAnnounceViewController)
            }
        }
    }
    // MARK: - prepare ViewController
    private func prepareViewForChildViewController(vc1: AnnounceSearchTableViewController, vc2: MapKitAnnounceViewController) {
        prepareSearchTableView(vc: vc1)
        prepareMapKit(vc: vc2)
    }
    
    private func prepareSearchTableView(vc: AnnounceSearchTableViewController) {
        vc.announceList.announceList = announceList.announceList
        //remove view loading
        vc.searchTableView.removeLoadingScreen()
        vc.viewWillAppear(true)
        vc.searchTableView.reloadData()
    }
    
    private func prepareMapKit(vc: MapKitAnnounceViewController) {
        guard let annouceListSecure = announceList.announceList else { return }
        vc.mapKitAnnounce.announceList = annouceListSecure
        vc.mapKitAnnounce.filter = self.announceList.filter
        vc.mapKitAnnounce.toFillTheLocationAnnounceArray()
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
        segmentedControl.tintColor = Constants.Color.titleNavBar
        segmentedControl.insertSegment(withTitle: "Liste", at: 0, animated: false)
        segmentedControl.insertSegment(withTitle: "Carte", at: 1, animated: false)
        segmentedControl.addTarget(self, action: #selector(selectionDidChange(sender:)), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 0
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
        if segue.identifier == Constants.Segue.segueFiltered {
            let navVC = segue.destination as! UINavigationController
            let filterVC = navVC.viewControllers.first as! FilterTableViewController
            filterVC.delegate = self
            filterVC.filter.filter = announceList.filter
        }
    }
}

extension MasterViewController: isAbleToReceiveFilter {
    func pass(filter: Filter) {
        announceList.filter = filter
        announceSearchTableViewController.announceList.filter = filter
        mapKitAnnounceViewController.mapKitAnnounce.filter = filter
    }
}
