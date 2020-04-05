//
//  DetailsViewController.swift
//  RecordingRoutes
//
//  Created by Adrian on 03/04/20.
//  Copyright © 2020 AdrianCruz. All rights reserved.
//

import UIKit
import GoogleMaps
import SCLAlertView

protocol MyDataSendingDelegateProtocol {
    func sendDataToFirstViewController(myData: Int)
}

class DetailsViewController: UIViewController {

    @IBOutlet weak var viewContainerMap: UIView!
    @IBOutlet weak var labelDistance: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var labelNameOfRoute: UILabel!
    
    var mapView = GMSMapView()
    var path = GMSMutablePath()
    var distance = ""
    var time = ""
    var nameOfRoute = ""
    var currentRoute : Route?
    var delegate: MyDataSendingDelegateProtocol?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewContainerMap.layer.cornerRadius = 15
        labelDistance.text = distance
        labelTime.text = time
        labelNameOfRoute.text = nameOfRoute
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 16.0)
        mapView = GMSMapView(frame: self.viewContainerMap.bounds)
        //mapView = GMSMapView.map(frame: viewContainerMap.bounds)
        viewContainerMap.addSubview(mapView)
        
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 5.0
        polyline.geodesic = true
        polyline.map = mapView
        
        var bounds = GMSCoordinateBounds()
        for index in 1...path.count() {
            bounds = bounds.includingCoordinate(path.coordinate(at: index))
        }
        mapView.layer.cornerRadius = 15
        mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 60))
        
        let initialPosition = path.coordinate(at: UInt(0))
        let finalPosition = path.coordinate(at: UInt(path.count()-1))
        MapsHandler.addMarker(inPosition: initialPosition, inMapView: self.mapView, withTitle: "Inicio", withColor: UIColor.flatGreen())
        MapsHandler.addMarker(inPosition: finalPosition, inMapView: self.mapView, withTitle: "Fin", withColor: UIColor.flatOrange())
    }

    @IBAction func clickShare(_ sender: UIBarButtonItem) {
        let bounds = self.view.bounds
        UIGraphicsBeginImageContextWithOptions(bounds.size, true, 0.0)
        self.view.drawHierarchy(in: bounds, afterScreenUpdates: false)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let activityViewController = UIActivityViewController(activityItems: [img], applicationActivities: nil)
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func clickRemove(_ sender: UIBarButtonItem) {
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false // if you dont want the close button use false
        )
        let alert = SCLAlertView(appearance: appearance)
        alert.addButton("Yes") {
            print("Removing...")
            RoutesHandler.removeRoute(route: self.currentRoute!)
            let dataToBeSent = 1
            self.delegate?.sendDataToFirstViewController(myData: dataToBeSent)
            self.dismiss(animated: true, completion: nil)
        }
        alert.addButton("Cancel") {
        }
        alert.showWarning("Warning!", subTitle: "Are you sure you want to delete this item")
    }
    
    @IBAction func clickClose(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
