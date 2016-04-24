//
//  Sensor.swift
//  AirCheck
//
//  Created by Stefan Prifti on 23/04/16.
//  Copyright © 2016 Stefan Prifti. All rights reserved.
//

import Foundation


class Sensor {
    
    var stationName: String
    var stationNameShort: String
    var unit: String
    var limitValue: String
    var values: [Measure]
    
    init(stationName: String, stationNameShort: String, unit: String, limitValue: String, values: [Measure]) {
        
        self.stationName = stationName
        self.stationNameShort = stationNameShort
        self.unit = unit
        self.limitValue = limitValue
        self.values = values
        
    }
    
    
    init(json: [String: AnyObject]) {
        
        values = [Measure]()
        
        let valuesJSON = json["values"] as! [AnyObject]
        
        
        self.stationName = json["station_name_long"] as! String
        self.stationNameShort = json["station_name_short"] as! String
        self.unit = json["unit"] as! String
        self.limitValue = json["limit_value"] as! String

        
        for row in valuesJSON {
            
            let sensor_id = row["sensor_id"] as! String
            let value = row["value"] as! String
            let time = row["time"] as! String
            
            
            
            let measure = Measure(sensor_id: sensor_id, value: value, time: time)
            
            
            self.values.append(measure)
        }
    }
    
    var description: String {
        return "Station: \(stationName), Short: \(stationNameShort), Unit: \(unit), Limit: \(limitValue), Values: \(values)"
    }
    
    func getLatestValue() -> (name: String, value: Measure) {
        return (name: stationName, value: values[values.count - 1])
    }
}