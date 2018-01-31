//
//  Station.swift
//  BeappTPVelib
//
//  Created by Alexandre Guzu on 31/01/2018.
//  Copyright © 2018 Alexandre Guzu. All rights reserved.
//

import Foundation

struct Station {
    let name: String
    let status: Statuses
    let availableBikes: Int
    let bikeStands: Int
    
    enum Statuses: String {
        case open, closed
    }
}

extension Station {
    
    /**
    Initializer optionnel pour une station
    - parameter json: le dictionnaire de données JSON
    - returns: nil si erreur de type à l'initialisation, sinon une Station
    */
    init?(json: [String:Any]) {
        guard let name = json["name"] as? String,
            let statusString = json["status"] as? String,
            let availableBikes = json["available_bikes"] as? Int,
            let bikeStands = json["bike_stands"] as? Int else {
                return nil
        }
        
        guard let status = Statuses(rawValue: statusString.lowercased()) else {
            return nil
        }
        
        self.name = name
        self.status = status
        self.availableBikes = availableBikes
        self.bikeStands = bikeStands
    }
}
