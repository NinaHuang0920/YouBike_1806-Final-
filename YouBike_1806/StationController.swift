//
//  BikeCollectionViewController.swift
//  YouBike_1806
//
//  Created by 黃玉玲 on 2018/6/18.
//  Copyright © 2018年 CheshireCat. All rights reserved.
//

//protocol StationControllerDelegate {
//    func changeButtonColor(isFavorited: Bool?)
//}

import UIKit

 var stationBikeDatas = [BikeStationInfo]()
 var hasFavoritedArray: [HasFavorited]?

class StationController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchControllerDelegate {
    
    var refreshControl = UIRefreshControl()
    
    private let cellId = "cellId"
    private let headerId = "headerId"

    let searchController = UISearchController(searchResultsController: nil)
    var isShowSearchResult: Bool = false
    var searchArr: [BikeStationInfo] = [BikeStationInfo]() {
        didSet {
            self.collectionView?.reloadData()
        }
    }
    
    var favoritedArr: [BikeStationInfo] = [BikeStationInfo]() {
        didSet {
            self.collectionView?.reloadData()
        }
    }
    
    var isFavoriteBtnPressed: Bool = false {
        didSet {
            print("isFavoriteBtnPressed", isFavoriteBtnPressed)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getStationService()
        setupNav()
        setupRightBarItems()
        setupCollectionView()
        setupRefreshControl()
    }
    
    func setupCollectionView(){
        collectionView?.backgroundColor = mainViewBackgroundColor
        collectionView?.alwaysBounceVertical = true
        collectionView?.register(StationCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.register(HeaderCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
    }
    
    func setupNav() {
        navigationItem.title = "租賃站列表"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 22), NSAttributedStringKey.foregroundColor: mapBarColorBlue]
        navigationController?.navigationBar.barTintColor = stationBarColor
        navigationController?.navigationBar.isTranslucent = false
    }
    
    let favoritedBarBtn = UIBarButtonItem()
    var searchBarBtn = UIBarButtonItem()
    
    let iconButton: UIButton = {
        let bt = UIButton()
        bt.setBackgroundImage(#imageLiteral(resourceName: "unfavstar"), for: .normal)
        return bt
    }()
    
    func setupRightBarItems() {
        searchBarBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.search, target: self, action: #selector(handleSearchBarItem))
        
        iconButton.addTarget(self, action: #selector(handleFavoriteBarBtn(sender:)), for: .touchUpInside)
        favoritedBarBtn.customView = iconButton
        favoritedBarBtn.customView?.transform = CGAffineTransform(scaleX: 0, y: 0)
        
        UIView.animate(withDuration: 1.0, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, options: .curveLinear, animations: {
            self.favoritedBarBtn.customView!.transform = CGAffineTransform.identity
            let items = [self.favoritedBarBtn, self.searchBarBtn]
            self.navigationItem.rightBarButtonItems = items
        }, completion: nil)
    }
    
    var choosefavoritedArr = [BikeStationInfo]()
    
    @objc func handleFavoriteBarBtn(sender: UIButton) {
        choosefavoritedArr = []
        
        if !isFavoriteBtnPressed {
            favoriteBtnPressed()
        } else {
            dismissFavoriteBtnPressed()
        }
        collectionView?.reloadData()
    }
    
    func favoriteBtnPressed()  {
        isFavoriteBtnPressed = true
        iconButton.setBackgroundImage(#imageLiteral(resourceName: "favstar"), for: .normal)
        favoritedBarBtn.customView = iconButton
        UIView.animate(withDuration: 1.0) {
            let items = [self.favoritedBarBtn, self.searchBarBtn]
            self.navigationItem.rightBarButtonItems = items
        }
        
        var templetBikeArry = [BikeStationInfo]()
        let templetFavoriteArray = hasFavoritedArray!.filter({
            return $0.hasFavorited
        })
//        print(templetFavoriteArray)
        for bike in stationBikeDatas {
            for favoritedItem in templetFavoriteArray {
                if bike.sna == favoritedItem.stationName {
                    templetBikeArry.append(bike)
//                    print(bike.sna)
                }
            }
        }
        choosefavoritedArr = templetBikeArry.sorted(by: {$0.distence! < $1.distence!})
    }
    
    func dismissFavoriteBtnPressed()  {
        isFavoriteBtnPressed = false
        iconButton.setBackgroundImage(#imageLiteral(resourceName: "unfavstar"), for: .normal)
        favoritedBarBtn.customView = iconButton
        UIView.animate(withDuration: 1.0) {
            let items = [self.favoritedBarBtn, self.searchBarBtn]
            self.navigationItem.rightBarButtonItems = items
        }
    }
    
    @objc func handleSearchBarItem() {
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
//        definesPresentationContext = true
        searchController.searchBar.placeholder = "請輸入關鍵字"
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
        stationBikeDatas.removeAll()
        self.getStationService()
        self.collectionView?.reloadData()
        self.perform(#selector(finishedRefreshing), with: nil, afterDelay: 1.5)
    }
    
    @objc func finishedRefreshing() {
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.refreshControl.attributedTitle = NSAttributedString(string: "資料更新完成")
        }, completion: { _ in
            self.refreshControl.endRefreshing()
            
            if stationBikeDatas.count == 0 {
                Alert.showAlert(title: "請檢查網路", message: "", vc: self)
            }
        })
    }
    
    
    func getStationService() {
        Service.sharedInstance.fetchJsonData(urlString: webString, completion: { (bikeinfos, err) in
            if let err = err {
                 print("BikeViewController 偵測網路沒開：",err.localizedDescription)
                Alert.showAlert(title: "請開啟網路", message: "更新失敗", vc: self)
            }
            guard let bikeinfos = bikeinfos else { stationBikeDatas = []; return }
           
            let templeteBikeInfos = bikeinfos.sorted(by: { $0.id! < $1.id! })
            if hasFavoritedArray?.count == nil {
                var favoritedArr = [HasFavorited]()
                _ = templeteBikeInfos.map{ favoritedArr.append(HasFavorited(bikeStationInfo: $0, hasFavorited: false)) }
                hasFavoritedArray = favoritedArr
            }
            
            stationBikeDatas = bikeinfos.sorted(by: { $0.distence! < $1.distence! })
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
            Alert.showAlert(title: "下載完成", message: TimeHelper.showUpdateTime(timeString: stationBikeDatas[0].mday!), vc: self)
        })
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isFavoriteBtnPressed {
            return self.choosefavoritedArr.count
        } else {
            if searchController.isActive == true {
                return self.searchArr.count
            } else {
                return stationBikeDatas.count
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! StationCell
        
        var favoritedId: Int

        if isFavoriteBtnPressed {
            cell.bikeStationInfo = self.choosefavoritedArr[indexPath.item]
            cell.favoriteButton.setImage(#imageLiteral(resourceName: "favstar").withRenderingMode(.alwaysOriginal), for: .normal)
        } else {
            if searchController.isActive == true {
                cell.bikeStationInfo = self.searchArr[indexPath.item]
                favoritedId = self.searchArr[indexPath.item].id!
                print("測試searchArr Id", favoritedId)
                print("測試searchArr Item", indexPath.item)
                cell.favoriteButton.tag = favoritedId
                
            } else {
                cell.bikeStationInfo = stationBikeDatas[indexPath.item]
                favoritedId = stationBikeDatas[indexPath.item].id!
                cell.favoriteButton.tag = favoritedId
                print("測試bikeArr Id", favoritedId)
                print("測試bikeArr Item", indexPath.item)
            }
             hasFavoritedArray![favoritedId-1].hasFavorited ? cell.favoriteButton.setImage(#imageLiteral(resourceName: "favstar").withRenderingMode(.alwaysOriginal), for: .normal) : cell.favoriteButton.setImage(#imageLiteral(resourceName: "unfavstar").withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if searchController.isActive == true {
            print("你選擇的是 \(self.searchArr[indexPath.item].sna!)")
        } else {
            print("你選擇的是 \(stationBikeDatas[indexPath.item].sna!)")
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

extension StationController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchController.searchBar.becomeFirstResponder() // close keyborad
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchController.dismiss(animated: true, completion: nil)
        collectionView?.reloadData()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        isShowSearchResult = false
    }
}

extension StationController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        isShowSearchResult = true
        guard let searchText = searchController.searchBar.text else { return }
        if searchText.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count == 0 { return }

        searchArr = stationBikeDatas.filter({ (bikeStation) -> Bool in
            
            let bikeId = bikeStation.id ?? 0
            let bikeStationId = "#"+String(bikeId)
            
            return (bikeStation.sna?.contains(searchText))! || (bikeStation.ar?.contains(searchText))! || (bikeStationId.contains(searchText))
        })
        collectionView?.reloadData()
    }
}

extension StationController {
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

