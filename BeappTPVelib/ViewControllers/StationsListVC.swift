//
//  StationsListVC.swift
//  BeappTPVelib
//
//  Created by Alexandre Guzu on 31/01/2018.
//  Copyright © 2018 Alexandre Guzu. All rights reserved.
//

import UIKit
import Alamofire

class StationsListVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var stationsTableView: UITableView!
    @IBOutlet weak var statusSegmentedControl: UISegmentedControl!
    @IBOutlet weak var stationsSearchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Alamofire.request("https://api.jcdecaux.com/vls/v1/stations?contract=NANTES&apiKey=b085c5d6c47ab915bbc5b37033ea026051998176").responseJSON { response in
            switch response.result {
            case .success:
                if let json = response.result.value as? [[String:Any]] {
                    for dictStation in json {
                        if let station = Station(json: dictStation) {
                            print(station.name)
                        }
                    }
                }
            case .failure(let error):
                print(error)
            }
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
