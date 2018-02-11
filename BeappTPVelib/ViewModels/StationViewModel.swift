//
//  StationViewModel.swift
//  BeappTPVelib
//
//  Created by Alexandre Guzu on 31/01/2018.
//  Copyright © 2018 Alexandre Guzu. All rights reserved.
//

import Foundation
import os.log

/// Struct for defining NSCoding keys
struct StationViewModelKey {
    static let name = "name"
    static let status = "status"
    static let availableBikes = "availableBikes"
    static let lastUpdate = "lastUpdate"
}

/// Represents what data from a station will be presented to the UI
class StationViewModel: NSObject, NSCoding {
    
    var name: String
    var status: String
    var availableBikes: String
    var lastUpdate: String
    
    enum Statuses: String {
        case open, closed
    }
    
    // Paths used for storing station data in memory
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("stationViewModels")
    
    /// Initializes a StationViewModel with String data
    init(name: String, status: String, availableBikes: String, lastUpdate: String) {
        self.name = name
        self.status = status
        self.availableBikes = availableBikes
        self.lastUpdate = lastUpdate
    }
    
    /// Optional initializer for a station
    /// - parameter json: the JSON dictionary
    /// - returns: a StationViewModel, or nil if there's an init error
    convenience init?(json: [String:Any]) {
        guard let name = json["name"] as? String,
            let statusString = json["status"] as? String,
            let availableBikes = json["available_bikes"] as? Int,
            let bikeStands = json["bike_stands"] as? Int,
            let timestamp = json["last_update"] as? Double else {
                return nil
        }
        
        // making sure the Status received is consistent with our enum
        guard let status = Statuses(rawValue: statusString.lowercased()) else {
            return nil
        }
        
        let lastUpdateDate = Date(timeIntervalSince1970: timestamp / 1000)
        
        // formatting the Date to a readable string
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        
        dateFormatter.locale = Locale(identifier: "fr_FR")
        
        
        
        // the name contains the station number at the beginning, but we don't care about that, so we trim it
        let trimmedName = name.split(separator: "-", maxSplits: 1, omittingEmptySubsequences: true)[1].trimmingCharacters(in: .whitespaces)

        self.init(name: trimmedName, status: status.rawValue.uppercased(), availableBikes: "\(availableBikes) vélos dispo. sur \(bikeStands)", lastUpdate: "depuis le \(dateFormatter.string(from: lastUpdateDate))")
    }
    
    /// Encodes a station data for storing in memory
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: StationViewModelKey.name)
        aCoder.encode(status, forKey: StationViewModelKey.status)
        aCoder.encode(availableBikes, forKey: StationViewModelKey.availableBikes)
        aCoder.encode(lastUpdate, forKey: StationViewModelKey.lastUpdate)
    }
    
    /// Decodes a station data from memory storage
    required convenience init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObject(forKey: StationViewModelKey.name) as? String,
            let status = aDecoder.decodeObject(forKey: StationViewModelKey.status) as? String,
            let availableBikes = aDecoder.decodeObject(forKey: StationViewModelKey.availableBikes) as? String,
            let lastUpdate = aDecoder.decodeObject(forKey: StationViewModelKey.lastUpdate) as? String else {
            os_log("Unable to decode the name for a Meal object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        self.init(name: name, status: status, availableBikes: availableBikes, lastUpdate: lastUpdate)
    }
}
