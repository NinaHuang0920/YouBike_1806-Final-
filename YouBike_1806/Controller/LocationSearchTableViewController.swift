//
//  LocationSearchTableViewController.swift
//  YouBike_1806
//
//  Created by 黃玉玲 on 2018/8/2.
//  Copyright © 2018年 CheshireCat. All rights reserved.
//

import UIKit
import MapKit

class LocationSearchTableViewController: UITableViewController, MKMapViewDelegate {

    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        var tableCount = 1
        
        if isShowMapSearchResult == true {
           tableCount = mapSearchArr.count
        } else {
            tableCount = bikeDatas.count
        }
        
        return tableCount
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        
       if isShowMapSearchResult == true {
            cell.textLabel?.text = mapSearchArr[indexPath.row].title!
        
        } else {
            cell.textLabel?.text = bikeDatas[indexPath.row].sna
        
        }
        
        return cell
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedPin = nil
        
        var selectedItem: MKAnnotation
        
        if isShowMapSearchResult {
            selectedItem = mapSearchArr[indexPath.row]
        } else {
            selectedItem = arrAnnotation[indexPath.row]
        }
        print("TableView選擇的是：",selectedItem.title!!)
        selectedPin = selectedItem
        
        let name = Notification.Name(rawValue: moveToSelectedPinNotificationKey)
        NotificationCenter.default.post(name: name, object: nil)
        
        dismiss(animated: true, completion: nil)
    }
}

extension LocationSearchTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController)
    {
        guard let searchText = searchController.searchBar.text else { return }
        if searchText.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count == 0 { return }
            mapSearchArr = arrAnnotation.filter({ (annotation) -> Bool in
                return (annotation.title??.contains(searchText))! || (annotation.subtitle??.contains(searchText))!
            })
        self.tableView.reloadData()
    }
    
    
}
