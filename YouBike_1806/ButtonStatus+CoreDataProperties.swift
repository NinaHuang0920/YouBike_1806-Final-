//
//  ButtonStatus+CoreDataProperties.swift
//  YouBike_1806
//
//  Created by 黃玉玲 on 2018/8/22.
//  Copyright © 2018年 CheshireCat. All rights reserved.
//
//

import Foundation
import CoreData


extension ButtonStatus {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ButtonStatus> {
        return NSFetchRequest<ButtonStatus>(entityName: "ButtonStatus")
    }

    @NSManaged public var hasFavorited: Bool
    @NSManaged public var stationId: Int16
    @NSManaged public var stationName: String?

}
