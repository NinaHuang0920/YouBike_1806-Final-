//
//  MapViewCell.swift
//  YouBike_1806
//
//  Created by 黃玉玲 on 2018/6/21.
//  Copyright © 2018年 CheshireCat. All rights reserved.
//

import UIKit
import MapKit

class MapViewBaseCell: BaseCell {
    
    var mapViewItem:Int = 0 {
        didSet {
            print("mapViewItem 監測值", mapViewItem)
        }
    }
    var mapBarItem:Int = 0 {
        didSet {
            print("mapBarItem 監測值",mapBarItem)
        }
    }
    
    let cellItem = 0
    
    var mapViewController: MapViewController?
    var mapBarSelectedView: MapBarSelectedView?
    
    var currentCoordinate: CLLocationCoordinate2D!
//    let locationManager = CLLocationManager()   //UL
    var selectedPinLocation: CLLocationCoordinate2D!
    var arrAnnotation = [MKPointAnnotation]()
    
    lazy var mapView: MKMapView = {
        let mapv = MKMapView()
        mapv.showsUserLocation = true
        mapv.isZoomEnabled = true
        mapv.isScrollEnabled = true
        mapv.delegate = self
        mapv.showsCompass = true
        return mapv
    }()
    
    lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.requestWhenInUseAuthorization()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        manager.startUpdatingLocation()
        return manager
    }()
    
    lazy var searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.delegate = self
        sb.placeholder = "搜尋站點"
        return sb
    }()
    
    lazy var mapDataUpdateButton: UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.backgroundColor = .black
        btn.setTitle("更新資訊", for: UIControlState.normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.layer.cornerRadius = 3
        btn.addTarget(self, action: #selector(handleMapUpdate), for: UIControlEvents.touchUpInside)
        return btn
    }()
    
    let alertView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth*0.8, height: screenHeight*0.3))
        view.backgroundColor = UIColor(white: 0.15, alpha: 0.95)
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 5
        view.layer.borderColor = UIColor.orange.cgColor
        view.layer.masksToBounds = true
        return view
    }()
    
    let cancelButton: UIButton = {
        let btn = UIButton(type: UIButtonType.system)
        btn.setImage(#imageLiteral(resourceName: "cross").withRenderingMode(UIImageRenderingMode.alwaysOriginal), for: .normal)
        return btn
    }()
    
    let alertLabel: UILabel = {
        let lb = UILabel()
        lb.text = "資料更新成功"
        lb.textColor = UIColor.orange
        lb.font = UIFont.boldSystemFont(ofSize: 28)
        lb.textAlignment = .center
        lb.adjustsFontSizeToFitWidth = true
        lb.numberOfLines = 2
        return lb
    }()
    
    override func setupViews() {
        super.setupViews()
        
        SetService()
        setupSearchBar()
        setupMap()
        setupUserTrackingButtonAndScaleView()
        setPinToMap()
        setUpdateButton()
    }
    
    func setUpdateButton() {
        mapView.addSubview(mapDataUpdateButton)
        mapDataUpdateButton.anchor(top: mapView.topAnchor, left: mapView.leftAnchor, bottom: nil, right: nil, topConstant: 5, leftConstant: 5, bottomConstant: 0, rightConstant: 0, widthConstant: screenWidth*0.22, heightConstant: 0)
    }
    
    @objc func handleMapUpdate() {
        SetService()
        perform(#selector(handleNetWorkStatus), with: self, afterDelay: 1)
    }
    
    func showAlertView(mapNetworkCheck: Bool) {
        addSubview(alertView)
        alertView.addSubview(alertLabel)
        alertView.addSubview(cancelButton)
        alertView.center = CGPoint(x: frame.width/2, y: frame.height/2)
        alertLabel.anchor(top: alertView.topAnchor, left: alertView.leftAnchor, bottom: alertView.bottomAnchor, right: alertView.rightAnchor, topConstant: 60, leftConstant: 60, bottomConstant: 60, rightConstant: 60, widthConstant: 0, heightConstant: 0)
        cancelButton.anchor(top: alertView.topAnchor, left: nil, bottom: nil, right: alertView.rightAnchor, topConstant: -10, leftConstant: 0, bottomConstant: 0, rightConstant: -10, widthConstant: 60, heightConstant: 60)
        cancelButton.addTarget(self, action: #selector(handleCancelBtn), for: .touchUpInside)
        if mapNetworkCheck == false {
            alertLabel.text = "請確認網路"
        } else if mapNetworkCheck == true {
            alertLabel.text = "資料下載完成"
        }
    }
    
    @objc func handleCancelBtn() {
        alertView.removeFromSuperview()
    }
    
    @objc func handleNetWorkStatus() {
        showAlertView(mapNetworkCheck: mapNetworkCheck)
        if mapNetworkCheck == false {
            alertLabel.text = "更新失敗\n請確認網路"
        } else if mapNetworkCheck == true {
            alertLabel.text = "資料更新完畢"
        }
    }

    func SetService() {
        Service.sharedInstance.fetchJsonData(urlString: webString, completion: { (bikeinfos, err) in
            if let err = err {
                print("MapViewCell error fetching json:", err)
            }
            if let bikeinfos = bikeinfos {
                bikeDatas = bikeinfos
                self.setPinToMap()
                mapNetworkCheck = true
            }
            DispatchQueue.main.async {
                self.mapView.updateConstraints()
                self.mapViewController?.collectionView?.reloadData()
                self.showAlertView(mapNetworkCheck: mapNetworkCheck)
            }
        })
    }
    
    func setupSearchBar() {
        addSubview(searchBar)
        searchBar.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 56)
    }

    func setupMap()  {
        addSubview(mapView)
        mapView.anchor(top: searchBar.bottomAnchor, left: searchBar.leftAnchor, bottom: bottomAnchor, right: searchBar.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
//        mapView.showsUserLocation = true
//        mapView.isZoomEnabled = true
//        mapView.isScrollEnabled = true
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
//        locationManager.startUpdatingLocation()
        
    }
    
    func setupUserTrackingButtonAndScaleView() {
        mapView.showsUserLocation = true
        
        let button = MKUserTrackingButton(mapView: mapView)
        button.layer.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0).cgColor
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        addSubview(button)
        
        let scale = MKScaleView(mapView: mapView)
        scale.legendAlignment = .trailing
        scale.translatesAutoresizingMaskIntoConstraints = false
        addSubview(scale)
        
        NSLayoutConstraint.activate([button.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10),button.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -10),scale.trailingAnchor.constraint(equalTo: button.safeAreaLayoutGuide.leadingAnchor, constant: -10),scale.centerYAnchor.constraint(equalTo: button.safeAreaLayoutGuide.centerYAnchor)])
    }
    
    func setPinToMap() {
        showAlertView(mapNetworkCheck: mapNetworkCheck)
        arrAnnotation.removeAll()
        guard let bikeDataCount = bikeDatas?.count else { return }
        print("MAP PIN bikeDataCount",bikeDataCount)
        guard let bikeInfo = bikeDatas else { return }
        
        for item in 0 ..< bikeDataCount {
            let annottaion = MKPointAnnotation()
            annottaion.coordinate = bikeInfo[item].locate!
            annottaion.title = "\(bikeInfo[item].sna!)"
            annottaion.subtitle = "\(item)"
            arrAnnotation.append(annottaion)
        }
        
        self.mapView.addAnnotations(arrAnnotation)
        self.mapView.showAnnotations(arrAnnotation, animated: false)
        
        let viewRegion = MKCoordinateRegionMakeWithDistance(mapView.userLocation.coordinate,3000,3000)
        mapView.setRegion(viewRegion, animated: true)
        locationManager.startUpdatingHeading()
        
        mapView.updateConstraints()
        mapViewController?.collectionView?.reloadData()
    }
}

