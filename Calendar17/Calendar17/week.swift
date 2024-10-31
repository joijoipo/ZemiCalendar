//
//  week.swift
//  Calendar17
//
//  Created by 出口葵葉 on 2024/09/24.
//

import Foundation

private func CaseFourWeek(year:Int,month:Int) -> Bool {
    let firstdayofweek = DayofWeekCalc(year: year, month: month, day: 1)
    let result = (!LeapYear(year: year) && month == 2 && (firstdayofweek == 0)) ? true : false
    return result
}

private func CaseSixWeek(year:Int,month:Int) -> Bool {
    let firstdayofweek = DayofWeekCalc(year: year, month: month, day: 1)
    let days = DayNumber(year: year, month: month)
    let result = ((firstdayofweek == 6 && days == 30) || (firstdayofweek >= 5 && days == 31)) ? true : false
    return result
}

func GetWeekNumber(year:Int,month:Int) -> Int {
    var result : Int = 0
    if CaseFourWeek(year: year, month: month){
        result = 4
    }else if CaseSixWeek(year: year, month: month){
        result = 6
    }else{
        result = 5
    }
    return result
}
