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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // 设置可见区域
        let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
        
        centerMapOnLocation(location: initialLocation)
        
        let artwork = Artwork(title: "kind david kalakaua",
                              locationName: "waikiki gateway park",
                              discipline: "sculpture", coordinate: CLLocationCoordinate2D(latitude: 21.283921, longitude: -157.831661))
        mapView.addAnnotation(artwork)
        mapView.delegate = self
    }
    
    let regionRadius:CLLocationDistance = 1000

    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }

}

