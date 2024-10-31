//
//  CalendarModel.swift
//  Calendar17
//
//  Created by 出口葵葉 on 2024/09/26.
//

import SwiftUI
import Foundation

struct CalendarModel {
    // 年と月に基づいて、その月の日数を返す◎
//    func DayNumber(year: Int, month: Int) -> Int {
//        let dateComponents = DateComponents(year: year, month: month)
//        let calendar = Calendar.current
//        let date = calendar.date(from: dateComponents)!
//        return calendar.range(of: .day, in: .month, for: date)!.count
//    }

    // 指定した日が週の何日目か（0:日曜, 1:月曜, ... 6:土曜）
    func DayofWeekCalc(year: Int, month: Int, day: Int) -> Int {
        let dateComponents = DateComponents(year: year, month: month, day: day)
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)!
        return calendar.component(.weekday, from: date) - 1 // 日曜を0にする
    }

    // 年と月から、その月が何週あるかを計算する
    func GetWeekNumber(year: Int, month: Int) -> Int {
        let daysInMonth = DayNumber(year: year, month: month)
        let startDayOfWeek = DayofWeekCalc(year: year, month: month, day: 1)
        let totalDays = daysInMonth + startDayOfWeek
        return Int(ceil(Double(totalDays) / 7.0))// 週数の計算
    }
}
