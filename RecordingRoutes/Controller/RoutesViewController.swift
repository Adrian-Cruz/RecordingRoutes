//
//  RoutesViewController.swift
//  RecordingRoutes
//
//  Created by Adrian on 03/04/20.
//  Copyright © 2020 AdrianCruz. All rights reserved.
//

import UIKit
import CoreData
import GoogleMaps

class RoutesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITabBarControllerDelegate, MyDataSendingDelegateProtocol {
    
    

    @IBOutlet weak var myTableView: UITableView!
    var arrayOfRoutes : [Route] = [Route]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refreshWeatherData(_:)), for: .valueChanged)
        
        let colorRefreshing = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
        refreshControl.tintColor = colorRefreshing
        let myAttribute = [ NSAttributedString.Key.foregroundColor: colorRefreshing ]
        refreshControl.attributedTitle = NSAttributedString(string: "Updating routes ...", attributes: myAttribute)
        
        loadItems()
        
    }
    
    @objc private func refreshWeatherData(_ sender: Any) {
        // Fetch Weather Data
        self.refreshControl.endRefreshing()
        loadItems()
        myTableView.reloadData()
    }
    

    func loadItems(){
        let request : NSFetchRequest<Route> = Route.fetchRequest()
        let sort = NSSortDescriptor(key: "initialTime", ascending: false)
        request.sortDescriptors = [sort]
        do {
            arrayOfRoutes = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                return arrayOfRoutes.count
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 94.0
        }
        

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellRoute") as! RouteTableViewCell
            cell.labelNameRoute.text = arrayOfRoutes[indexPath.row].name
            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            cell.labelInitialDateRoute.text = dateFormatterPrint.string(from: arrayOfRoutes[indexPath.row].initialTime!)


            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let detailsVC = DetailsViewController()
            let selectedRoute = self.arrayOfRoutes[indexPath.row]
            let pathSelectedRoute = GMSMutablePath(fromEncodedPath: selectedRoute.arrayOfPoints!)!
            detailsVC.path = pathSelectedRoute
            detailsVC.currentRoute = selectedRoute
            detailsVC.distance = MapsHandler.calculateDistanceInKilometers(inPath: pathSelectedRoute)
            detailsVC.time = TimeHandler.calculateHoursBetweenDates(initialDate: selectedRoute.initialTime!, finalDate: selectedRoute.finalTime!)
            detailsVC.nameOfRoute = selectedRoute.name ?? "-"
            detailsVC.delegate = self
            self.present(detailsVC, animated: true, completion: nil)
        }
    
    
    func sendDataToFirstViewController(myData: Int) {
        loadItems()
        myTableView.reloadData()
    }
    
    
    

}
