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

protocol StationsDataRetriever {
    func retrieveStationsList() -> Promise<[StationViewModel]>
}

extension StationsDataRetriever {
    
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
                        
                        fullfill(stations)
                    }
                case .failure(let error):
                    // TODO : retrieve in-memory data in case the network request fails
                    
                    
                    reject(error)
                }
            }
        }
    }
    
}
