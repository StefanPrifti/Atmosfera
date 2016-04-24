//
//  Measure.swift
//  AirCheck
//
//  Created by Stefan Prifti on 22/04/16.
//  Copyright © 2016 Stefan Prifti. All rights reserved.
//

import Foundation

class Measure {
    let sensor_id: String
    let value: String
    let time: String
    

    init(sensor_id: String, value: String, time: String) {
        self.sensor_id = sensor_id
        self.value = value
        self.time = time
    }
    
    init(json: [String: AnyObject]) {
        
        
        self.sensor_id = json["sensor_id"] as! String
        self.value = json["value"] as! String
        self.time = json["time"] as! String
        
    }
    
    var description : String {
        return "Sensor id: \(self.sensor_id), Value: \(self.value), Time: \(self.time)"
    }

    
}