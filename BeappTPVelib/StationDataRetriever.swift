//
//  StationDataRetriever.swift
//  BeappTPVelib
//
//  Created by Alexandre Guzu on 01/02/2018.
//  Copyright © 2018 Alexandre Guzu. All rights reserved.
//

import Foundation
import PromiseKit
import Alamofire
import os.log

protocol StationsDataRetriever {
    func retrieveStationsList() -> Promise<[StationViewModel]>
}

extension StationsDataRetriever {
    
    /// Retrieves the stations list either from internet (if possible), otherwise from memory
    /// - returns: a Promise of StationViewModel(s)
    func retrieveStationsList() -> Promise<[StationViewModel]> {
        return Promise { fullfill, reject in
            Alamofire.request("https://api.jcdecaux.com/vls/v1/stations?contract=NANTES&apiKey=b085c5d6c47ab915bbc5b37033ea026051998176").responseJSON { response in
                switch response.result {
                case .success:
                    if let json = response.result.value as? [[String:Any]] {
                        var stations: [StationViewModel] = []
                        
                        for dictStation in json {
                            if let station = StationViewModel(json: dictStation) {
                                stations += [station]
                            }
                        }
                        
                        // saving the retrieved stations into memory for future offline use
                        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(stations, toFile: StationViewModel.ArchiveURL.path)
                        if isSuccessfulSave {
                            os_log("Stations successfully saved.", log: OSLog.default, type: .debug)
                        } else {
                            os_log("Failed to save stations...", log: OSLog.default, type: .error)
                        }
                        
                        // fullfilling the Promise with the new data
                        fullfill(stations)
                    }
                case .failure(let error):
                    if let stations = NSKeyedUnarchiver.unarchiveObject(withFile: StationViewModel.ArchiveURL.path) as? [StationViewModel] {
                        fullfill(stations)
                    }
                    else {
                        reject(error)
                    }
                    
                }
            }
        }
    }
    
}
