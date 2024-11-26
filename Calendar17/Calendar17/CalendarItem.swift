//
//  .swift
//  Calendar17
//
//  Created by 冨成 祐羽 on 2024/11/21.
//

import Foundation
import SwiftUI

struct CalendarItem: Identifiable {
    var id: UUID
    var title: String
    var startTime: Date
    var type: ItemType

    enum ItemType {
        case workData
        case event
    }
}

func getCombinedCalendarItems() -> [CalendarItem] {
    var combinedItems: [CalendarItem] = []

    // WorkData を CalendarItem に変換
    for work in workDataList {
        if let date = work.workDate {
            combinedItems.append(CalendarItem(
                id: work.id ?? UUID(),
                title: work.title ?? "No Title",
                startTime: date,
                type: .workData
            ))
        }
    }

    // Event を CalendarItem に変換
    for event in eventList {
        if let start = event.startTime {
            combinedItems.append(CalendarItem(
                id: event.id ?? UUID(),
                title: event.title ?? "No Title",
                startTime: start,
                type: .event
            ))
        }
    }

    // ソート: 日時順
    return combinedItems.sorted { $0.startTime < $1.startTime }
}
