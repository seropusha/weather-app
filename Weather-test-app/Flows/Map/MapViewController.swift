//
//  MapViewController.swift
//  Weather-test-app
//
//  Created by Serhii Navka on 11.08.2022.
//  Copyright © 2022 Navka. All rights reserved.
//

import Foundation
import UIKit
import MapKit

final class MapViewController: UIViewController {
    
    @IBOutlet private weak var mapView: MKMapView!
    
    var model: MapModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let span = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        let region = MKCoordinateRegion(center: model.coordinates, span: span)
        let annotationView = MKPointAnnotation()
        annotationView.coordinate = model.coordinates
        mapView.setRegion(region, animated: true)
        mapView.addAnnotation(annotationView)
    }
}
