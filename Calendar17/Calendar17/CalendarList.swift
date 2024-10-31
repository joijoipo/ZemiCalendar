//
//  CalendarList.swift
//  Calendar17
//
//  Created by 出口葵葉 on 2024/09/24.
//

import SwiftUI
import CoreData

struct CalendarList: View {
    
    @State private var isPresented: Bool = false
    
    @Binding var year : Int
    @Binding var month : Int
    var startdaynumber : Int
    var weeknumber : Int
    var days : Int
    var middleweek : Int
    var lastweeknumber : Int
    let column = 7
    
    init(year:Binding<Int>,month:Binding<Int>,week:Int,start:Int,days:Int){
        self._year = year
        self._month = month
        self.weeknumber = week
        self.startdaynumber = start
        self.days = days
        self.middleweek = (days - (7 - start)) / 7
        self.lastweeknumber = (days - (7 - start)) % 7
    }
    
    func getTextColor(for day: Int) -> Color {
        let weekday = DayofWeekCalc(year: self.year, month: self.month, day: day)
        let holiday = checkHoliday(year: self.year, month: self.month, day: day)
        if weekday == 0 { // 日曜日
            return .red
        } else if weekday == 6 && holiday != .red{ // 土曜日
            return .blue
        }else {
            return holiday
        }
    }
    
    func renderWeek4() -> some View { //4週目
        return HStack(spacing: 0){
            if self.lastweeknumber != 0{
                ForEach(0..<self.lastweeknumber,id:\.self){ index in
                    ZStack(alignment: .top){
                        Rectangle().stroke(.gray, lineWidth: 0.2).frame(width:55,height:Hei())
                        Text("\(((7-self.startdaynumber)+1+index)+14)")
                            .font(.system(size: 20))
                            .foregroundColor(getTextColor(for: (((7-self.startdaynumber)+1+index)+14)))
                    }
                }
            }else{
                ForEach(0..<7,id:\.self){ index in
                    ZStack(alignment: .top){
                        Rectangle().stroke(.gray, lineWidth: 0.2).frame(width:55,height:Hei())
                        Text("\(((7-self.startdaynumber)+1+index)+14)")
                            .font(.system(size: 20))
                            .foregroundColor(getTextColor(for: (((7-self.startdaynumber)+1+index)+14)))
                    }
                }
            }
        }
    }
    
    func renderWeek5() -> some View { //5週目
        return HStack(spacing: 0){
            if self.lastweeknumber != 0{
                ForEach(0..<self.lastweeknumber,id:\.self){ index in
                    ZStack(alignment: .top){
                        Rectangle().stroke(.gray, lineWidth: 0.2).frame(width:55,height:Hei())
                        Text("\(((7-self.startdaynumber)+1+index)+21)")
                            .font(.system(size: 20))
                            .foregroundColor(getTextColor(for: (((7-self.startdaynumber)+1+index)+21)))
                    }
                }
                
                ForEach(0..<(7-self.lastweeknumber),id:\.self){ index in
                    ZStack{
                        Rectangle().stroke(.gray, lineWidth: 0.2).frame(width:55,height:Hei())
                        Text("")
                            .font(.system(size: 20))
                            .foregroundColor(.black)
                        
                    }
                }
            }else{
                ForEach(0..<7,id:\.self){ index in
                    ZStack(alignment: .top){
                        Rectangle().stroke(.gray, lineWidth: 0.2).frame(width:55,height:Hei())
                        Text("\(((7-self.startdaynumber)+1+index)+21)")
                            .font(.system(size: 20))
                            .foregroundColor(getTextColor(for: (((7-self.startdaynumber)+1+index)+21)))
                    }
                }
            }
            
        }
    }
    
    func renderWeek6() -> some View { //6週目
        return HStack(spacing: 0){
            if self.lastweeknumber != 0{
                ForEach(0..<self.lastweeknumber,id:\.self){ index in
                    ZStack(alignment: .top){
                        Rectangle().stroke(.gray, lineWidth: 0.2).frame(width:55,height:Hei())
                        Text("\(((7-self.startdaynumber)+1+index)+28)")
                            .font(.system(size: 20))
                            .foregroundColor(getTextColor(for: (((7-self.startdaynumber)+1+index)+28)))
                    }
                }
                ForEach(0..<(7-self.lastweeknumber),id:\.self){ index in
                    ZStack{
                        Rectangle().stroke(.gray, lineWidth: 0.2).frame(width:55,height:Hei())
                        Text("iu")
                            .font(.system(size: 20))
                            .foregroundColor(.yellow)
                    }
                }
            }else{
                ForEach(0..<self.lastweeknumber,id:\.self){ index in
                    ZStack(alignment: .top){
                        Rectangle().stroke(.gray, lineWidth: 0.2).frame(width:55,height:Hei())
                        Text("\(((7-self.startdaynumber)+1+index)+28)")
                            .font(.system(size: 20))
                            .foregroundColor(getTextColor(for: (((7-self.startdaynumber)+1+index)+28)))
                    }
                }
            }
        }
    }
    
