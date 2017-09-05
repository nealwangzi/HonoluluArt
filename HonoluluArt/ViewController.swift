//
//  ViewController.swift
//  HonoluluArt
//
//  Created by neal on 2017/9/5.
//  Copyright © 2017年 neal. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    var artworks = [Artwork]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // 设置可见区域
        let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
        
        centerMapOnLocation(location: initialLocation)
        
//        let artwork = Artwork(title: "kind david kalakaua",
//                              locationName: "waikiki gateway park",
//                              discipline: "sculpture", coordinate: CLLocationCoordinate2D(latitude: 21.283921, longitude: -157.831661))
//        mapView.addAnnotation(artwork)
        mapView.delegate = self
        
        loadInitialData()
        mapView.addAnnotations(artworks)
    }
    
    

    func loadInitialData() {
        //1
        let fileName = Bundle.main.path(forResource: "PublicArt", ofType: "json")
        var data: Data?
        do {
            data = try Data(contentsOf: URL(fileURLWithPath: fileName!), options: Data.ReadingOptions.init(rawValue: 0))
        } catch _ {
            data = nil
        }
        
        //2
        var jsonObject:Any? = nil
        if let data = data {
            do {
                jsonObject = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.init(rawValue: 0))
            } catch _ {
                jsonObject = nil
            }
        }
        
        //3
        if let jsonObject = jsonObject as? [String: Any],
            let jsonData = JSONValue.fromObject(jsonObject)?["data"]?.array
        {
            for artworkJSON in jsonData {
                if let artworkJSON = artworkJSON.array,
                    let artwork = Artwork.fromJSON(artworkJSON)
                {
                    artworks.append(artwork)
                }
            }
        }
    }
    let regionRadius:CLLocationDistance = 1000

    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }

    // MARK: - 获取用户定位授权状态

    var locationManager = CLLocationManager()
    func checkLocationAuthrizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
        }else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationAuthrizationStatus()
    }
}

