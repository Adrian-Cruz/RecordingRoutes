//
//  RoutesHandler.swift
//  RecordingRoutes
//
//  Created by Adrian on 04/04/20.
//  Copyright © 2020 AdrianCruz. All rights reserved.
//

import Foundation
import GoogleMaps
import CoreData

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
    
    static func removeRoute(routeViewModel : RouteViewModel) {
        do {
            let found = try Global.context.existingObject(with: routeViewModel.idRoute)
            Global.context.delete(found)
            saveChanges()
        } catch {
            print("Can't find object \(error) to remove")
        }
    }
    
    static func getRoutes() -> [Route]{
        var arrayOfRoutes = [Route]()
        let request : NSFetchRequest<Route> = Route.fetchRequest()
        let sort = NSSortDescriptor(key: "initialTime", ascending: false)
        request.sortDescriptors = [sort]
        do {
            arrayOfRoutes = try Global.context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        return arrayOfRoutes
    }
    
    static func saveChanges(){
        do {
            try Global.context.save()
        } catch {
           print("Error saving context \(error)")
        }
    }
    
}
