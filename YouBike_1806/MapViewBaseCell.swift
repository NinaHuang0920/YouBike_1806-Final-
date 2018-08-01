//
//  MapViewCell.swift
//  YouBike_1806
//
//  Created by 黃玉玲 on 2018/6/21.
//  Copyright © 2018年 CheshireCat. All rights reserved.
//

import UIKit
import MapKit

//protocol MapViewCellDelegate {
//    func updateStatusAlert(status updateSuccess: Bool)
//}

let updateMapViewNotificationKey = "com.smilec.updateMapViewData"
let removeMapViewNotificationKey = "com.smilec.removeMapViewData"


var arrAnnotation = [MKAnnotation]()

class MapViewBaseCell: BaseCell {
    
    let updateMapDataFromMapViewController = Notification.Name(rawValue: updateMapViewNotificationKey)
    let removeMapDataFromMapView = Notification.Name(rawValue: removeMapViewNotificationKey)
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
//    let locationService: LocationService
//
//    init(locationService: LocationService) {
//        self.locationService = locationService
//        super.init(frame: .zero)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    

    let cellItem = 0
//    var mapViewCellDelegate: MapViewCellDelegate?
    
    var mapViewController: MapViewController?
//    lazy var mapViewController: MapViewController = {
//        let mvc = MapViewController()
//        mvc.mapViewBaseCell = self
//        return mvc
//    }()
    
    var currentCoordinate: CLLocationCoordinate2D!
    var selectedPinLocation: CLLocationCoordinate2D!
    
    lazy var mapView: MKMapView = {
        let mapv = MKMapView()
        mapv.showsUserLocation = true
        mapv.isZoomEnabled = true
        mapv.isScrollEnabled = true
        mapv.delegate = self
        mapv.showsCompass = false
//        mapv.showsScale = true
        return mapv
    }()
    
//    lazy var locationManager: CLLocationManager = {
//        let manager = CLLocationManager()
//        manager.requestWhenInUseAuthorization()
//        manager.delegate = self
//        manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
//        manager.startUpdatingLocation()
//        return manager
//    }()
    
//    lazy var mapDataUpdateButton: UIButton = {
//        let btn = UIButton(type: UIButtonType.custom)
//        btn.backgroundColor = mapBarColorBlue
//        btn.setTitle("更新", for: UIControlState.normal)
//        btn.setTitleColor(UIColor.white, for: .normal)
//        btn.layer.cornerRadius = 3
//        btn.addTarget(self, action: #selector(handleMapUpdate), for: UIControlEvents.touchUpInside)
//        return btn
//    }()
    let networkMessageView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth*0.8, height: screenHeight*0.3))
        view.backgroundColor = UIColor(white: 1, alpha: 0.9)
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.masksToBounds = true
        return view
    }()
    let networkMessageLabel: UILabel = {
        let lb = UILabel()
        lb.text = "資料更新成功"
        lb.textColor = UIColor.black
        lb.font = UIFont.boldSystemFont(ofSize: 24)
        lb.textAlignment = .center
        lb.adjustsFontSizeToFitWidth = true
        lb.numberOfLines = 2
        return lb
    }()
    let dividerLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        return view
    }()
    
    let networkMessageCancelButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("確定", for: .normal)
        btn.setTitleColor(UIColor.blue, for: .normal)
        btn.tintColor = UIColor.blue
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        return btn
    }()
    
    let updateTimeLabel: UILabel = {
        let lb = UILabel()
        lb.text = "更新時間: 00:00 "
        lb.textColor = UIColor.black
        lb.backgroundColor = UIColor(white: 0.95, alpha: 0.3)
        lb.font = UIFont.boldSystemFont(ofSize: 14)
        lb.textAlignment = .left
        lb.adjustsFontSizeToFitWidth = true
        return lb
    }()
    