extension MapViewBaseCell: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        guard let currentLocation = locations.first else { return }
        currentCoordinate = currentLocation.coordinate
        mapView.userTrackingMode = .followWithHeading
    }
}

extension MapViewBaseCell: UISearchBarDelegate {

}

extension MapViewBaseCell: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        var view = mapView.dequeueReusableAnnotationView(withIdentifier: "Pin") as? MKPinAnnotationView
        if view == nil {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "Pin")
        }
        
        let index = Int((annotation.subtitle!)!)!

    
//        switch Int(bikeDatas![index!].sbi!)! {
//        case 0:
//            view?.pinTintColor = UIColor.red
//        case 1...3:
//            view?.pinTintColor = UIColor.purple
//        default:
//            view?.pinTintColor = UIColor.green
//        }
//        let label = UILabel()
//        label.numberOfLines = 3
//        let ar = bikeDatas![index!].ar!
//        let sbi = bikeDatas![index!].sbi!
//        let bemp = bikeDatas![index!].bemp!
//        var lblText:String
//        lblText = "\(ar)"
//        lblText += "\n🚲 有\(sbi)台"
//        lblText += "\n🅿️ 有\(bemp)格"
//        label.text = lblText
//        view?.detailCalloutAccessoryView = label
//        view?.canShowCallout = true

        view?.setupPinCalloutView(index: index, cellItem: cellItem)
        
        return view
    }
    

    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
