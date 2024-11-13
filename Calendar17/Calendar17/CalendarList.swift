//
//  CalendarList.swift
//  Calendar17
//
//  Created by 出口葵葉 on 2024/09/24.
//

import SwiftUI
import CoreData

struct CalendarList: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: WorkData.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \WorkData.workDate, ascending: true)])
    var workDataList: FetchedResults<WorkData>
    
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
                    let day = (((7-self.startdaynumber)+1+index)+14)
                    // 予定があるかをフィルタリング
                    let scheduledEvents = workDataList.filter {
                        Calendar.current.isDate($0.workDate!, inSameDayAs: Calendar.current.date(from: DateComponents(year: self.year, month: self.month, day: day))!)
                    }
                    
                    ZStack(alignment: .top) {
                        Rectangle()
                            .stroke(.gray, lineWidth: 0.2)
                            .frame(width: 55, height: Hei())
                        
                        VStack {
                            Text("\(day)")
                                .font(.system(size: 20))
                                .foregroundColor(getTextColor(for: day))
                            
                            // 予定の表示を共通関数で呼び出す
                            renderScheduledEvents(for: day, scheduledEvents: scheduledEvents)
                        }
                    }
                }
            }else{
                ForEach(0..<7,id:\.self){ index in
                    let day = (((7-self.startdaynumber)+1+index)+14)
                    // 予定があるかをフィルタリング
                    let scheduledEvents = workDataList.filter {
                        Calendar.current.isDate($0.workDate!, inSameDayAs: Calendar.current.date(from: DateComponents(year: self.year, month: self.month, day: day))!)
                    }
                    
                    ZStack(alignment: .top) {
                        Rectangle()
                            .stroke(.gray, lineWidth: 0.2)
                            .frame(width: 55, height: Hei())
                        
                        VStack {
                            Text("\(day)")
                                .font(.system(size: 20))
                                .foregroundColor(getTextColor(for: day))
                            
                            // 予定の表示を共通関数で呼び出す
                            renderScheduledEvents(for: day, scheduledEvents: scheduledEvents)
                        }
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
    
    // 予定を表示するための共通関数
    func renderScheduledEvents(for day: Int, scheduledEvents: [WorkData]) -> some View {
        VStack {
            // 最大3件の予定を表示
            ForEach(0..<min(3, scheduledEvents.count), id: \.self) { eventIndex in
                Text(scheduledEvents[eventIndex].name ?? "No Title") // 予定名を表示
                    .font(.system(size: 12))
                    .foregroundColor(.blue) // 予定は青色で表示
                    .lineLimit(1) // テキストは1行に制限
                    .frame(width: 55, alignment: .leading) // セル幅に合わせる
                    .clipped() // セル外にはみ出た部分を隠す
            }

            // 予定が4件以上ある場合は「...」を表示
            if scheduledEvents.count > 3 {
                Text("...")
                    .font(.system(size: 12))
                    .foregroundColor(.blue)
                    .lineLimit(1) // 1行に制限
                    .frame(width: 55, alignment: .leading) // セル幅に合わせる
                    .clipped() // 「...」が枠を超えないように
            }
        }
        .frame(maxWidth: 55, alignment: .leading) // セル幅を制限して、親ビューの範囲も固定
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
                                CashView()
                                }
                    }
                }
                ForEach(0..<(self.column-self.startdaynumber), id:\.self) { index in
                    let day = index + 1
                    // 予定があるかをフィルタリング
                    let scheduledEvents = workDataList.filter {
                        Calendar.current.isDate($0.workDate!, inSameDayAs: Calendar.current.date(from: DateComponents(year: self.year, month: self.month, day: day))!)
                    }
                    
                    ZStack(alignment: .top) {
                        Rectangle()
                            .stroke(.gray, lineWidth: 0.2)
                            .frame(width: 55, height: Hei())
                        
                        VStack {
                            Text("\(day)")
                                .font(.system(size: 20))
                                .foregroundColor(getTextColor(for: day))
                            
                            // 予定の表示を共通関数で呼び出す
                            renderScheduledEvents(for: day, scheduledEvents: scheduledEvents)
                        }
                    }
                }


            }
            // 2週
            HStack(spacing: 0) {
                ForEach(0..<self.column, id:\.self) { index in
                    let day = (self.column-self.startdaynumber) + 1 + index
                    // 予定があるかをフィルタリング
                    let scheduledEvents = workDataList.filter {
                        Calendar.current.isDate($0.workDate!, inSameDayAs: Calendar.current.date(from: DateComponents(year: self.year, month: self.month, day: day))!)
                    }
                    
                    ZStack(alignment: .top) {
                        Rectangle()
                            .stroke(.gray, lineWidth: 0.2)
                            .frame(width: 55, height: Hei())
                        
                        VStack {
                            Text("\(day)")
                                .font(.system(size: 20))
                                .foregroundColor(getTextColor(for: day))
                            
                            // 予定の表示を共通関数で呼び出す
                            renderScheduledEvents(for: day, scheduledEvents: scheduledEvents)
                        }
                    }
                }
            }

            // 3週目の表示部分
            HStack(spacing: 0) {
                ForEach(0..<self.column, id: \.self) { index in
                    let day = ((7 - self.startdaynumber) + 1 + index) + 7
                    let scheduledEvents = workDataList.filter {
                        Calendar.current.isDate($0.workDate!, inSameDayAs: Calendar.current.date(from: DateComponents(year: self.year, month: self.month, day: day))!)
                    }
                    
                    ZStack(alignment: .top) {
                        Rectangle()
                            .stroke(.gray, lineWidth: 0.2)
                            .frame(width: 55, height: Hei())
                        
                        VStack {
                            Text("\(day)")
                                .font(.system(size: 20))
                                .foregroundColor(getTextColor(for: day))
                            
                            // 予定の表示を共通関数で呼び出す
                            renderScheduledEvents(for: day, scheduledEvents: scheduledEvents)
                        }
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

