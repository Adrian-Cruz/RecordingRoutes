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
    var routeViewModel : RouteViewModel?
    var delegate: MyDataSendingDelegateProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewContainerMap.layer.cornerRadius = 15
        labelDistance.text = routeViewModel?.distance
        labelTime.text = routeViewModel?.time
        labelNameOfRoute.text = routeViewModel?.name
    }
    
    override func viewDidAppear(_ animated: Bool) {
        mapView = GMSMapView(frame: self.viewContainerMap.bounds)
        viewContainerMap.addSubview(mapView)
        
        let polyline = GMSPolyline(path: routeViewModel?.path)
        polyline.strokeWidth = 5.0
        polyline.geodesic = true
        polyline.map = mapView
        
        var bounds = GMSCoordinateBounds()
        for index in 1...routeViewModel!.path.count() {
            bounds = bounds.includingCoordinate(routeViewModel!.path.coordinate(at: index))
        }
        mapView.layer.cornerRadius = 15
        mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 60))
        MapsHandler.addMarker(inPosition: routeViewModel!.initialCoordintate, inMapView: self.mapView, withTitle: "Inicio", withColor: UIColor.flatGreen())
        MapsHandler.addMarker(inPosition: routeViewModel!.finalCoordinate, inMapView: self.mapView, withTitle: "Fin", withColor: UIColor.flatOrange())
    }

    @IBAction func clickShare(_ sender: UIBarButtonItem) {
        let bounds = self.view.bounds
        UIGraphicsBeginImageContextWithOptions(bounds.size, true, 0.0)
        self.view.drawHierarchy(in: bounds, afterScreenUpdates: false)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let activityViewController = UIActivityViewController(activityItems: [img ?? UIImage()], applicationActivities: nil)
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func clickRemove(_ sender: UIBarButtonItem) {
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false // if you dont want the close button use false
        )
        let alert = SCLAlertView(appearance: appearance)
        alert.addButton("Yes") {
            print("Removing...")
            RoutesHandler.removeRoute(routeViewModel: self.routeViewModel!)
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
