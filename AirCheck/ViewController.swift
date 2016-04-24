//
//  ViewController.swift
//  AirCheck
//
//  Created by Stefan Prifti on 18/04/16.
//  Copyright © 2016 Stefan Prifti. All rights reserved.
//

import UIKit
import MapKit

let kHeaderHeight:CGFloat = 200

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var panorama: UIImageView!
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var airQualityIndexLabel: UILabel!
    
    @IBOutlet weak var temperatureLabel: UILabel!
    
    @IBOutlet weak var humidityLabel: UILabel!
    
    @IBOutlet weak var map: MKMapView!
    
    let regionRadius: CLLocationDistance = 1000
    
    let colors: [UIColor] = [
        UIColor(red: 188/255.0, green: 245/255.0, blue: 169/255.0, alpha: 0.6), // jeshile
        UIColor(red: 243/255.0, green: 226/255.0, blue: 169/255.0, alpha: 0.6), // portokalli
        UIColor(red: 246/255.0, green: 216/255.0, blue: 206/255.0, alpha: 0.6), // kuqe
        UIColor(red: 246/255.0, green: 216/255.0, blue: 206/255.0, alpha: 0.6) // shume e kuqe
    ]
    
    let size: CGFloat = 68.0
    
    var latestValues = [(String, Measure)]()
    var jsonOBJ: Api?
    
    let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    func loadData() {
        airQualityIndexLabel.layer.masksToBounds = true
        airQualityIndexLabel.layer.cornerRadius = 35.0
        
        refreshControl.addTarget(self, action: "reload:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)
        
        let requestURL: NSURL = NSURL(string: "http://46.101.143.44/api/index.php")!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: requestURL)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(urlRequest) {
            (data, response, error) -> Void in
            
            let httpResponse = response as! NSHTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if (statusCode == 200) {
                
                do{
                    
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options:.AllowFragments)
                    self.jsonOBJ = Api(json: json as! [String : AnyObject])
                    self.latestValues = self.jsonOBJ!.getLatest()
                    
                    self.temperatureLabel.text = String(format: "%.0f", Double((self.jsonOBJ?.weatherTemperature)!)) + " °C"
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        ImageLoader.sharedLoader.imageForUrl((self.jsonOBJ?.panorama)!, completionHandler:{(image: UIImage?, url: String) in
                            self.panorama.image = image!
                        })
                        
                        self.tableView.reloadData()
                        
                        let initialLocation = CLLocation(latitude: Double((self.jsonOBJ?.lat)!)!, longitude: Double((self.jsonOBJ?.lon)!)!)
                        
                        
                        // Drop a pin
                        let dropPin = MKPointAnnotation()
                        dropPin.coordinate = CLLocationCoordinate2DMake(Double((self.jsonOBJ?.lat)!)!, Double((self.jsonOBJ?.lon)!)!)
                        dropPin.title = "Stacioni"
                        self.map.addAnnotation(dropPin)
                        
                        
                        self.centerMapOnLocation(initialLocation)
                        
                    })
                    
                }catch {
                    print("Error with Json: \(error)")
                    
                }
                
            }
            
        }
        
        task.resume()
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        self.map.setRegion(coordinateRegion, animated: true)
    }
    
    func reload(refreshControl: UIRefreshControl) {
        loadData()
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.latestValues.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("sensorCell") as! TableViewCell
        
        cell.name!.text = self.latestValues[indexPath.row].0
        cell.value!.text = "\(self.latestValues[indexPath.row].1.value) \(self.jsonOBJ!.sensors[indexPath.row].unit)"
        
        
        if indexPath.row != 0 {
            switch (Double(self.latestValues[indexPath.row].1.value)! / Double(self.jsonOBJ!.sensors[indexPath.row].limitValue)!) {
            case 0..<0.5:
                cell.backgroundColor = self.colors[0]
            case 0.5..<1.0:
                cell.backgroundColor = self.colors[1]
            case 1.0..<1.2:
                cell.backgroundColor = self.colors[2]
            default:
                cell.backgroundColor = self.colors[3]
            }
        }

        return cell
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
}