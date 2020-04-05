//
//  MapsHandler.swift
//  RecordingRoutes
//
//  Created by Adrian on 04/04/20.
//  Copyright © 2020 AdrianCruz. All rights reserved.
//

import Foundation
import GoogleMaps

class MapsHandler {
    
    static func addMarker(inPosition position: CLLocationCoordinate2D, inMapView mapView : GMSMapView, withTitle title: String, withColor color: UIColor){
        let marker = GMSMarker(position: position)
        marker.title = title
        marker.icon = GMSMarker.markerImage(with: color)
        marker.map = mapView
    }
    
    static func removeAllMarkers(){
        
    }
    
    static func calculateDistanceInKilometers(inPath path: GMSMutablePath) -> String{
        let distanceInMeters = path.length(of: .geodesic)
        let distanceInKms : Double = distanceInMeters / 1000
        let distanceString :String = String(format:"%.1f", distanceInKms)
        return (distanceString + " Kms")
    }
    
}