//    lazy var activityIndicatorContainor: UIView = {
//        let container = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
//        container.center = CGPoint(x: frame.width/2, y: frame.height/2)
//        container.backgroundColor = UIColor(white: 0.1, alpha: 0.1)
//        return container
//    }()
    
    lazy var loadingView: UIView = {
        let loadingView = UIView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        loadingView.center = CGPoint(x: frame.width/2, y: frame.height/2)
        loadingView.backgroundColor = UIColor(white: 0.4, alpha: 0.7)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        return loadingView
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let act = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        act.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2)
        return act
    }()

    
    override func setupViews() {
        super.setupViews()
        
        LocationService.sharedInstance.requestWhenInUseAuthorization()
//        SetService()

        
        SetMapService.sharedInstance.setMapService(mapView: mapView, mapViewController: self.mapViewController, setPinToMapCompletion: {
            SetPinToMap.sharedInstance.setPinToMap(arrAnnotation: arrAnnotation, in: self.mapView, at: self.mapViewController)
        }, messageblock: {
             self.showNetworkMessageView(mapNetworkCheck: mapNetworkCheck)
        })
        
        setupMap()
        setupActivityIndicator()
        setupToolButtonAndScaleView()
//        setUpdateButton()
        setUpdateTimeLabel() 
        createObservers()
        
    }
    func createObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateMapData(notification:)), name: updateMapDataFromMapViewController, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(removeMapView(notification:)), name: removeMapDataFromMapView, object: nil)
    }
    
    @objc func removeMapView(notification: NSNotification) {
        networkMessageView.removeFromSuperview()
    }
    
    @objc func updateMapData(notification: NSNotification) {
        SetMapService.sharedInstance.setMapService(mapView: mapView, mapViewController: self.mapViewController, setPinToMapCompletion: {
            SetPinToMap.sharedInstance.setPinToMap(arrAnnotation: arrAnnotation, in: self.mapView, at: self.mapViewController)
        }, messageblock: {
            self.showNetworkMessageView(mapNetworkCheck: mapNetworkCheck)
        })
    }
    
    func setupActivityIndicator() {
        mapView.addSubview(loadingView)
        loadingView.addSubview(activityIndicator)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
    }
    
    func showTimeLabel() {
        
        if bikeDatas.count > 1 {
            self.updateTimeLabel.text = TimeHelper.showUpdateTime(timeString: bikeDatas[0].mday!)
        } else {
            self.updateTimeLabel.text = "無法更新時間"
        }
    }

    func setUpdateTimeLabel() {
        mapView.addSubview(updateTimeLabel)
        updateTimeLabel.anchor(top: mapView.topAnchor, left:  mapView.leftAnchor, bottom: nil, right: nil, topConstant: 2, leftConstant: 12, bottomConstant: 0, rightConstant: 0, widthConstant: 200, heightConstant: 20)
    }
    
//    func setUpdateButton() {
//        mapView.addSubview(updateTimeLabel)
//        mapView.addSubview(mapDataUpdateButton)
//        updateTimeLabel.anchor(top: mapView.topAnchor, left:  mapView.leftAnchor, bottom: nil, right: nil, topConstant: 2, leftConstant: 12, bottomConstant: 0, rightConstant: 0, widthConstant: 200, heightConstant: 20)
//        mapDataUpdateButton.anchor(top: updateTimeLabel.bottomAnchor, left: mapView.leftAnchor, bottom: nil, right: nil, topConstant: 2, leftConstant: 12, bottomConstant: 0, rightConstant: 0, widthConstant: 65, heightConstant: 38)
//    }
    
