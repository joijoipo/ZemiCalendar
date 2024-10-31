//
//  SwiftUIView.swift
//  Calendar17
//
//  Created by 出口葵葉 on 2024/09/24.
//

import SwiftUI

struct SwiftUIView: View {
    let dayofweek = ["日","月","火","水","木","金","土"]
    var body: some View {
        VStack {
            HStack {
                ForEach(0..<self.dayofweek.count){ index in
                    ZStack {
                        RoundedRectangle(cornerRadius: 5).frame(width:40,height:40).foregroundColor(.clear)
                        Text(dayofweek[index]).font(.system(size:10))
                    }}
            }
        }
    }
}

#Preview {
    SwiftUIView()
}
