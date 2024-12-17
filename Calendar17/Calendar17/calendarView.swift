//
//  calendarView.swift
//  Calendar17
//
//  Created by 出口葵葉 on 2024/09/24.
//

import SwiftUI
import Foundation
import UserNotifications

struct calendarView: View {
    @State var year : Int = AppDelegate().year
    @State var month : Int = AppDelegate().month
    @State var day : Int = AppDelegate().day
    let dayofweek = ["日", "月", "火", "水", "木", "金", "土"]
    var body: some View {
        NavigationView{
        ZStack{
            VStack{
                HStack{
                    Button(action:{ //仮置き
                        self.LastMonth()
                    },label: {
                        Text("前月")
                    })
                    Spacer().frame(width: 70)
                    ZStack{
                        Rectangle().frame(width:160, height:10).foregroundColor(.clear)
                        Text("\(String(self.year))年 \(self.month)月 \(self.day)日").font(.system(size: 20))
                    }
                    Spacer().frame(width: 70)
                    Button(action:{
                        self.NextMonth()
                    },label: {
                        Text("次月")
                    })
                }
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
                                    .frame(width:30, height:30)
                                Text("カレンダー" ).tint(Color(hex: "#f1f2f2"))
                            }
                        }
                        Spacer().frame(width: 40)
                        NavigationLink{
                            CashView()
                        } label: {
                            VStack{
                                Image("money-3")
                                    .resizable()
                                    .frame(width:40, height:30)
                                Text("給与計算" ).tint(Color(hex: "#f1f2f2"))
                            }
                        }
                        Spacer().frame(width: 40)
                        
                        NavigationLink{
                            other()
                        } label: {
                            VStack{
                                Image("other")
                                    .resizable()
                                    .frame(width:30, height:30)
                                Text("その他" ).tint(Color(hex: "#f1f2f2"))
                            }
                        }
                        
                    }.frame(width: 1000, height: 60).background(Color(hex: "#00abc1"))
                    
                    
                }
            }
        }
            
//--------------------------------------------------------------------------
            //デバックスペース
            VStack{
                Text("\(GetWeekNumber(year: self.year, month: self.month))")
            }
//---------------------------------------------------------------------------
        }.navigationBarBackButtonHidden(true).onAppear{
            requestNotificationPermission()
            //fetchHolidays{
            }
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
    private func requestNotificationPermission() {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                if let error = error {
                    print("通知の許可リクエストに失敗しました: \(error)")
                }
                if granted {
                    print("通知が許可されました")
                } else {
                    print("通知が拒否されました")
                }
            }

            // フォアグラウンド通知を処理するためにデリゲートを設定
            UNUserNotificationCenter.current().delegate = NotificationDelegate()
        }
}

class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .sound])
    }
}
    
    #Preview {
        calendarView()
    }
