//
//  Untitled.swift
//  Calendar17
//
//  Created by 冨成 祐羽 on 2024/11/12.
//

import SwiftUI

struct Untitled: View {
    var body: some View {
        HStack {
            ForEach(0..<5){ index in
                Rectangle().stroke(.red, lineWidth: 2).frame(width:55,height:120)
            }
            
        }
    }
}

#Preview {
    Untitled()
}
