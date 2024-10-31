//
//  Page.swift
//  Calendar17
//
//  Created by 出口葵葉 on 2024/10/04.
//

import SwiftUI

struct Page<T: Hashable>: Hashable, Identifiable {
    var id = UUID()
    var index: Int
    var object: T
}
