//
//  leapYear.swift
//  Calendar17
//
//  Created by 出口葵葉 on 2024/09/24.
//

import SwiftUI

func LeapYear(year:Int) -> Bool {
    let result = (year % 400 == 0 || (year % 4 == 0 && year % 100 != 0)) ? true : false
    return result
}
