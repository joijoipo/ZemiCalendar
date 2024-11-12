//
//  Test.swift
//  Calendar17
//
//  Created by 出口葵葉 on 2024/10/21.
//

import SwiftUI

struct Test: View {
    var body: some View {
        HStack {
            ForEach(0..<5){ index in
                Rectangle().stroke(.red, lineWidth: 2).frame(width:55,height:120)
            }
            
        }
    }
}

#Preview {
    Test()
}
