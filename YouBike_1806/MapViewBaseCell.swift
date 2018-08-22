//
//  MapViewCell.swift
//  YouBike_1806
//
//  Created by 黃玉玲 on 2018/6/21.
//  Copyright © 2018年 CheshireCat. All rights reserved.
//

import UIKit
import MapKit

let updateMapViewNotificationKey = "com.smilec.updateMapViewData"
let removeAnnotationsNotificationKey = "com.smilec.removeAnnotations"
let mapChangeNotificationKey = "com.smilec.mapChange"
let moveToSelectedPinNotificationKey =  "com.smilec.moveToSelectedPin"

var arrAnnotation = [MKAnnotation]()
var selectedPin: MKAnnotation?

class MapViewBaseCell: BaseCell {

    let updateMapDataFromMapViewController = Notification.Name(rawValue: updateMapViewNotificationKey)
    let showNetworkAlert = Notification.Name(rawValue: showNetworkAlertNotificationKey)
    let removeAnnotationstNotification = Notification.Name(rawValue: removeAnnotationsNotificationKey)
    let mapChangeNotification = Notification.Name(rawValue: mapChangeNotificationKey)
    let moveToSelectedPinNotification = Notification.Name(rawValue: moveToSelectedPinNotificationKey)
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    let cellItem = 0
    
    var mapViewController: MapViewController?
    
//    var currentCoordinate: CLLocationCoordinate2D?
    var selectedPinLocation: CLLocationCoordinate2D?
    
    lazy var mapView: MKMapView = {
        let mapv = MKMapView()
        mapv.showsUserLocation = true
        mapv.isZoomEnabled = true
        mapv.isScrollEnabled = true
        mapv.delegate = self
        mapv.showsCompass = false
        return mapv
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
        
//        LocationService.sharedInstance.requestWhenInUseAuthorization()
        
        GetService.sharedInstance.getMapService(setPinToMapCompletion: {
            SetPinToMap.sharedInstance.setPinToMap(arrAnnotation: arrAnnotation, in: self.mapView, at: self.mapViewController)
        }, messageblock: {
            Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { (_) in
                self.activityIndicator.stopAnimating()
                self.showTimeLabel()
                self.loadingView.removeFromSuperview()
            })
//             self.showNetworkAlert(mapNetworkCheck: mapNetworkCheck)
        })
        
        setupMap()
        setupActivityIndicator()
        setupMapTools()
        setUpdateTimeLabel()
        createObservers()

    }
    
