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
    var routeViewModels = [RouteViewModel]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refreshRoutesData(_:)), for: .valueChanged)
        let colorRefreshing = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
        refreshControl.tintColor = colorRefreshing
        let myAttribute = [ NSAttributedString.Key.foregroundColor: colorRefreshing ]
        refreshControl.attributedTitle = NSAttributedString(string: "Updating routes ...", attributes: myAttribute)
        fetchData()
    }
    
    @objc private func refreshRoutesData(_ sender: Any) {
        self.refreshControl.endRefreshing()
        fetchData()
    }
    
    fileprivate func fetchData() {
        self.routeViewModels = RoutesHandler.getRoutes().map({return RouteViewModel(route: $0)})
        self.myTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                return routeViewModels.count
    }
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 94.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellRoute") as! RouteTableViewCell
        cell.routeViewModel = self.routeViewModels[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailsVC = DetailsViewController()
        let selectedRouteModelView = self.routeViewModels[indexPath.row]
        detailsVC.routeViewModel = selectedRouteModelView
        detailsVC.delegate = self
        self.present(detailsVC, animated: true, completion: nil)
    }
    
    func sendDataToFirstViewController(myData: Int) {
        fetchData()
    }

}