//    @objc func handleMapUpdate() {
//
//        setupActivityIndicator()
//        LocationService.sharedInstance.stopUpdatingLocation()
//
//        SetMapService.sharedInstance.setMapService(mapView: mapView, mapViewController: self.mapViewController, setPinToMapCompletion: {
//            SetPinToMap.sharedInstance.setPinToMap(arrAnnotation: arrAnnotation, in: self.mapView, at: self.mapViewController)
//        }, messageblock: {
//            self.showNetworkMessageView(mapNetworkCheck: mapNetworkCheck)
//        })
//
//    }
    
    func showNetworkMessageView(mapNetworkCheck: Bool) {
       
        if mapNetworkCheck == false {
            networkMessageLabel.text = "請確認網路"
        } else if mapNetworkCheck == true {
            networkMessageLabel.text = "資料下載完成"
        }
        
        UIView.animate(withDuration: 1.5, delay: 0.1, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.activityIndicator.stopAnimating()
            self.showTimeLabel()
            self.networkMessageView.removeFromSuperview()
        }) { (_) in
            self.loadingView.removeFromSuperview()
            self.setupNetworkMessageView()
        }
    }
    
    func setupNetworkMessageView() {
        addSubview(networkMessageView)
        networkMessageView.addSubview(networkMessageLabel)
        networkMessageView.addSubview(dividerLineView)
        networkMessageView.addSubview(networkMessageCancelButton)
        
        networkMessageView.center = CGPoint(x: frame.width/2, y: frame.height/2)
        
        networkMessageLabel.anchor(top: networkMessageView.topAnchor, left: networkMessageView.leftAnchor, bottom: nil, right: networkMessageView.rightAnchor, topConstant: 0, leftConstant: 60, bottomConstant: 0, rightConstant: 60, widthConstant: 0, heightConstant: networkMessageView.bounds.height*0.65)
        
        dividerLineView.anchor(top: networkMessageLabel.bottomAnchor, left: networkMessageView.leftAnchor, bottom: nil, right: networkMessageView.rightAnchor, topConstant: 0, leftConstant: 1, bottomConstant: 0, rightConstant: 1, widthConstant: 0, heightConstant: 0.2)
        
        networkMessageCancelButton.anchor(top: dividerLineView.bottomAnchor, left: networkMessageView.leftAnchor, bottom: networkMessageView.bottomAnchor, right: networkMessageView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        networkMessageCancelButton.addTarget(self, action: #selector(handleNetworkMessageViewCancelBtn), for: .touchUpInside)
    }
    
    @objc func handleNetworkMessageViewCancelBtn() {
        networkMessageView.removeFromSuperview()
    }

//    func SetMapService(completion: @escaping () -> ()) {
////        bikeDatas = []
////        arrAnnotation = []
////        self.mapView.removeAnnotations(self.mapView.annotations)
//
//        Service.sharedInstance.fetchJsonData(urlString: webString, completion: { (bikeinfos, err) in
//
//            if let err = err {
//                mapNetworkCheck = false
//                print("MapViewCell 偵測網路沒開：",err.localizedDescription)
//                self.showNetworkMessageView(mapNetworkCheck: false)
////                self.setPinToMap()
//                completion()
//            }
//
//            guard let bikeinfos = bikeinfos else { return }
//            bikeDatas = bikeinfos //
//
//            let pointAnnotation = bikeinfos.map{ PointAnnotation(bikeStationInfo: $0)} //
//            print(pointAnnotation.count)
//            print("SetService大頭針數量",arrAnnotation.count)
//             completion()
////            self.setPinToMap()
//            mapNetworkCheck = true //
//            print("SetSerivce 呼叫成功",bikeDatas.count)
//
//            DispatchQueue.main.async {
//                self.mapView.updateConstraints() //
//                self.mapViewController?.collectionView?.reloadData() //
//            }
//            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1.5) {
//                self.showNetworkMessageView(mapNetworkCheck: mapNetworkCheck) //
//            }
//        })
//    }

    func setupMap()  {
        addSubview(mapView)
        mapView.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    func setupToolButtonAndScaleView() {
        mapView.showsUserLocation = true
        
        let trackingButton = MKUserTrackingButton(mapView: mapView)
        trackingButton.layer.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0).cgColor
        trackingButton.layer.borderColor = UIColor.white.cgColor
        trackingButton.layer.borderWidth = 1
        trackingButton.layer.cornerRadius = 5
        trackingButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(trackingButton)
        
        let scale = MKScaleView(mapView: mapView)
        scale.scaleVisibility = .visible
        scale.legendAlignment = .leading
        scale.translatesAutoresizingMaskIntoConstraints = false
        addSubview(scale)
        
        let compassButton = MKCompassButton(mapView: mapView)
        compassButton.compassVisibility = .visible
        compassButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(compassButton)
        
        NSLayoutConstraint.activate(
            [trackingButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10),
             trackingButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -10),
             scale.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 10),
             scale.centerYAnchor.constraint(equalTo: trackingButton.safeAreaLayoutGuide.centerYAnchor),
             compassButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 7),
             compassButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -7)])
    }
    
//    func setPinToMap(arrAnnotation: [MKAnnotation], in mapView: MKMapView, at mapViewController: UICollectionViewController? ) {
//
////         self.mapView.removeAnnotations(self.mapView.annotations)
//        
////        arrAnnotation = []
////        let bikeDataCount = bikeDatas.count
////        print("MAP PIN bikeDataCount",bikeDataCount)
////        for item in 0 ..< bikeDataCount {
////            let annottaion = MKPointAnnotation()
////            annottaion.coordinate = bikeDatas[item].locate!
////            annottaion.title = "\(bikeDatas[item].sna!)"
////            annottaion.subtitle = "\(bikeDatas[item].id!-1)"
////            arrAnnotation.append(annottaion)
////        }
////        print(arrAnnotation[1].title)
//        
//        print("setPinToMap大頭針數量",arrAnnotation.count)
//        mapView.addAnnotations(arrAnnotation)
//        mapView.showAnnotations(arrAnnotation, animated: false)
//        
//        let viewRegion = MKCoordinateRegionMakeWithDistance(mapView.userLocation.coordinate,3000,3000)
//        mapView.setRegion(viewRegion, animated: true)
////        locationManager.startUpdatingHeading()
//        LocationService.sharedInstance.startUpdatingHeading()
//        mapView.updateConstraints()
//        mapViewController?.collectionView?.reloadData()
//    }
}

//extension MapViewBaseCell: CLLocationManagerDelegate {
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        manager.stopUpdatingLocation()
//        guard let currentLocation = locations.first else { return }
//        currentCoordinate = currentLocation.coordinate
//        mapView.userTrackingMode = .followWithHeading
//    }
//}

