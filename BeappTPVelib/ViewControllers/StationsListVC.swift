//
//  StationsListVC.swift
//  BeappTPVelib
//
//  Created by Alexandre Guzu on 31/01/2018.
//  Copyright © 2018 Alexandre Guzu. All rights reserved.
//

import UIKit
import PromiseKit

class StationsListVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, StationsDataRetriever {
    
    @IBOutlet weak var stationsTableView: UITableView!
    @IBOutlet weak var statusSegmentedControl: UISegmentedControl!
    @IBOutlet weak var stationsSearchBar: UISearchBar!
    
    private let refreshControl = UIRefreshControl()
    
    // represents the filtered list of stations (by text and/or by status) that is actually displayed
    var filteredStations: [StationViewModel] = [] {
        didSet {
            self.stationsTableView.reloadData()
        }
    }
    
    // represents the complete list of stations. We keep it 'untouched' since we use it for filtering
    var stations: [StationViewModel] = [] {
        didSet {
            filteredStations = stations
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setting up the segmentedControl
        statusSegmentedControl.addTarget(self, action: #selector(segmentedControlChanged(_:)), for: .valueChanged)
        
        // setting up the refreshControl
        stationsTableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshDataTarget(_:)), for: .valueChanged)
        
        // setting up the table view delegate and datasource
        stationsTableView.delegate = self
        stationsTableView.dataSource = self
        
        // setting up the SearchBar delegate
        stationsSearchBar.delegate = self
        
        // setting up the tap gesture recognizer for dismissing the keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        // refreshing the data when the view loads
        self.refreshData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /// dismisses the keyboard when the user taps around it
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    /// Calls the refreshData() function from the refreshControl when its value changes
    @objc private func segmentedControlChanged(_ sender: Any) {
        filterData(by: stationsSearchBar.text)
    }
    
    /// Calls the refreshData() function from the refreshControl when its value changes
    @objc private func refreshDataTarget(_ sender: Any) {
        self.refreshControl.beginRefreshing()
        refreshData()
    }
    
    /// Retrieves the stations data from the 'stations data provider' and refreshes the table view accordingly
    func refreshData() {
        self.retrieveStationsList().then { stationsList -> Void in
            self.stations = stationsList
            
            self.refreshControl.endRefreshing()
        }
    }
    
    /// Filters data by text with the search bar, by status with the segmented control, or both
    func filterData(by text: String?) {
        if let _text = text {
            if _text != "" {
                filteredStations = stations.filter { $0.name.lowercased().contains(_text.lowercased().trimmingCharacters(in: .whitespaces)) }
            }
            else { filteredStations = stations }
        }
        
        switch statusSegmentedControl.selectedSegmentIndex {
        case 1:
            filteredStations = filteredStations.filter { $0.status.lowercased() == StationViewModel.Statuses.open.rawValue.lowercased() }
        case 2:
            filteredStations = filteredStations.filter { $0.status.lowercased() == StationViewModel.Statuses.closed.rawValue.lowercased() }
        default:
            break
        }
    }
    
    // MARK: - UISearchBarDelegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterData(by: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.resignFirstResponder()
        return true
    }
    
    // MARK: - UITableViewDelegate and UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredStations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "stationCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? StationTableViewCell  else {
            fatalError("The dequeued cell is not an instance of StationTableViewCell.")
        }
        
        let currentStation = filteredStations[indexPath.row]
        
        cell.stationNameLabel.text = currentStation.name
        cell.availableBikesLabel.text = currentStation.availableBikes
        cell.statusLabel.text = currentStation.status
        cell.lastUpdatedLabel.text = "depuis le \(currentStation.lastUpdate)"
        
        cell.statusLabel.textColor = currentStation.status.lowercased() == StationViewModel.Statuses.open.rawValue ? .green : .red
        
        return cell
    }

}
