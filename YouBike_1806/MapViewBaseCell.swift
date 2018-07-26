//
//  MapViewCell.swift
//  YouBike_1806
//
//  Created by 黃玉玲 on 2018/6/21.
//  Copyright © 2018年 CheshireCat. All rights reserved.
//

import UIKit
import MapKit

protocol MapViewCellDelegate {
    func updateStatusAlert(status updateSuccess: Bool)
}


var arrAnnotation = [MKAnnotation]()

class MapViewBaseCell: BaseCell {
    
    let cellItem = 0
    var mapViewCellDelegate: MapViewCellDelegate?
    
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
    
    lazy var mapDataUpdateButton: UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.backgroundColor = mapBarColorBlue
        btn.setTitle("更新", for: UIControlState.normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.layer.cornerRadius = 3
        btn.addTarget(self, action: #selector(handleMapUpdate), for: UIControlEvents.touchUpInside)
        return btn
    }()
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
    
    override func setupViews() {
        super.setupViews()
        
        SetService()
        setupMap()
        setupUserTrackingButtonAndScaleView()
        setUpdateButton()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2) {
            self.updateTimeLabel.text = TimeHelper.showUpdateTime(timeString: bikeDatas[0].mday!)
        }
        
    }
    
    
    func setUpdateButton() {
        mapView.addSubview(updateTimeLabel)
        mapView.addSubview(mapDataUpdateButton)
        
        updateTimeLabel.anchor(top: mapView.topAnchor, left:  mapView.leftAnchor, bottom: nil, right: nil, topConstant: 2, leftConstant: 12, bottomConstant: 0, rightConstant: 0, widthConstant: 200, heightConstant: 20)
        
        mapDataUpdateButton.anchor(top: updateTimeLabel.bottomAnchor, left: mapView.leftAnchor, bottom: nil, right: nil, topConstant: 2, leftConstant: 12, bottomConstant: 0, rightConstant: 0, widthConstant: 65, heightConstant: 38)
       
    }
    