//    var showCollout: Bool = true
    
    func createObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateMapData(notification:)), name: updateMapDataFromMapViewController, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(removeAnnotations(notification:)), name: removeAnnotationstNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateMapData(notification:)), name: mapChangeNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(moveToSelectedPint(notification:)), name: moveToSelectedPinNotification, object: nil)
    }

    @objc func moveToSelectedPint(notification: NSNotification) {
        guard let selectedPinCoordinate = selectedPin?.coordinate else { return }
        updateMapToSelectedPin(latitude: selectedPinCoordinate.latitude, longitude: selectedPinCoordinate.longitude)
    }
    func updateMapToSelectedPin(latitude: CLLocationDegrees, longitude: CLLocationDegrees)  {
        
        let centerCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let region = MKCoordinateRegionMakeWithDistance(centerCoordinate, 200, 200)
        mapView.setRegion(region, animated: true)
    }
    
    @objc func removeAnnotations(notification: NSNotification) {
        print("remove前 mapView.annotations.count", mapView.annotations.count)
        print("remove前 arrAnnotation.count", arrAnnotation.count)
        mapView.removeAnnotations(mapView.annotations)
        mapView.removeAnnotations(arrAnnotation)
        
        print("remove後 mapView.annotations.count", mapView.annotations.count)
        print("remove後 arrAnnotation.count", arrAnnotation.count)
    }
    
    @objc func updateMapData(notification: NSNotification) {
        let isShowAlertBlock = notification.name == updateMapDataFromMapViewController
         self.activityIndicator.startAnimating()
        GetService.sharedInstance.getMapService(setPinToMapCompletion: {
            SetPinToMap.sharedInstance.setPinToMap(arrAnnotation: arrAnnotation, in: self.mapView, at: self.mapViewController)
        }, messageblock: {
            isShowAlertBlock ? self.showNetworkAlert(mapNetworkCheck: mapNetworkCheck) : nil
        })
    }

    func setupActivityIndicator() {
        self.mapView.addSubview(self.loadingView)
        self.loadingView.addSubview(self.activityIndicator)
        self.activityIndicator.hidesWhenStopped = true
        
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (timer) in
            self.activityIndicator.startAnimating()
        }
    }
    
    func showNetworkAlert(mapNetworkCheck: Bool) {
        
        UIView.animate(withDuration: 1.5, delay: 0.1, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.activityIndicator.stopAnimating()
            self.showTimeLabel()
        }) { (_) in
            self.loadingView.removeFromSuperview()
            NotificationCenter.default.post(name: self.showNetworkAlert, object: nil)
        }
    }
    func setUpdateTimeLabel() {
        mapView.addSubview(updateTimeLabel)
        updateTimeLabel.anchor(top: mapView.topAnchor, left:  mapView.leftAnchor, bottom: nil, right: nil, topConstant: 2, leftConstant: 12, bottomConstant: 0, rightConstant: 0, widthConstant: 200, heightConstant: 20)
    }
    func showTimeLabel() {
        if bikeDatas.count > 1 {
            self.updateTimeLabel.text = TimeHelper.showUpdateTime(timeString: bikeDatas[0].mday!)
        } else {
            self.updateTimeLabel.text = "無法更新時間"
        }
    }

    func setupMap()  {
        addSubview(mapView)
        mapView.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    func setupMapTools() {
        mapView.showsUserLocation = true

        let trackingButton = MKUserTrackingButton(mapView: mapView)
        trackingButton.layer.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0).cgColor
        trackingButton.layer.borderColor = UIColor.white.cgColor
        trackingButton.layer.borderWidth = 1
        trackingButton.layer.cornerRadius = 5
        trackingButton.translatesAutoresizingMaskIntoConstraints = false
        mapView.addSubview(trackingButton)

        let scale = MKScaleView(mapView: mapView)
        scale.scaleVisibility = .visible
        scale.legendAlignment = .leading
        scale.translatesAutoresizingMaskIntoConstraints = false
        mapView.addSubview(scale)

        let compassButton = MKCompassButton(mapView: mapView)
        compassButton.compassVisibility = .visible
        compassButton.translatesAutoresizingMaskIntoConstraints = false
        mapView.addSubview(compassButton)

        NSLayoutConstraint.activate(
            [trackingButton.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -10),
             trackingButton.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -10),
             scale.leadingAnchor.constraint(equalTo: mapView.leadingAnchor, constant: 10),
             scale.centerYAnchor.constraint(equalTo: trackingButton.centerYAnchor),
             compassButton.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 7),
             compassButton.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -7)])
    }
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
 
    func tracingDidUpdateLocation(currentLocation: CLLocation) {
        LocationService.sharedInstance.stopUpdatingLocation()
        mapView.userTrackingMode = .followWithHeading
    }

    func tracingLocationDidFailWithError(error: Error) {
        print("Location Error:",error)
    }
    
    func tracingLocationDidChangeAuthorization(status: CLAuthorizationStatus) {
//        if status == .authorizedWhenInUse {
//            LocationService.sharedInstance.requestLocation()
//        }
    }

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
        
//        view?.canShowCallout = showCollout
        
//         print("在BikeBaceCell看MapView的位置", mapView.self)
        
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
        let markDestination = MKPlacemark(coordinate: selectedPinLocation!)
        let destMapItem = MKMapItem(placemark: markDestination)
        destMapItem.name = "導航終點"
        let arrNavi = [currentMapItem,destMapItem]
        let optionNavi = [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeWalking]
        MKMapItem.openMaps(with: arrNavi, launchOptions: optionNavi)
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
         selectedPinLocation = view.annotation!.coordinate
        guard let userLocation = LocationService.sharedInstance.currentLocation?.coordinate else { return }
        if selectedPinLocation! == userLocation { return } else {
            let pinView = view as! MKPinAnnotationView
            pinView.pinTintColor = UIColor.blue
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        guard let userLocation = LocationService.sharedInstance.currentLocation?.coordinate else { return }
        if selectedPinLocation! == userLocation { return } else {
            let pinView = view as! MKPinAnnotationView
            let index = Int((view.annotation?.subtitle!)!)!
            pinView.pinTintColor = pinView.setPinColor(annSubTitle: index, cellItem: cellItem)
        }
    }
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        print("RegionWillChangeAnimated")
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        print("RegionDidChangeAnimated")
    }
    
}

extension CLLocationCoordinate2D {
//    func isEqual(object: Any) -> Bool {
//        if let coordinate = object as? CLLocationCoordinate2D { return self == coordinate }
//        return false
//    }
    //定義 == 可以做 CLLocationCoordinate2D 類別的比對 //上面的 extension CLLocationCoordinate2D 有用到
    static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        if abs(lhs.latitude - rhs.latitude) == 0.0 { return true }
        else if abs(lhs.longitude - rhs.longitude) > 0.0 { return false }
        return true
    }
}


extension MKPinAnnotationView {
    func setupPinCalloutView(index: Int, cellItem: Int) {

        pinTintColor = setPinColor(annSubTitle: index, cellItem: cellItem)

        guard bikeDatas.count > 0 else { return }
        
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

        guard bikeDatas.count > 0 else { return .red }
        
        let bikeCount = bikeDatas[index].sbi ?? "0"
        let parkCount = bikeDatas[index].bemp ?? "0"
        
            switch cellItem {
            case 0: mapFunction = Int(bikeCount)!
            case 1: mapFunction = Int(parkCount)!
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