    func Hei() -> CGFloat { //heightの数値
        if weeknumber == 4 {
            return CGFloat(150)
        } else if weeknumber == 6 {
            return CGFloat(100)
        } else {
            return CGFloat(120)
        }
     }
    
    var body: some View {
        VStack(spacing: 0){
            // 1週
            HStack(spacing: 0) {
                if self.startdaynumber != 0{     //カレンダーの最初の空白を作るコード
                    ForEach(0..<self.startdaynumber,id:\.self){ index in
                        Button(action: {
                            isPresented = true //trueにしないと画面遷移されない
                        }) { Rectangle().stroke(.gray, lineWidth: 0.2).frame(width:55,height:Hei())
                            }.fullScreenCover(isPresented: $isPresented) {
                                cash()
                                }
                    }
                }
                ForEach(0..<(self.column-self.startdaynumber),id:\.self){ index in //1日から表示するコード
                    ZStack(alignment: .top){
                        Rectangle().stroke(.gray, lineWidth: 0.2).frame(width:55,height:Hei())
                        Text("\(index+1)")
                            .font(.system(size: 20))
                            .foregroundColor(getTextColor(for: index+1))
                    }
                }
            }
            // 2週
            HStack(spacing: 0) {
                ForEach(0..<self.column,id:\.self){ index in
                    ZStack(alignment: .top){
                        Rectangle().stroke(.gray, lineWidth: 0.2).frame(width:55,height:Hei())
                        Text("\((self.column-self.startdaynumber)+1+index)")
                            .font(.system(size: 20))
                            .foregroundColor(getTextColor(for: ((self.column-self.startdaynumber)+1+index)))
                    }
                }
            }
            
            // 3週
            HStack(spacing: 0){
                ForEach(0..<self.column,id:\.self){ index in
                    ZStack(alignment: .top){
                        Rectangle().stroke(.gray, lineWidth: 0.2).frame(width:55,height:Hei())
                        Text("\(((7-self.startdaynumber)+1+index)+7)")
                            .font(.system(size: 20))
                            .foregroundColor(getTextColor(for: (((7-self.startdaynumber)+1+index)+7)))
                    }
                }
            }
            
            // 4,5,6週
            if self.weeknumber == 4{
                renderWeek4()
            }else if self.weeknumber == 5{
                HStack(spacing: 0){
                    ForEach(0..<self.column,id:\.self){ index in
                        ZStack(alignment: .top){
                            Rectangle().stroke(.gray, lineWidth: 0.2).frame(width:55,height:Hei())
                            Text("\(((7-self.startdaynumber)+1+index)+14)")
                                .font(.system(size: 20))
                                .foregroundColor(getTextColor(for: (((7-self.startdaynumber)+1+index)+14)))
                        }
                    }
                }
                renderWeek5()
            }else if self.weeknumber == 6{
                HStack(spacing: 0){
                    ForEach(0..<self.column,id:\.self){ index in
                        ZStack(alignment: .top){
                            Rectangle().stroke(.gray, lineWidth: 0.2).frame(width:55,height:Hei())
                            Text("\(((7-self.startdaynumber)+1+index)+14)")
                                .font(.system(size: 20))
                                .foregroundColor(getTextColor(for: (((7-self.startdaynumber)+1+index)+14)))
                        }
                    }
                }
                HStack(spacing: 0){
                    ForEach(0..<self.column,id:\.self){ index in
                        ZStack(alignment: .top){
                            Rectangle().stroke(.gray, lineWidth: 0.2).frame(width:55,height:Hei())
                            Text("\(((7-self.startdaynumber)+1+index)+21)")
                                .font(.system(size: 20))
                                .foregroundColor(getTextColor(for: (((7-self.startdaynumber)+1+index)+21)))
                            
                        }
                    }
                }
                renderWeek6()
            }
        }
    }
}

