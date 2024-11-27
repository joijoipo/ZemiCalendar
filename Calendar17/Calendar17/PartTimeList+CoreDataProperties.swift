//
//  PartTimeList+CoreDataProperties.swift
//  Calendar17
//
//  Created by 冨成 祐羽 on 2024/11/27.
//
//

import Foundation
import CoreData


extension PartTimeList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PartTimeList> {
        return NSFetchRequest<PartTimeList>(entityName: "PartTimeList")
    }

    @NSManaged public var name: String?
    @NSManaged public var money: Double
    @NSManaged public var workRecords: WorkData?

}

extension PartTimeList : Identifiable {

}
