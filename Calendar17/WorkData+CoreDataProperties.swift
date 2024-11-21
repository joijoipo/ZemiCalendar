//
//  WorkData+CoreDataProperties.swift
//  Calendar17
//
//  Created by 冨成 祐羽 on 2024/11/21.
//
//

import Foundation
import CoreData


extension WorkData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WorkData> {
        return NSFetchRequest<WorkData>(entityName: "WorkData")
    }

    @NSManaged public var breakTime: Double
    @NSManaged public var colorSelect: Data?
    @NSManaged public var endTime: Date?
    @NSManaged public var money: Double
    @NSManaged public var name: String?
    @NSManaged public var notes: String?
    @NSManaged public var overTime: Date?
    @NSManaged public var premiumWages: Double
    @NSManaged public var startTime: Date?
    @NSManaged public var timeStamp: Date?
    @NSManaged public var transportationCost: Double
    @NSManaged public var workDate: Date?
    @NSManaged public var id: UUID?

}

extension WorkData : Identifiable {

}
