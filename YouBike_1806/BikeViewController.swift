//
//  BikeCollectionViewController.swift
//  YouBike_1806
//
//  Created by 黃玉玲 on 2018/6/18.
//  Copyright © 2018年 CheshireCat. All rights reserved.
//

import UIKit

class BikeViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchControllerDelegate {
    
    var bikeDatas = [BikeStationInfo]()
    
    var refreshControl = UIRefreshControl()
    
    private let cellId = "cellId"
    private let headerId = "headerId"

    let searchController = UISearchController(searchResultsController: nil)
    var searchActive: Bool = false
    var isShowSearchResult: Bool = false
    var searchArr: [BikeStationInfo] = [BikeStationInfo]() {
        didSet {
            self.collectionView?.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SetService()
        setupNav()
        setupNavSearchItem()
        setupCollectionView()
        setupRefreshControl()
    }
    
    func setupCollectionView(){
        collectionView?.backgroundColor = mainViewBackgroundColor
        collectionView?.alwaysBounceVertical = true
        collectionView?.register(BikeCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.register(HeaderCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
    }
    
    func setupNav() {
        navigationItem.title = "租賃站列表"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 22), NSAttributedStringKey.foregroundColor: mapBarColorBlue]
        navigationController?.navigationBar.barTintColor = stationBarColor
        navigationController?.navigationBar.isTranslucent = false
    }
    
    func setupNavSearchItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.search, target: self, action: #selector(handleSearchBarItem))
    }
    
    @objc func handleSearchBarItem() {
        self.searchController.delegate = self
        self.searchController.searchBar.delegate = self
        self.searchController.searchResultsUpdater = self
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.searchBar.placeholder = "請輸入關鍵字"
        searchController.searchBar.becomeFirstResponder()
        present(searchController, animated: true, completion: nil)
    }

    func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refreshContents), for: .valueChanged)
        if #available(iOS 10.0, *) {
            collectionView?.refreshControl = refreshControl
        } else {
            collectionView?.addSubview(refreshControl)
        }
    }
    
    @objc func refreshContents() {
        refreshControl.attributedTitle = NSAttributedString(string: "資料更新中")
        self.bikeDatas.removeAll()
        self.SetService()
        self.collectionView?.reloadData()
        self.perform(#selector(finishedRefreshing), with: nil, afterDelay: 1.5)
    }
    
    @objc func finishedRefreshing() {
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.refreshControl.attributedTitle = NSAttributedString(string: "資料更新完成")
        }, completion: { _ in
            self.refreshControl.endRefreshing()
            
            if self.bikeDatas.count == 0 {
                Alert.showAlert(title: "請檢查網路", message: "", vc: self)
            }
        })
    }
    
    func SetService() {
        Service.sharedInstance.fetchJsonData(urlString: webString, completion: { (bikeinfos, err) in
            if let err = err {
                 print("BikeViewController 偵測網路沒開：",err.localizedDescription)
                Alert.showAlert(title: "請開啟網路", message: "更新失敗", vc: self)
            }
            guard let bikeinfos = bikeinfos else { self.bikeDatas = []; return }
            self.bikeDatas = bikeinfos
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
            
            Alert.showAlert(title: "下載完成", message: TimeHelper.showUpdateTime(timeString: self.bikeDatas[0].mday!), vc: self)
        })
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if searchController.isActive == true {
            return self.searchArr.count
        } else {
            return self.bikeDatas.count
        }
        
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! BikeCell
        
        if searchController.isActive == true {
            cell.bikeStationInfo = self.searchArr[indexPath.item]
        } else {
            cell.bikeStationInfo = self.bikeDatas[indexPath.item]
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if searchController.isActive == true {
            print("你選擇的是 \(self.searchArr[indexPath.row].sna!)")
        } else {
            print("你選擇的是 \(self.bikeDatas[indexPath.row].sna!)")
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 10, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsetsMake(5, 0, 0, 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        var hearderSize: CGSize
        if isShowSearchResult {
            hearderSize = CGSize(width: screenWidth, height: 40)
        } else {
            hearderSize = .zero
        }
        return hearderSize
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerCell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! HeaderCell
        headerCell.headerLabel.text = searchResultText(searchArrCount: searchArr.count)
        return headerCell
    }
}

class HeaderCell: BaseCell {
    let headerLabel: UILabel = {
        let lb = UILabel()
        lb.textAlignment = .center
        lb.font = UIFont.systemFont(ofSize: 20)
        lb.text = "共 0 筆資料"
        lb.adjustsFontSizeToFitWidth = true
        lb.backgroundColor = UIColor.darkGray
        lb.textColor = UIColor.white
        return lb
    }()
    
    override func setupViews() {
        super.setupViews()
        addSubview(headerLabel)
        headerLabel.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 5, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
}

extension BikeViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchController.searchBar.becomeFirstResponder() // close keyborad
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        searchController.dismiss(animated: true, completion: nil)
        collectionView?.reloadData()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        isShowSearchResult = false
    }
}

extension BikeViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        isShowSearchResult = true
        guard let searchText = searchController.searchBar.text else { return }
        if searchText.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count == 0 { return }

        searchArr = bikeDatas.filter({ (bikeStation) -> Bool in
            
            let bikeId = bikeStation.id ?? 0
            let bikeStationId = "#"+String(bikeId)
            
            return (bikeStation.sna?.contains(searchText))! || (bikeStation.ar?.contains(searchText))! || (bikeStationId.contains(searchText))
        })
        collectionView?.reloadData()
    }
}

extension BikeViewController {
    func searchResultText(searchArrCount: Int) -> String {
        let searchResult: String
        if searchArrCount > 0 {
            searchResult = "共 \(searchArrCount) 筆資料"
        } else {
            searchResult = "共0筆資料，請嘗試其他關鍵字"
        }
        return searchResult
    }
}

