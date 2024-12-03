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
    @FetchRequest(
        entity: Event.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Event.startDate, ascending: true)]
    ) var eventList: FetchedResults<Event>
    
    @State private var isPresented: Bool = false
    @State private var isSheetPresented = false
    @State private var selectedDay: Int? = nil
    
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
    
    func renderWeek5() -> some View { //5週目
        return HStack(spacing: 0){
            if self.lastweeknumber != 0{
                ForEach(0..<self.lastweeknumber, id:\.self) { index in
                    let day = (((7-self.startdaynumber)+1+index)+21)
                    // 予定があるかをフィルタリング
                    let scheduledEvents = workDataList.filter {
                        Calendar.current.isDate($0.startTime!, inSameDayAs: Calendar.current.date(from: DateComponents(year: self.year, month: self.month, day: day))!)
                    }
                    
                    ZStack(alignment: .top) {
                        Button(action: {selectedDay = day
                            isSheetPresented = true})
                        {Rectangle()
                                .stroke(.gray, lineWidth: 0.2)
                                .frame(width: 55, height: Hei())}
                        
                        VStack {
                            Text("\(day)")
                                .font(.system(size: 20))
                                .foregroundColor(getTextColor(for: day))
                            
                            // 予定の表示を共通関数で呼び出す
                            renderScheduledEvents(for: day, scheduledEvents: scheduledEvents)
                            renderEventDetails(for: day)
                        }
                    }
                }
                
                ForEach(0..<(7-self.lastweeknumber),id:\.self){ index in
                    ZStack{
                        Rectangle().stroke(.gray, lineWidth: 0.2).frame(width:55,height:Hei())
                        Text("おい")
                            .font(.system(size: 20))
                            .foregroundColor(.black)
                        
                    }
                }
            }else{
                ForEach(0..<self.column, id:\.self) { index in
                    let day = (((7-self.startdaynumber)+1+index)+21)
                    // 予定があるかをフィルタリング
                    let scheduledEvents = workDataList.filter {
                        Calendar.current.isDate($0.startTime!, inSameDayAs: Calendar.current.date(from: DateComponents(year: self.year, month: self.month, day: day))!)
                    }
                    
                    ZStack(alignment: .top) {
                        Button(action: {selectedDay = day
                            isSheetPresented = true})
                        {Rectangle()
                                .stroke(.gray, lineWidth: 0.2)
                                .frame(width: 55, height: Hei())}
                        
                        VStack {
                            Text("\(day)")
                                .font(.system(size: 20))
                                .foregroundColor(getTextColor(for: day))
                            
                            // 予定の表示を共通関数で呼び出す
                            renderScheduledEvents(for: day, scheduledEvents: scheduledEvents)
                            renderEventDetails(for: day)
                        }
                    }
                }
            }
            
        }
    }
    
    func renderWeek6() -> some View { //6週目
        return HStack(spacing: 0){
            if self.lastweeknumber != 0{
                ForEach(0..<self.lastweeknumber, id:\.self) { index in
                    let day = (((7-self.startdaynumber)+1+index)+28)
                    // 予定があるかをフィルタリング
                    let scheduledEvents = workDataList.filter {
                        Calendar.current.isDate($0.startTime!, inSameDayAs: Calendar.current.date(from: DateComponents(year: self.year, month: self.month, day: day))!)
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
                ForEach(0..<(7-self.lastweeknumber),id:\.self){ index in
                    ZStack{
                        Rectangle().stroke(.gray, lineWidth: 0.2).frame(width:55,height:Hei())
                        Text("")
                            .font(.system(size: 20))
                            .foregroundColor(.yellow)
                    }
                }
            }else{
                ForEach(0..<self.column, id:\.self) { index in
                    let day = (((7-self.startdaynumber)+1+index)+28)
                    // 予定があるかをフィルタリング
                    let scheduledEvents = workDataList.filter {
                        Calendar.current.isDate($0.startTime!, inSameDayAs: Calendar.current.date(from: DateComponents(year: self.year, month: self.month, day: day))!)
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
    
    func getEvents(for day: Int) -> [Event] {
        let currentDate = Calendar.current.date(from: DateComponents(year: self.year, month: self.month, day: day))!
        return eventList.filter { event in
            Calendar.current.isDate(event.startDate!, inSameDayAs: currentDate)
        }
    }
    
    func renderEventDetails(for day: Int) -> some View {
        let events = getEvents(for: day)
        
        return VStack {
            ForEach(0..<min(3, events.count), id: \.self) { index in
                Text(events[index].name ?? "No Title")
                    .font(.system(size: 12))
                    .foregroundColor(.green) // イベント名は緑色で表示
                    .lineLimit(1)
                    .frame(width: 55, alignment: .leading)
            }
            if events.count > 3 {
                Text("...")
                    .font(.system(size: 12))
                    .foregroundColor(.green)
                    .lineLimit(1)
                    .frame(width: 55, alignment: .leading)
            }
        }
        .frame(maxWidth: 55, alignment: .leading)
    }
    
    func getWorkData(for day: Int) -> [WorkData] {
            let currentDate = Calendar.current.date(from: DateComponents(year: self.year, month: self.month, day: day))!
            return workDataList.filter { workData in
                Calendar.current.isDate(workData.startTime!, inSameDayAs: currentDate)
            }
        }

    
    var body: some View {
        VStack(spacing: 0){
            // 1週
            HStack(spacing: 0) {
                if self.startdaynumber != 0{     //カレンダーの最初の空白を作るコード
                    ForEach(0..<self.startdaynumber,id:\.self){ index in
                        Rectangle().stroke(.gray, lineWidth: 0.2).frame(width:55,height:Hei())
                    }
                }
                ForEach(0..<(self.column-self.startdaynumber), id:\.self) { index in
                    let day = index + 1
                    // 予定があるかをフィルタリング
                    let scheduledEvents = workDataList.filter {
                        Calendar.current.isDate($0.startTime!, inSameDayAs: Calendar.current.date(from: DateComponents(year: self.year, month: self.month, day: day))!)
                    }
                    
                    ZStack(alignment: .top) {
                        Button(action: {selectedDay = day
                            isSheetPresented = true})
                        {Rectangle()
                                .stroke(.gray, lineWidth: 0.2)
                                .frame(width: 55, height: Hei())}
                        
                        VStack {
                            Text("\(day)")
                                .font(.system(size: 20))
                                .foregroundColor(getTextColor(for: day))
                            
                            // 予定の表示を共通関数で呼び出す
                            renderScheduledEvents(for: day, scheduledEvents: scheduledEvents)
                            renderEventDetails(for: day)
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
                        Calendar.current.isDate($0.startTime!, inSameDayAs: Calendar.current.date(from: DateComponents(year: self.year, month: self.month, day: day))!)
                    }
                    
                    ZStack(alignment: .top) {
                        Button(action: {selectedDay = day
                            isSheetPresented = true})
                        {Rectangle()
                                .stroke(.gray, lineWidth: 0.2)
                                .frame(width: 55, height: Hei())}
                        
                        VStack {
                            Text("\(day)")
                                .font(.system(size: 20))
                                .foregroundColor(getTextColor(for: day))
                            
                            // 予定の表示を共通関数で呼び出す
                            renderScheduledEvents(for: day, scheduledEvents: scheduledEvents)
                            renderEventDetails(for: day)
                        }
                    }
                }
            }

            // 3週目の表示部分
            HStack(spacing: 0) {
                ForEach(0..<self.column, id: \.self) { index in
                    let day = ((7 - self.startdaynumber) + 1 + index) + 7
                    let scheduledEvents = workDataList.filter {
                        Calendar.current.isDate($0.startTime!, inSameDayAs: Calendar.current.date(from: DateComponents(year: self.year, month: self.month, day: day))!)
                    }
                    
                    ZStack(alignment: .top) {
                        Button(action: {selectedDay = day
                            isSheetPresented = true})
                        {Rectangle()
                                .stroke(.gray, lineWidth: 0.2)
                                .frame(width: 55, height: Hei())}
                        
                        VStack {
                            Text("\(day)")
                                .font(.system(size: 20))
                                .foregroundColor(getTextColor(for: day))
                            
                            // 予定の表示を共通関数で呼び出す
                            renderScheduledEvents(for: day, scheduledEvents: scheduledEvents)
                            renderEventDetails(for: day)
                        }
                    }
                }
            }
            
            // ４週目の表示部分
            HStack(spacing: 0) {
                ForEach(0..<self.column, id: \.self) { index in
                    let day = (((7-self.startdaynumber)+1+index)+14)
                    let scheduledEvents = workDataList.filter {
                        Calendar.current.isDate($0.startTime!, inSameDayAs: Calendar.current.date(from: DateComponents(year: self.year, month: self.month, day: day))!)
                    }
                    
                    ZStack(alignment: .top) {
                        Button(action: {selectedDay = day
                            isSheetPresented = true})
                        {Rectangle()
                                .stroke(.gray, lineWidth: 0.2)
                                .frame(width: 55, height: Hei())}
                        
                        VStack {
                            Text("\(day)")
                                .font(.system(size: 20))
                                .foregroundColor(getTextColor(for: day))
                            
                            // 予定の表示を共通関数で呼び出す
                            renderScheduledEvents(for: day, scheduledEvents: scheduledEvents)
                            renderEventDetails(for: day)
                        }
                    }
                }
            }

            
            //5,6週
            if self.weeknumber == 5{
                renderWeek5()
            }else if self.weeknumber == 6{
                HStack(spacing: 0) {
                    ForEach(0..<self.column, id:\.self) { index in
                        let day = (((7-self.startdaynumber)+1+index)+21)
                        // 予定があるかをフィルタリング
                        let scheduledEvents = workDataList.filter {
                            Calendar.current.isDate($0.startTime!, inSameDayAs: Calendar.current.date(from: DateComponents(year: self.year, month: self.month, day: day))!)
                        }
                        
                        ZStack(alignment: .top) {
                            Button(action: {selectedDay = day
                                isSheetPresented = true})
                            {Rectangle()
                                    .stroke(.gray, lineWidth: 0.2)
                                    .frame(width: 55, height: Hei())}
                            
                            VStack {
                                Text("\(day)")
                                    .font(.system(size: 20))
                                    .foregroundColor(getTextColor(for: day))
                                
                                // 予定の表示を共通関数で呼び出す
                                renderScheduledEvents(for: day, scheduledEvents: scheduledEvents)
                                renderEventDetails(for: day)
                            }
                        }
                    }
                }
                renderWeek6()
            }
        }
        .sheet(isPresented: $isSheetPresented) {
            if let selectedDay = selectedDay {
                EventDetailView(year: self.year, month: self.month, day: selectedDay, events: getEvents(for: selectedDay), workData: getWorkData(for: selectedDay))
            }
        }
    }
}