//        let pinView = view as! MKPinAnnotationView
//        pinView.pinTintColor = UIColor.blue
         selectedPinLocation = view.annotation!.coordinate
    }
//    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
//        let pinView = view as! MKPinAnnotationView
//        let index = Int((view.annotation?.subtitle!)!)
//        switch Int(bikeDatas![index!].sbi!)! {
//        case 0:
//            pinView.pinTintColor = UIColor.red
//        case 1...3:
//            pinView.pinTintColor = UIColor.purple
//        default:
//            pinView.pinTintColor = UIColor.green
//        }
//    }

}

extension MKPinAnnotationView {
    func setupPinCalloutView(index: Int, cellItem: Int) {

        pinTintColor = setPinColor(annSubTitle: index, cellItem: cellItem)

        let label = UILabel()
        label.numberOfLines = 3
        let ar = bikeDatas![index].ar!
        let sbi = bikeDatas![index].sbi!
        let bemp = bikeDatas![index].bemp!
        var lblText:String
        lblText = "\(ar)"
        lblText += "\n🚲 有\(sbi)台"
        lblText += "\n🅿️ 有\(bemp)格"
        label.text = lblText
        label.adjustsFontSizeToFitWidth = true
//        label.backgroundColor = UIColor(white: 0.5, alpha: 0.5)

        detailCalloutAccessoryView = label
        canShowCallout = true
    }

    func setPinColor(annSubTitle: Int, cellItem: Int) -> UIColor {
        let index = annSubTitle
        let color: UIColor
        let mapFunction: Int

        switch cellItem {
        case 1:
            mapFunction = Int(bikeDatas![index].bemp!)!
        default:
            mapFunction = Int(bikeDatas![index].sbi!)!
        }
        if bikeDatas![index].act == "0" {
            color = UIColor.gray
        } else {
            switch mapFunction {
            case 0:
                color = UIColor.red
            case 1...9:
                color = UIColor.orange
            default:
                color = UIColor.green
            }
        }
        return color
    }
}


/*
class TestAnnotations: MKPinAnnotationView ,  UISearchBarDelegate {
    
    var ccellItem:Int
    
    init(ccellItem: Int, annotatio: MKAnnotation?, reuseIdentifier: String?) {
        self.ccellItem = ccellItem
        super.init(annotation: nil, reuseIdentifier: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        var view = mapView.dequeueReusableAnnotationView(withIdentifier: "Pin") as? MKPinAnnotationView
        if view == nil {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "Pin")
        }
        let index = Int((annotation.subtitle!)!)!
        
        //        print("PIN 監測 mapBarItem", mapBarItem)// not work well
//        view?.setupPinCalloutView(index: index!, cellItem: mapBarItem)
        
        view?.pinTintColor = ssetPinColor(annSubTitle: index, cellItem: ccellItem)
        
        let label = UILabel()
        label.numberOfLines = 3
        let ar = bikeDatas![index].ar!
        let sbi = bikeDatas![index].sbi!
        let bemp = bikeDatas![index].bemp!
        var lblText:String
        lblText = "\(ar)"
        lblText += "\n🚲 有\(sbi)台"
        lblText += "\n🅿️ 有\(bemp)格"
        label.text = lblText
        view?.detailCalloutAccessoryView = label
        view?.canShowCallout = true
        
        return view
    }
    
//    func setupPinCalloutView(index: Int, cellItem: Int) {
//        
//        pinTintColor = setPinColor(annSubTitle: index, cellItem: cellItem)
//        
//        let label = UILabel()
//        label.numberOfLines = 3
//        let ar = bikeDatas![index].ar!
//        let sbi = bikeDatas![index].sbi!
//        let bemp = bikeDatas![index].bemp!
//        var lblText:String
//        lblText = "\(ar)"
//        lblText += "\n🚲 有\(sbi)台"
//        lblText += "\n🅿️ 有\(bemp)格"
//        label.text = lblText
//        detailCalloutAccessoryView = label
//        canShowCallout = true
//    }
    
    internal func ssetPinColor(annSubTitle: Int, cellItem: Int) -> UIColor {
        let index = annSubTitle
        let color: UIColor
        let mapFunction: Int
        
        switch cellItem {
        case 1:
            mapFunction = Int(bikeDatas![index].bemp!)!
        default:
            mapFunction = Int(bikeDatas![index].sbi!)!
        }
        if bikeDatas![index].act == "0" {
            color = UIColor.gray
        } else {
            switch mapFunction {
            case 0:
                color = UIColor.red
            case 1...9:
                color = UIColor.orange
            default:
                color = UIColor.green
            }
        }
        return color
    }
}*/