    @objc func handleMapUpdate() {
        bikeDatas = []
        self.mapView.removeAnnotations(self.mapView.annotations)
        SetService()
        perform(#selector(handleNetWorkStatus), with: self, afterDelay: 1)
    }
    
    
    func showNetworkMessageView(mapNetworkCheck: Bool) {
        addSubview(networkMessageView)
        networkMessageView.addSubview(networkMessageLabel)
        networkMessageView.addSubview(dividerLineView)
        networkMessageView.addSubview(networkMessageCancelButton)
        
        networkMessageView.center = CGPoint(x: frame.width/2, y: frame.height/2)
        
        networkMessageLabel.anchor(top: networkMessageView.topAnchor, left: networkMessageView.leftAnchor, bottom: nil, right: networkMessageView.rightAnchor, topConstant: 0, leftConstant: 60, bottomConstant: 0, rightConstant: 60, widthConstant: 0, heightConstant: networkMessageView.bounds.height*0.65)
//        networkMessageCancelButton.anchor(top: networkMessageView.topAnchor, left: nil, bottom: nil, right: networkMessageView.rightAnchor, topConstant: -10, leftConstant: 0, bottomConstant: 0, rightConstant: -10, widthConstant: 60, heightConstant: 60)
        
        dividerLineView.anchor(top: networkMessageLabel.bottomAnchor, left: networkMessageView.leftAnchor, bottom: nil, right: networkMessageView.rightAnchor, topConstant: 0, leftConstant: 1, bottomConstant: 0, rightConstant: 1, widthConstant: 0, heightConstant: 0.2)
        
        networkMessageCancelButton.anchor(top: dividerLineView.bottomAnchor, left: networkMessageView.leftAnchor, bottom: networkMessageView.bottomAnchor, right: networkMessageView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        networkMessageCancelButton.addTarget(self, action: #selector(handleNetworkMessageViewCancelBtn), for: .touchUpInside)
        if mapNetworkCheck == false {
            networkMessageLabel.text = "請確認網路"
//            self.mapViewCellDelegate?.updateStatusAlert(status: false)
        } else if mapNetworkCheck == true {
//            self.mapViewCellDelegate?.updateStatusAlert(status: true)
            networkMessageLabel.text = "資料下載完成"
        }
    }
    @objc func handleNetworkMessageViewCancelBtn() {
        networkMessageView.removeFromSuperview()
    }
    @objc func handleNetWorkStatus() {
        showNetworkMessageView(mapNetworkCheck: mapNetworkCheck)
//        mapViewController?.showNetworkMessageView(mapNetworkCheck: mapNetworkCheck)
        if mapNetworkCheck == false {
//            self.mapViewCellDelegate?.updateStatusAlert(status: false)
            networkMessageLabel.text = "更新失敗\n請確認網路"
        } else if mapNetworkCheck == true {
//            self.mapViewCellDelegate?.updateStatusAlert(status: true)
            networkMessageLabel.text = "資料下載完成"
        }
    }


    func SetService() {
        
        Service.sharedInstance.fetchJsonData(urlString: webString, completion: { (bikeinfos, err) in
            if let err = err {
                print("MapViewCell 偵測網路沒開：",err.localizedDescription)
//                self.mapViewCellDelegate?.updateStatusAlert(status: false)
            }
            
            guard let bikeinfos = bikeinfos else { return }
            bikeDatas = bikeinfos
            self.setPinToMap()
            mapNetworkCheck = true
            print("SetSerivce 呼叫成功")
            print(bikeDatas.count)

            DispatchQueue.main.async {
               
//                self.showNetworkMessageView(mapNetworkCheck: mapNetworkCheck)
                self.mapView.updateConstraints()
                self.mapViewController?.collectionView?.reloadData()
            }
            
//            self.mapViewCellDelegate?.updateStatusAlert(status: true)
        })
    }

    func setupMap()  {
        addSubview(mapView)
        mapView.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
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
        showNetworkMessageView(mapNetworkCheck: mapNetworkCheck)

        let bikeDataCount = bikeDatas.count
        print("MAP PIN bikeDataCount",bikeDataCount)

        for item in 0 ..< bikeDataCount {
            let annottaion = MKPointAnnotation()
            annottaion.coordinate = bikeDatas[item].locate!
            annottaion.title = "\(bikeDatas[item].sna!)"
            annottaion.subtitle = "\(bikeDatas[item].id!-1)"
            arrAnnotation.append(annottaion)
        }
        print("大頭針數量",arrAnnotation.count)
        self.mapView.addAnnotations(arrAnnotation)
        self.mapView.showAnnotations(arrAnnotation, animated: false)
        
        let viewRegion = MKCoordinateRegionMakeWithDistance(mapView.userLocation.coordinate,3000,3000)
        mapView.setRegion(viewRegion, animated: true)
        locationManager.startUpdatingHeading()
        
        mapView.updateConstraints()
        self.mapViewController?.collectionView?.reloadData()
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

extension MapViewBaseCell: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        //Todo
    }
    
    
}

extension MapViewBaseCell: UISearchBarDelegate {

}

extension MapViewBaseCell: MKMapViewDelegate {
    
    func mapViewWillStartLoadingMap(_ mapView: MKMapView) {
        print("MAP View Will Start Loading MAP")
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            return nil
        }
        var view = mapView.dequeueReusableAnnotationView(withIdentifier: "Pin") as? MKPinAnnotationView
        if view == nil {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "Pin")
        }
        view?.detailCalloutAccessoryView?.removeFromSuperview()
        
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
        let color: UIColor
        let mapFunction: Int

        switch cellItem {
        case 1:
            mapFunction = Int(bikeDatas[index].bemp!)!
        default:
            mapFunction = Int(bikeDatas[index].sbi!)!
        }
        if bikeDatas[index].act == "0" {
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
