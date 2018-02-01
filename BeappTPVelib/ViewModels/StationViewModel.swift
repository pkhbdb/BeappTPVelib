//
//  StationViewModel.swift
//  BeappTPVelib
//
//  Created by Alexandre Guzu on 31/01/2018.
//  Copyright © 2018 Alexandre Guzu. All rights reserved.
//

import Foundation

struct StationViewModel {
    let name: String
    let status: String
    let availableBikes: String
    let lastUpdate: String
    
    enum Statuses: String {
        case open, closed
    }
}

extension StationViewModel {
    
    /**
    Initializer optionnel pour une station
    - parameter json: le dictionnaire de données JSON
    - returns: nil si erreur de type à l'initialisation, sinon une Station
    */
    init?(json: [String:Any]) {
        guard let name = json["name"] as? String,
            let statusString = json["status"] as? String,
            let availableBikes = json["available_bikes"] as? Int,
            let bikeStands = json["bike_stands"] as? Int,
            let timestamp = json["last_update"] as? Double else {
                return nil
        }
        
        guard let status = Statuses(rawValue: statusString.lowercased()) else {
            return nil
        }
        
        self.name = name
        self.status = status.rawValue.uppercased()
        self.availableBikes = "\(availableBikes)/\(bikeStands)"
        
        let lastUpdateDate = Date(timeIntervalSince1970: timestamp / 1000)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        
        dateFormatter.locale = Locale(identifier: "fr_FR")
        
        self.lastUpdate = dateFormatter.string(from: lastUpdateDate)
    }
}
