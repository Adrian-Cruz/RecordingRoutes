//
//  RoutesHandler.swift
//  RecordingRoutes
//
//  Created by Adrian on 04/04/20.
//  Copyright © 2020 AdrianCruz. All rights reserved.
//

import Foundation
import GoogleMaps

class RoutesHandler {
    
    var name : String
    var path : GMSMutablePath
    var distance : Double
    var initialTime : Date
    var finalTime : Date
    
    init() {
        name = ""
        path = GMSMutablePath()
        distance = 0
        initialTime = Date()
        finalTime = Date()
    }
    
    func createRoute() {
        let newItem = Route(context: Global.context)
        newItem.name = name
        newItem.arrayOfPoints = path.encodedPath()
        newItem.distance = distance
        newItem.initialTime = initialTime
        newItem.finalTime = finalTime
        RoutesHandler.saveChanges()
    }
    
    static func removeRoute(route : Route) {
        Global.context.delete(route)
        saveChanges()
    }
    
    static func saveChanges(){
        do {
            try Global.context.save()
        } catch {
           print("Error saving context \(error)")
        }
    }
    
}
