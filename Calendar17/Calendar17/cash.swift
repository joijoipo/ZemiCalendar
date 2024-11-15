//
//  cash.swift
//  Calendar17
//
//  Created by 出口葵葉 on 2024/10/03.
//

import SwiftUI

struct CashView: View {
    
    @State private var isPresented: Bool = false
    
    var body: some View {
        NavigationView{
            
            VStack{
                NavigationLink{
                    AddWorkDataView()
                } label: {
                    Text("新しいバイト先を追加" ).background(.clear)
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
                        CashView()
                    } label: {
                        Text("給与計算" ).background(.clear)
                    }
                    Spacer().frame(width: 40)
                    
                    NavigationLink{
                        TotalCash()
                    } label: {
                        Text("給与合計" ).background(.clear)
                    }
                    
                    
                }
                
            }
        }.navigationBarBackButtonHidden(true)
    }
}

#Preview {
    CashView()
}
