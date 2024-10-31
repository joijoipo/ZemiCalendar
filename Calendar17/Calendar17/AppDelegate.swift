//
//  AppDelegate.swift
//  Calendar17
//
//  Created by 出口葵葉 on 2024/09/24.
//

import SwiftUI

struct AppDelegate: View {
    
class AppDelegate: UIResponder, UIApplicationDelegate {
    let year : Int = Calendar.current.component(.year, from: Date())
    let month : Int = Calendar.current.component(.month, from: Date())
    let day : Int = Calendar.current.component(.day, from: Date())
}

@State var year : Int = AppDelegate().year
@State var month : Int = AppDelegate().month
@State var day : Int = AppDelegate().day
let dayofweek = ["日","月","火","水","木","金","土"]
var body: some View {
    VStack {
        Text("\(String(self.year))年 \(self.month)月 \(self.day)日")
            .font(.system(size: 20))
        HStack {
            ForEach(0..<self.dayofweek.count){ index in ZStack {
                RoundedRectangle(cornerRadius: 5).frame(width:40,height:40).foregroundColor(.clear)
                Text(dayofweek[index]).font(.system(size:10))
            }}
        }
      }
    }
}

#Preview {
    AppDelegate()
}
