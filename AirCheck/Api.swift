//
//  Api.swift
//  AirCheck
//
//  Created by Stefan Prifti on 23/04/16.
//  Copyright © 2016 Stefan Prifti. All rights reserved.
//

import Foundation


class Api {
    
    var city: String                    // city
    var address: String                 // address
    var lat: String                     // lat
    var lon: String                     // lon
    var weatherSummary: String          // weather_summary
    var weatherTime: String             // weather_time
    var weatherIcon: String             // weather_icon
    var weatherTemperature: Double      // weather_temperature
    var panorama: String                // panorama
    var aqi: String                     // aqi
    var desc: String                    // description
    
    var sensors: [Sensor]
    
    
    
    
    init(json: [String: AnyObject]) {
        
        sensors = [Sensor]()
        
        self.city = json["city"] as! String
        self.address = json["address"] as! String
        self.lat = json["lat"] as! String
        self.lon = json["lon"] as! String
        self.weatherSummary = json["weather_summary"] as! String
        self.weatherTime = json["weather_time"] as! String
        self.weatherIcon = json["weather_icon"] as! String
        self.weatherTemperature = json["weather_temperature"] as! Double
        self.panorama = json["panorama"] as! String
        self.aqi = json["aqi"] as! String
        self.desc = json["description"] as! String
        
        
        for i in 0...9 {
            let sensor = json["sensor_\(i)"] as! [String: AnyObject]
            let sensorObj = Sensor(json: sensor)
            sensors.append(sensorObj)
        }

    }
    
    
    func getLatest() -> [(String, Measure)] {
        
        var latesValues = [(String, Measure)]()
        
        for (index, sensor) in sensors.enumerate() {
            latesValues.append( sensor.getLatestValue() )
        }
        
        return latesValues
    }
    
    
    
}