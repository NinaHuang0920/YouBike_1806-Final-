//
//  BikeCollectionViewController.swift
//  YouBike_1806
//
//  Created by 黃玉玲 on 2018/6/18.
//  Copyright © 2018年 CheshireCat. All rights reserved.
//


import UIKit
import MapKit
import CoreData

var stationDatas = [StationInfo]()

class StationController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchControllerDelegate {

    var refreshControl: UIRefreshControl?
    
    private let cellId = "cellId"
    private let headerId = "headerId"

    let searchController = UISearchController(searchResultsController: nil)
    var isShowSearchResult: Bool = false
    var searchArr: [StationInfo] = [StationInfo]() {
        didSet {
            self.collectionView?.reloadData()
        }
    }
    
    let favoritedBarBtn = UIBarButtonItem()
    var searchBarBtn = UIBarButtonItem()
    let iconButton: UIButton = {
        let bt = UIButton()
        bt.setBackgroundImage(#imageLiteral(resourceName: "unfavstar"), for: .normal)
        return bt
    }()
    
    var isFavoriteBtnPressed: Bool = false {
        didSet {
            print("isFavoriteBtnPressed", isFavoriteBtnPressed)
        }
    }
    var choosefavoritedArr = [StationInfo]()
    
    lazy var nodataMessageLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 150))
        label.text = "無資料可顯示\n開啟網路後下拉更新頁面"
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 22) //
        label.textColor = stationTitleLableColor //
        label.isHidden = true
        label.adjustsFontSizeToFitWidth = true
        label.adjustsFontForContentSizeCategory = true
        label.center = CGPoint(x: self.view.bounds.width/2, y: self.view.bounds.height*0.4)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(self.nodataMessageLabel)
        setupNavigation()
        setupCollectionView()
        setupRefreshControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if LocationService.sharedInstance.authorizationStatus() == .denied {
            Alert.showAlert(title: "使用者定位關閉", message: "請至 設定 > 隱私權 > 定位服務 開啟定位服務", vc: self)
        }
        
        GetService.sharedInstance.getStationService(coreDataHandler: { (sortStationIdDatas) in
            self.saveInCoreDataWith(sortedArrayById: sortStationIdDatas)
        }, collectionViewReloadHandler: {
            self.collectionView?.reloadData()
        }, messageblock: {
            if stationDatas.count == 0 {
                Alert.showAlert(title: "資料無法下載", message: "請開啟網路", vc: self)
            }
            self.nodataMessageLabel.isHidden = !(stationDatas.count == 0)
        })
        
    }
    
   
    // MARK: - NavigationBar
    func setupNavigation() {
        setupNavigationTitle()
        setupRightBarItems()
        setupBackBarItem()
    }
    func setupNavigationTitle() {
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = "租賃站列表"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 22), NSAttributedStringKey.foregroundColor: navigationTitleColor]
        navigationController?.navigationBar.barTintColor = navigationBarColor
        navigationController?.navigationBar.isTranslucent = false
    }
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
    func setupBackBarItem() {
        let navBackBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        navBackBarButtonItem.tintColor = stationTitleLableColor
        navigationItem.backBarButtonItem = navBackBarButtonItem
    }
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
        collectionView?.refreshControl = nil
        isFavoriteBtnPressed = true
        iconButton.setBackgroundImage(#imageLiteral(resourceName: "favstar").withRenderingMode(.alwaysOriginal), for: .normal)
        favoritedBarBtn.customView = iconButton
        UIView.animate(withDuration: 1.0) {
            let items = [self.favoritedBarBtn]
            self.navigationItem.rightBarButtonItems = items
        }
        var templetButtonFavoritedArray = [String]()
        _ = self.filterDataByHasFavoritedButton()?.map({ templetButtonFavoritedArray.append($0.stationName!)})
        
        let templeteStationFavoritedArray = stationDatas.filter({ templetButtonFavoritedArray.contains($0.sna!)})
        
        if templeteStationFavoritedArray.first?.distence == nil {
            choosefavoritedArr = templeteStationFavoritedArray
        } else {
            choosefavoritedArr = templeteStationFavoritedArray.sorted(by: { $0.distence! < $1.distence! })
        }
    }
    
    func dismissFavoriteBtnPressed()  {
        setupRefreshControl()
        isFavoriteBtnPressed = false
        iconButton.setBackgroundImage(#imageLiteral(resourceName: "unfavstar"), for: .normal)
        favoritedBarBtn.customView = iconButton
        favoritedBarBtn.customView!.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi * 6/5))
        UIView.animate(withDuration: 1.0) {
            let items = [self.favoritedBarBtn, self.searchBarBtn]
            self.navigationItem.rightBarButtonItems = items
            self.favoritedBarBtn.customView!.transform = CGAffineTransform.identity
        }
    }
    
    @objc func handleSearchBarItem() {
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "請輸入關鍵字"
        searchController.searchBar.becomeFirstResponder()
        present(searchController, animated: true, completion: nil)
    }

    func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refreshContents), for: .valueChanged)
        if #available(iOS 10.0, *) {
            collectionView?.refreshControl = refreshControl
        } else {
            collectionView?.addSubview(refreshControl!)
        }
    }
    
    @objc func refreshContents() {
        refreshControl?.attributedTitle = NSAttributedString(string: "資料更新中")
        stationDatas.removeAll()
        
        GetService.sharedInstance.getStationService(coreDataHandler: { (sortStationIdDatas) in
            self.saveInCoreDataWith(sortedArrayById: sortStationIdDatas)
        }, collectionViewReloadHandler: {
            self.collectionView?.reloadData()
        }, messageblock: {
            self.nodataMessageLabel.isHidden = !(stationDatas.count == 0)                     })
        self.collectionView?.reloadData()
        self.updateFocusIfNeeded()//
        self.perform(#selector(finishedRefreshing), with: nil, afterDelay: 1.5)
    }
    
    @objc func finishedRefreshing() {
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.refreshControl?.attributedTitle = NSAttributedString(string: "資料更新完成")
        }, completion: { _ in
            self.refreshControl?.endRefreshing()
            self.updateFocusIfNeeded()//
            
            if stationDatas.count == 0 {
                Alert.showAlert(title: "更新失敗", message: "請確認網路開啟", vc: self)
            }
        })
    }
    
    
    // MARK: - CollectionView Setting
    func setupCollectionView(){
        collectionView?.backgroundColor = mainViewBackgroundColor
        collectionView?.alwaysBounceVertical = true
        collectionView?.register(StationCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.register(HeaderCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isFavoriteBtnPressed {
            return self.choosefavoritedArr.count
        } else {
            if searchController.isActive == true {
                return self.searchArr.count
            } else {
                return stationDatas.count
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! StationCell
        cell.stationController = self
        
        var favoritedId: Int

        if isFavoriteBtnPressed {
            cell.stationInfos = self.choosefavoritedArr[indexPath.item]
            favoritedId = self.choosefavoritedArr[indexPath.item].id!
            print("chooseFAvoritdArr Id:", favoritedId)
            cell.favoriteButton.tag = favoritedId

                (self.filterDataByStationId(stationId: Int16(favoritedId))?.first?.hasFavorited)! ? cell.favoriteButton.setImage(#imageLiteral(resourceName: "favstar").withRenderingMode(.alwaysOriginal), for: .normal) : cell.favoriteButton.setImage(#imageLiteral(resourceName: "unfavstar").withRenderingMode(.alwaysOriginal), for: .normal)
        } else {
            if searchController.isActive == true {
                cell.stationInfos = self.searchArr[indexPath.item]
                favoritedId = self.searchArr[indexPath.item].id!
                print("測試searchArr Id", favoritedId)
                print("測試searchArr Item", indexPath.item)
                cell.favoriteButton.tag = favoritedId
                
                (self.filterDataByStationId(stationId: Int16(favoritedId))?.first?.hasFavorited)! ? cell.favoriteButton.setImage(#imageLiteral(resourceName: "favstar").withRenderingMode(.alwaysOriginal), for: .normal) : cell.favoriteButton.setImage(#imageLiteral(resourceName: "unfavstar").withRenderingMode(.alwaysOriginal), for: .normal)
                
            } else {
                cell.stationInfos = stationDatas[indexPath.item]
                favoritedId = stationDatas[indexPath.item].id!
                cell.favoriteButton.tag = favoritedId
                print("測試bikeArr Id", favoritedId)
                print("測試bikeArr Item", indexPath.item)
                
                (self.filterDataByStationId(stationId: Int16(favoritedId))?.first?.hasFavorited)! ? cell.favoriteButton.setImage(#imageLiteral(resourceName: "favstar").withRenderingMode(.alwaysOriginal), for: .normal) : cell.favoriteButton.setImage(#imageLiteral(resourceName: "unfavstar").withRenderingMode(.alwaysOriginal), for: .normal)
            }
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let detatilView = StationDetailView()
        let stationCell = StationCell()
        detatilView.stationController = self
        stationCell.stationController = self
        var favoritedId: Int
        
        if isFavoriteBtnPressed {
            print("你選擇的是 \(self.choosefavoritedArr[indexPath.item].sna!)")
            detatilView.stationInfo = choosefavoritedArr[indexPath.item]
            favoritedId = self.choosefavoritedArr[indexPath.item].id!
            detatilView.favoriteButton.tag = favoritedId
    
            (self.filterDataByStationId(stationId: Int16(favoritedId))?.first?.hasFavorited)! ? detatilView.favoriteButton.setTitle("移除最愛", for: .normal) : detatilView.favoriteButton.setTitle("加入最愛", for: .normal)
        } else {
            if searchController.isActive == true {
                print("你選擇的是 \(self.searchArr[indexPath.item].sna!)")
                detatilView.stationInfo = self.searchArr[indexPath.item]
                favoritedId = self.searchArr[indexPath.item].id!
                detatilView.favoriteButton.tag = favoritedId
            } else {
                print("你選擇的是 \(stationDatas[indexPath.item].sna!)")
                detatilView.stationInfo = stationDatas[indexPath.item]
                favoritedId = stationDatas[indexPath.item].id!
                detatilView.favoriteButton.tag = favoritedId
            }
            (self.filterDataByStationId(stationId: Int16(favoritedId))?.first?.hasFavorited)! ? detatilView.favoriteButton.setTitle("移除最愛", for: .normal) : detatilView.favoriteButton.setTitle("加入最愛", for: .normal)
        }
        
        navigationController?.pushViewController(detatilView, animated: true)
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


// MARK: - UISearchBarDelegate
extension StationController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchController.searchBar.becomeFirstResponder() // close keyborad
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchController.dismiss(animated: true, completion: nil)
        collectionView?.reloadData()
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchArr = stationDatas
        return true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        isShowSearchResult = false
        collectionView?.reloadData()
    }
}

extension StationController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        isShowSearchResult = true
        guard let searchText = searchController.searchBar.text else { return }
        if searchText.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count == 0 { return }
        searchArr = [StationInfo]()
        searchArr = stationDatas.filter({ (bikeStation) -> Bool in
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

// MARK: - CoreData
extension StationController {
    
    func deleteObject(buttonStatus: ButtonStatus) -> Bool {
        let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
        context.delete(buttonStatus)
        do {
            try context.save()
            print("DeleteObject Successed")
            return true
        } catch let error {
            print(error)
            print("DeleteObject Failed")
            return false
        }
    }
    
    func clearData() -> Bool {
        let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
        let delete = NSBatchDeleteRequest(fetchRequest: ButtonStatus.fetchRequest())
        
        do{
            try context.execute(delete)
            print("Batched Delete Successed")
            return true
        } catch let error {
            print("Error Delete CoreData", error.localizedDescription)
            print("Batched Delete Failed")
            return false
        }
    }
    
    func fetchObject() -> [ButtonStatus]? {
        let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
        var buttonStatus: [ButtonStatus]? = nil
        do {
            buttonStatus = try context.fetch(ButtonStatus.fetchRequest())
            return buttonStatus
            
        } catch {
            return buttonStatus
        }
    }
    
    func filterDataByStationName(stationName: String) -> [ButtonStatus]? {
        let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<ButtonStatus> = ButtonStatus.fetchRequest()
        var buttonStatus: [ButtonStatus]? = nil
        
        let perdicate = NSPredicate(format: "stationName contains[c] %@", stationName)
        fetchRequest.predicate = perdicate
        
        do {
            buttonStatus = try context.fetch(fetchRequest)
            return buttonStatus
        } catch {
            return buttonStatus
        }
    }
    
    func filterDataByHasFavoritedButton() -> [ButtonStatus]? {
        let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<ButtonStatus> = ButtonStatus.fetchRequest()
        var buttonStatus: [ButtonStatus]? = nil
        
        let perdicate = NSPredicate(format: "hasFavorited == YES")
        fetchRequest.predicate = perdicate
        
        do {
            buttonStatus = try context.fetch(fetchRequest)
            return buttonStatus
        } catch {
            return buttonStatus
        }
    }
    
    func filterDataByStationId(stationId: Int16) -> [ButtonStatus]? {
        let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<ButtonStatus> = ButtonStatus.fetchRequest()
        var buttonStatus: [ButtonStatus]? = nil
        
        let perdicate = NSPredicate(format: "stationId == \(stationId)")
        fetchRequest.predicate = perdicate
        
        do {
            buttonStatus = try context.fetch(fetchRequest)
            return buttonStatus
        } catch {
            return buttonStatus
        }
    }
    
    
    func updateButtonStatus(by stationId: Int16) {
        let firstdata = filterDataByStationId(stationId: stationId)?.first
        let buttonStatus = firstdata?.hasFavorited
        firstdata?.hasFavorited = !buttonStatus!
        do {
            try CoreDataStack.sharedInstance.persistentContainer.viewContext.save()
        } catch let error {
            print(error)
        }
        print("選擇 ID:\(stationId) ButtonStatus: \(String(describing: firstdata?.hasFavorited))")
    }
    
    func createButtonStatusEntityFrom(stationInfo: StationInfo) -> NSManagedObject? {
        let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
        if let buttonStatusEntity = NSEntityDescription.insertNewObject(forEntityName: "ButtonStatus", into: context) as? ButtonStatus {
            buttonStatusEntity.stationId = Int16(stationInfo.id!)
            buttonStatusEntity.stationName = stationInfo.sna!
            buttonStatusEntity.hasFavorited = false
            return buttonStatusEntity
        }
        return nil
    }
    
    func saveInCoreDataWith(sortedArrayById: [StationInfo]) {
        if sortedArrayById.count > 0 && (self.fetchObject()?.count) == nil {
            let clearDataSuccess = clearData()
            print("clearDataSuccess:",clearDataSuccess)
            _ = sortedArrayById.map({ self.createButtonStatusEntityFrom(stationInfo: $0) })
            
            do {
                try CoreDataStack.sharedInstance.persistentContainer.viewContext.save()
            } catch let error {
                print(error)
            }
            
            var printButtonStatus: [ButtonStatus]? = nil
            printButtonStatus = self.fetchObject()
            _ = printButtonStatus!.map({print("corddata = nil迴圈",$0.stationId, $0.stationName!, $0.hasFavorited)})
            print(self.fetchObject()!.count)
            
        } else if sortedArrayById.count > 0 && (self.fetchObject()?.count)! < sortedArrayById.count {
            
            var stationNames: [String] = []
            _ = self.fetchObject()!.map{ stationNames.append($0.stationName!) }
            let filterStationInfoArray = sortedArrayById.filter({ !stationNames.map{ $0 }.contains($0.sna) })
            _ = filterStationInfoArray.map({ self.createButtonStatusEntityFrom(stationInfo: $0) })
            do {
                try CoreDataStack.sharedInstance.persistentContainer.viewContext.save()
            } catch let error {
                print(error)
            }
            
            var printButtonStatus: [ButtonStatus]? = nil
            printButtonStatus = self.fetchObject()
            _ = printButtonStatus!.map({print("coredata > download迴圈",$0.stationId, $0.stationName!, $0.hasFavorited)})
            print(self.fetchObject()!.count)
            
        } else if sortedArrayById.count > 0 && (self.fetchObject()?.count)! > sortedArrayById.count {
            
            var stationNames: [String] = []
            _ = self.fetchObject()!.map{ stationNames.append($0.stationName!) }
            
            let filterstationNamesArray = stationNames.filter({ !sortedArrayById.map({ $0.sna}).contains($0) })
            
            _ = filterstationNamesArray.map({ self.deleteObject(buttonStatus: (self.filterDataByStationName(stationName: $0)?.first)!) })
            
            var printButtonStatus: [ButtonStatus]? = nil
            printButtonStatus = self.fetchObject()
            _ = printButtonStatus!.map({print("coredata > download迴圈",$0.stationId, $0.stationName!, $0.hasFavorited)})
            print(self.fetchObject()!.count)
        } else {
            var printButtonStatus: [ButtonStatus]? = nil
            printButtonStatus = self.fetchObject()
            _ = printButtonStatus!.map({print("else迴圈",$0.stationId, $0.stationName!, $0.hasFavorited)})
            print(self.fetchObject()!.count)
            
        }
    }
}
