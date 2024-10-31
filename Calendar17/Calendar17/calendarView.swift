//
//  calendarView.swift
//  Calendar17
//
//  Created by 出口葵葉 on 2024/09/24.
//

import SwiftUI
import Foundation

struct calendarView: View {
    @State var year : Int = AppDelegate().year
    @State var month : Int = AppDelegate().month
    @State var day : Int = AppDelegate().day
    let dayofweek = ["日", "月", "火", "水", "木", "金", "土"]
    var body: some View {
        NavigationView{
        ZStack{
            VStack{
                Text("\(String(self.year))年 \(self.month)月 \(self.day)日").font(.system(size: 20))
                Button(action:{ //仮置き
                    self.LastMonth()
                },label: {
                    Text("前")
                })
                Button(action:{
                    self.NextMonth()
                },label: {
                    Text("次")
                })
                Spacer().frame(height:50)
                
                HStack { //曜日のとこの見た目
                    ForEach(0..<self.dayofweek.count){ index  in ZStack {
                        Rectangle().frame(width:47,height:40).foregroundColor(.clear)
                        Text(dayofweek[index]).font(.system(size:10))
                        }
                    }
                }
                Spacer()
                
                
            }
            
            VStack{
                Spacer().frame(height:115) //日付の位置
                CalendarList(year: $year, month: $month,week: CalendarModel().GetWeekNumber(year: self.year, month: self.month),start: CalendarModel().DayofWeekCalc(year: self.year, month: self.month,day:1), days: DayNumber(year: self.year, month: self.month))

                Spacer()
                
                ZStack {
                    HStack{
                        NavigationLink{
                            calendarView()
                        } label: {
                            VStack{
                                Image("cal-3")
                                    .resizable()
                                    .frame(width:40, height:40)
                                Text("カレンダー" ).background(.clear)
                            }
                        }
                        Spacer().frame(width: 40)
                        NavigationLink{
                            cash()
                        } label: {
                            VStack{
                                Image("money-3")
                                    .resizable()
                                    .frame(width:40, height:40)
                                Text("給与計算" ).background(.clear)
                            }
                        }
                        Spacer().frame(width: 40)
                        
                        NavigationLink{
                            other()
                        } label: {
                            VStack{
                                Image("other")
                                    .resizable()
                                    .frame(width:40, height:40)
                                Text("その他" ).background(.clear)
                            }
                        }
                        
                    }.frame(width: 1000, height: 60).background(.yellow)
                    
                    
                }
            }
        }
            
//--------------------------------------------------------------------------
            //デバックスペース
            VStack{
                Text("\(GetWeekNumber(year: self.year, month: self.month))")
            }
//---------------------------------------------------------------------------
        }.navigationBarBackButtonHidden(true)//.onAppear{
            //fetchHolidays{
                
            //}
        //}
    }
    
    func NextMonth(){
        if self.month != 12{
            self.month += 1
        }else{
            self.year += 1
            self.month = 1
        }
    }
    
    func LastMonth(){
        if self.month != 1{
            self.month -= 1
        }else{
            self.year -= 1
            self.month = 12

        }
    }
}
    
    #Preview {
        calendarView()
    }
