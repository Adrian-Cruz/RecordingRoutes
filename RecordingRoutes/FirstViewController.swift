//
//  FirstViewController.swift
//  RecordingRoutes
//
//  Created by Adrian on 31/03/20.
//  Copyright © 2020 AdrianCruz. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import ChameleonFramework
import SCLAlertView
import CoreData

class FirstViewController: UIViewController {
    
    let locationManager = CLLocationManager()
    let locationMarker = GMSMarker()
    var mapView = GMSMapView()
    //var path = GMSMutablePath()
    
    var isRecording = false
    var button = UIButton()
    var routeUser = RoutesHandler()
    //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 16.0)
        mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        self.view.addSubview(mapView)

        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        createButton()
    }
    
    func createButton(){
        button = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 50))
        button.backgroundColor = UIColor.flatSkyBlue()
        button.layer.cornerRadius = 15
        button.setTitle("Start", for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        self.view.addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        let bottomConstraint = NSLayoutConstraint.init(item: button, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1.0, constant: -100)
        button.widthAnchor.constraint(equalToConstant: 200).isActive = true
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        bottomConstraint.isActive = true
        self.view.addConstraints([bottomConstraint])
        
        // if previously user has allowed the location permission, then request location
        if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways){
            //locationManager.requestLocation()
            locationManager.startUpdatingLocation()
        }
    }
    
    @objc func buttonAction(sender: UIButton!) {
        if isRecording {                                            //stop recording
            let appearance = SCLAlertView.SCLAppearance(
                showCloseButton: false // if you dont want the close button use false
            )
            let alert = SCLAlertView(appearance: appearance)
            let txt = alert.addTextField("Name")
            alert.addButton("Save") {
                print("Saving: \(txt.text)")
                self.button.backgroundColor = UIColor.flatSkyBlue()
                self.button.setTitle("Start", for: .normal)
                self.isRecording = !self.isRecording
                self.routeUser.name = txt.text ?? ""
                self.routeUser.finalTime = Date()
                self.routeUser.createRoute()
                SCLAlertView().showInfo("Info", subTitle: "Route saved! :)")
                MapsHandler.addMarker(inPosition: self.routeUser.path.coordinate(at: UInt(self.routeUser.path.count()-1)), inMapView: self.mapView, withTitle: "Final", withColor: UIColor.flatOrange())
                //self.routeUser.path = GMSMutablePath()
                self.routeUser = RoutesHandler()
            }
            alert.showEdit("Save Route", subTitle: "Please insert the name of route")
        }else{                                                      //start recording
            self.isRecording = !self.isRecording
            button.backgroundColor = UIColor.flatWatermelon()
            button.setTitle("Stop", for: .normal)
            mapView.clear()
            routeUser.initialTime = Date()
        }
    }
    
    
}


extension FirstViewController: CLLocationManagerDelegate {
  // handle delegate methods of location manager here
    
    
    // called when the authorization status is changed for the core location permission
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("location manager authorization status changed")
        
        switch status {
        case .authorizedAlways:
            print("user allow app to get location data when app is active or in background")
        case .authorizedWhenInUse:
            print("user allow app to get location data only when app is active")
            manager.requestLocation()
        case .denied:
            print("user tap 'disallow' on the permission dialog, cant get location data")
        case .restricted:
            print("parental control setting disallow location data")
        case .notDetermined:
            print("the location permission dialog haven't shown before, user haven't tap allow/disallow")
        @unknown default:
            print("error didChangeAuthorization")
        }
    }
    
   
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // .requestLocation will only pass one location to the locations array
        // hence we can access it by taking the first element of the array
        
        
        if let location = locations.last {
            locationMarker.position = location.coordinate
            locationMarker.icon = UIImage.animatedImage(with: Global.frames as! [UIImage], duration: 0.8)
            locationMarker.groundAnchor = CGPoint(x: 0.5, y: 0.97)
            locationMarker.map = mapView
            
            //let update = GMSCameraUpdate.fit(location.coordinate)
            let vancouver = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let currentPosition = GMSCameraUpdate.setTarget(vancouver)
            mapView.animate(with: currentPosition)
            
            if isRecording {
                if routeUser.path.count() == 0 {
                    MapsHandler.addMarker(inPosition: location.coordinate, inMapView: self.mapView, withTitle: "Inicio", withColor: UIColor.flatGreen())
                }
                
                routeUser.path.addLatitude(location.coordinate.latitude, longitude: location.coordinate.longitude)
                let polyline = GMSPolyline(path: routeUser.path)
                polyline.strokeWidth = 5.0
                polyline.geodesic = true
                polyline.map = mapView
            }
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // might be that user didn't enable location service on the device
        // or there might be no GPS signal inside a building
      
        // might be a good idea to show an alert to user to ask them to walk to a place with GPS signal
    }
    
}