extension MapViewBaseCell: LocationServiceDelegate {
 
    func tracingLocation(currentLocation: CLLocation) {
        LocationService.sharedInstance.stopUpdatingLocation()
        mapView.userTrackingMode = .followWithHeading
    }

    func tracingLocationDidFailWithError(error: Error) {
        print("Location Error:",error)

        self.networkMessageLabel.text = "使用者位置偵測錯誤\n請重開應用程式"
        self.setupNetworkMessageView()
    }
    
//    func tracingLocationDidChangeAuthorization(status: CLAuthorizationStatus) {
////        if status == .authorizedWhenInUse {
////            LocationService.sharedInstance.requestLocation()
////        }
//    }
//    
//    func showOpenAuM(bool: Bool) {
//        self.networkMessageLabel.text = "測試"
//        self.setupNetworkMessageView()
//    }
}

extension MapViewBaseCell: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation { return nil }
        var view = mapView.dequeueReusableAnnotationView(withIdentifier: "Pin") as? MKPinAnnotationView
        
        if view == nil {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "Pin")
        }
        view?.detailCalloutAccessoryView?.removeFromSuperview()
        let index = Int((annotation.subtitle!)!)!
        view?.setupPinCalloutView(index: index, cellItem: cellItem)
        view?.rightCalloutAccessoryView = setupMapNavButton()
        
        return view
    }
    
    func setupMapNavButton() -> UIButton {
        let navButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 50))
        let navImage = #imageLiteral(resourceName: "pin").withRenderingMode(.alwaysTemplate)
        let buttonImage: UIImageView = UIImageView(image: navImage)
        buttonImage.tintColor = mapBarColorBlue
        navButton.setImage(buttonImage.image, for: .normal)
        navButton.addTarget(self, action: #selector(handleNavButton), for: .touchUpInside)

        return navButton
    }
    
    @objc func handleNavButton() {

        let currentMapItem = MKMapItem.forCurrentLocation()
        let markDestination = MKPlacemark(coordinate: selectedPinLocation)
        let destMapItem = MKMapItem(placemark: markDestination)
        destMapItem.name = "導航終點"
//        destMapItem.phoneNumber = "123456789"

        let arrNavi = [currentMapItem,destMapItem]
        let optionNavi = [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeWalking]
        MKMapItem.openMaps(with: arrNavi, launchOptions: optionNavi)
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let pinView = view as! MKPinAnnotationView
        pinView.pinTintColor = UIColor.blue
         selectedPinLocation = view.annotation!.coordinate
    }
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        let pinView = view as! MKPinAnnotationView
        let index = Int((view.annotation?.subtitle!)!)!
        pinView.pinTintColor = pinView.setPinColor(annSubTitle: index, cellItem: cellItem)
    }
}

extension MKPinAnnotationView {
    func setupPinCalloutView(index: Int, cellItem: Int) {

        pinTintColor = setPinColor(annSubTitle: index, cellItem: cellItem)

        let label = UILabel()
        label.numberOfLines = 3
        let ar = bikeDatas[index].ar!
        let sbi = bikeDatas[index].sbi!
        let bemp = bikeDatas[index].bemp!
        let time = TimeHelper.showUpdateTime(timeString: bikeDatas[index].mday!)
        
        let attributedText = NSMutableAttributedString(string: "\(ar)\n", attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "🚲： \(sbi)        🅿️： \(bemp)\n", attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 18), NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.3176470697, green: 0.07450980693, blue: 0.02745098062, alpha: 1)]))
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        let range = NSRange(location: 0, length: attributedText.string.count)
        attributedText.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: range)
        attributedText.append(NSAttributedString(string: time, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 12), NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)]))
        
        label.attributedText = attributedText
        label.adjustsFontSizeToFitWidth = true
        detailCalloutAccessoryView = label

        canShowCallout = true
    }
   

    
    func setPinColor(annSubTitle: Int, cellItem: Int) -> UIColor {
        let index = annSubTitle
        var color: UIColor = .red
        let mapFunction: Int

            switch cellItem {
            case 0: mapFunction = Int(bikeDatas[index].sbi!)!
            case 1: mapFunction = Int(bikeDatas[index].bemp!)!
            default: mapFunction = 0
                
            }
            if bikeDatas[index].act == "0" {
                color = cellItem == 0 ? UIColor.lightGray : UIColor.darkGray
            } else {
                switch mapFunction {
                case 0:
                    color = cellItem == 0 ? redColorWithAlpha : redColor
                case 1...9:
                    color = cellItem == 0 ? orangeColorWithAlpha : orangeColor
                default:
                    color = cellItem == 0 ? greenColorWithAlpha : greenColor
                }
            }
        
        return color
    }
}
