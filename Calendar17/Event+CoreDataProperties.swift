//
//  Event+CoreDataProperties.swift
//  Calendar17
//
//  Created by 冨成 祐羽 on 2024/11/21.
//
//

import Foundation
import CoreData


extension Event {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Event> {
        return NSFetchRequest<Event>(entityName: "Event")
    }

    @NSManaged public var color: String?
    @NSManaged public var date: Date?
    @NSManaged public var endDate: Date?
    @NSManaged public var eventDescription: String?
    @NSManaged public var isNotificationEnabled: Bool
    @NSManaged public var isRecurring: Bool
    @NSManaged public var memo: String?
    @NSManaged public var name: String?
    @NSManaged public var notificationTime: Date?
    @NSManaged public var recurrenceRule: String?
    @NSManaged public var startDate: Date?
    @NSManaged public var id: UUID?

}

extension Event : Identifiable {

}
