//
//  PageDirection.swift
//  Calendar17
//
//  Created by 出口葵葉 on 2024/10/04.
//

import SwiftUI

enum PageDirection {
    case backward
    case forward

    var baseIndex: Int {
        switch self {
        case .backward:
            return 0
        case .forward:
            return 2
        }
    }
}
