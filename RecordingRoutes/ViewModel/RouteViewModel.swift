//
//  RouteViewModel.swift
//  RecordingRoutes
//
//  Created by Adrian on 07/04/20.
//  Copyright © 2020 AdrianCruz. All rights reserved.
//

import Foundation
import GoogleMaps
import CoreData

struct RouteViewModel {
    var name : String?
    var path : GMSMutablePath
    var distance : String
    var initialTimeString : String
    var time : String
    var initialCoordintate : CLLocationCoordinate2D
    var finalCoordinate : CLLocationCoordinate2D
    var idRoute : NSManagedObjectID
    
    init(route: Route) {
        name = route.name
        path = GMSMutablePath(fromEncodedPath: route.arrayOfPoints!)!
        distance = MapsHandler.calculateDistanceInKilometers(inPath: path)
        time = TimeHandler.calculateHoursBetweenDates(initialDate: route.initialTime!, finalDate: route.finalTime!)
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "yyyy-MM-dd HH:mm:ss"
        initialTimeString = dateFormatterPrint.string(from: route.initialTime!)
        initialCoordintate = path.coordinate(at: UInt(0))
        finalCoordinate = path.coordinate(at: UInt(path.count()-1))
        idRoute = route.objectID
    }
}
