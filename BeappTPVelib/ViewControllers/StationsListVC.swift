//
//  StationsListVC.swift
//  BeappTPVelib
//
//  Created by Alexandre Guzu on 31/01/2018.
//  Copyright © 2018 Alexandre Guzu. All rights reserved.
//

import UIKit
import PromiseKit

class StationsListVC: UIViewController, UITableViewDataSource, UITableViewDelegate, StationsDataRetriever {
    
    @IBOutlet weak var stationsTableView: UITableView!
    @IBOutlet weak var statusSegmentedControl: UISegmentedControl!
    @IBOutlet weak var stationsSearchBar: UISearchBar!
    
    var stations: [StationViewModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stationsTableView.delegate = self
        stationsTableView.dataSource = self
        
        self.refreshData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /**
     Retrieves the stations data from the 'stations data provider' and refreshes the table view accordingly
     */
    func refreshData() {
        self.retrieveStationsList().then { stationsList -> Void in
            self.stations = stationsList
            self.stationsTableView.reloadData()
        }
        
    }
    
    // MARK: - UITableViewDelegate and UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "stationCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? StationTableViewCell  else {
            fatalError("The dequeued cell is not an instance of StationTableViewCell.")
        }
        
        let currentStation = stations[indexPath.row]
        
        cell.stationNameLabel.text = currentStation.name
        cell.availableBikesLabel.text = currentStation.availableBikes
        cell.statusLabel.text = currentStation.status
        cell.lastUpdatedLabel.text = currentStation.lastUpdate
        
        return cell
    }

}
