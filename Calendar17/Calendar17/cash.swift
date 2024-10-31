//
//  cash.swift
//  Calendar17
//
//  Created by 出口葵葉 on 2024/10/03.
//

import SwiftUI

struct cash: View {
    
    @State private var isPresented: Bool = false
    
    var body: some View {
        NavigationView{
            
            VStack{
                Button(action: {isPresented = true}) {
                    Text("新しいバイト先の入力")
                    }.fullScreenCover(isPresented: $isPresented) {
                        part(employmentData: EmploymentData())
                        }
                
                Text("給与計算")
            
                HStack{
                    NavigationLink{
                        calendarView()
                    } label: {
                        Text("カレンダー" ).background(.clear)
                    }
                    Spacer().frame(width: 40)
                    NavigationLink{
                        cash()
                    } label: {
                        Text("給与計算" ).background(.clear)
                    }
                    Spacer().frame(width: 40)
                    
                    NavigationLink{
                        other()
                    } label: {
                        Text("その他" ).background(.clear)
                    }
                    
                    
                }
                
            }
        }.navigationBarBackButtonHidden(true)
    }
}

#Preview {
    cash()
}
