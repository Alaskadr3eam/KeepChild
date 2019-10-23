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
    //MARK: - Properties
    var announceList = AnnounceGestion(firebaseServiceSession: FirebaseService(dataManager: ManagerFirebase()))
    
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
    private func setUpView() {
        if announceList.announceList == nil {
            searchTableView.setEmptyMessage("Aucune annonce pour le moment. Pour effectuer une recherche cliquez sur ", messageEnd: " en haut à droite de l'écran", imageName: "filtered" )
        } else if announceList.announceList.count == 0 {
            searchTableView.setEmptyMessage("Pas de résultat !", messageEnd: "Changez vos filtres.", imageName: "smileyPleure")
        } else {
            searchTableView.restore()
        }
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

