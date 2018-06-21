//
//  BikeMapBar.swift
//  YouBike_1806
//
//  Created by 黃玉玲 on 2018/6/20.
//  Copyright © 2018年 CheshireCat. All rights reserved.
//

import UIKit

let imageNames = ["bicycle", "parking"]
let mapBarLabelText = ["借車地圖","還車地圖"]

class MapBarSelectedView: UIView, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
//    let mapBarWidth:CGFloat = (UIApplication.shared.keyWindow?.bounds.width)!/2
    
    private let cellId = "cellId"
    
    var mapViewController: MapViewController?
    
    lazy var collectionView : UICollectionView = {
        let leyout = UICollectionViewFlowLayout()
        leyout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: leyout)
        cv.backgroundColor = UIColor.clear
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
       
//       backgroundColor = .purple
        
        addSubview(collectionView)
        collectionView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        collectionView.register(MapBarSelectedCollectionCell.self, forCellWithReuseIdentifier: cellId)
        
        let selectedIndexPath = IndexPath(item: 0, section: 0)
        collectionView.selectItem(at: selectedIndexPath, animated: false, scrollPosition: UICollectionViewScrollPosition.centeredHorizontally)
        
        setupHorizontalBar()
    }
    
    
    var horizontalLeftAnchorConstraint: NSLayoutConstraint?

    func setupHorizontalBar() {
        let horizontalBarView = UIView()
        horizontalBarView.backgroundColor = mapBarColor
        horizontalBarView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(horizontalBarView)

        horizontalLeftAnchorConstraint = horizontalBarView.leftAnchor.constraint(equalTo: self.leftAnchor)
        horizontalLeftAnchorConstraint?.isActive = true
        
        horizontalBarView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        horizontalBarView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/2).isActive = true
        horizontalBarView.heightAnchor.constraint(equalToConstant: 4).isActive = true
     }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        //讓ManuBar 隨著點選ManuBarCollection而移動
//        let x = CGFloat(indexPath.item) * (self.frame.width / 2)
//        horizontalLeftAnchorConstraint?.constant = x
//        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
//            self.layoutIfNeeded()
//        }, completion: nil)
//        // end
        
        mapViewController?.scrollToMenuIndex(menuIndex: indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MapBarSelectedCollectionCell
        cell.backgroundColor = .clear
        
        cell.selectedBarImage.image = UIImage(named: imageNames[indexPath.item])?.withRenderingMode(.alwaysTemplate)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width/2, height: self.frame.height)
    }  
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsetsMake(0, 0, 0, 0)
//    }
   
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class MapBarSelectedCollectionCell: BaseCell {
    
    let selectedBarImage: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "bicycle").withRenderingMode(.alwaysTemplate)
        image.contentMode = .scaleAspectFill
        image.tintColor = selectedMapBarItemColor
        return image
    }()
    
    override var isSelected: Bool {
        didSet {
            selectedBarImage.tintColor = isSelected ? mapBarColor : selectedMapBarItemColor
        }
    }
    
        override func setupViews() {
        super.setupViews()
        addSubview(selectedBarImage)
        selectedBarImage.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)        }
        

}
