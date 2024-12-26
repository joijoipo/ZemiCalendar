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
                            renderCombinedEvents(for: day, weeknumber: GetWeekNumber(year: self.year, month: self.month))
                        }
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
                            renderCombinedEvents(for: day, weeknumber: GetWeekNumber(year: self.year, month: self.month))
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
                            renderCombinedEvents(for: day, weeknumber: GetWeekNumber(year: self.year, month: self.month))
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
                            renderCombinedEvents(for: day, weeknumber: GetWeekNumber(year: self.year, month: self.month))
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
    func renderScheduledEvents(for day: Int) -> some View {
        let workDataList = getWorkData(for: day)
        return VStack {
            ForEach(0..<min(4, workDataList.count), id: \.self) { eventIndex in
                VStack {
                    ZStack {
                        Text(workDataList[eventIndex].name ?? "No Title")
                            .font(.system(size: 10))
                            .foregroundColor(Color.from(description: workDataList[eventIndex].color ?? "green")) // イベント色を適用
                            .lineLimit(1)
                            .frame(width: 55, alignment: .leading)
                            .offset(x: 2)
                            .clipped()
                        RoundedRectangle(cornerRadius: 5, style: .continuous)
                            .stroke(Color.from(description: workDataList[eventIndex].color ?? "green"), lineWidth: 0.6)
                            .frame(width: 53, height: 15)
                    }
                    Spacer().frame(height: 5)
                }
            }


            if workDataList.count > 3 && weeknumber == 6 {
                Text("...")
                    .font(.system(size: 12))
                    .foregroundColor(.green)
                    .lineLimit(1)
                    .frame(width: 55, alignment: .leading)
            } else if workDataList.count > 4 {
                Text("...")
                    .font(.system(size: 12))
                    .foregroundColor(.green)
                    .lineLimit(1)
                    .frame(width: 55, alignment: .leading)
            }
        }
        .frame(maxWidth: 55, alignment: .leading)
    }

    
    func getEvents(for day: Int) -> [Event] {
        let currentDate = Calendar.current.date(from: DateComponents(year: self.year, month: self.month, day: day))!
        return eventList.filter { event in
            Calendar.current.isDate(event.startDate!, inSameDayAs: currentDate)
        }
    }
    
    func renderEventDetails(for day: Int, weeknumber: Int) -> some View {
        let events = getEvents(for: day)
        
        return VStack {
            ForEach(0..<min(4, events.count), id: \.self) { index in
                VStack {
                    ZStack {
                        // イベント名を表示
                        Text(events[index].name ?? "No Title")
                            .font(.system(size: 10)) // 少し小さいフォントサイズに調整
                            .foregroundColor(Color.from(description: events[index].color ?? "green")) // イベント色を適用
                            .lineLimit(1) // 1行に制限
                            .frame(width: 55, alignment: .leading)
                            .offset(x: 2)
                        
                        // 枠線の色をイベントの色に設定
                        RoundedRectangle(cornerRadius: 5, style: .continuous)
                            .stroke(Color.from(description: events[index].color ?? "green"), lineWidth: 0.6)
                            .frame(width: 53, height: 15)
                    }
                    Spacer().frame(height: 5)
                }
            }

            if events.count > 3 && weeknumber == 6 {
                Text("...")
                    .font(.system(size: 12))
                    .foregroundColor(.green)
                    .lineLimit(1)
                    .frame(width: 55, alignment: .leading)
            } else if events.count > 4 {
                Text("...")
                    .font(.system(size: 12))
                    .foregroundColor(.green)
                    .lineLimit(1)
                    .frame(width: 55, alignment: .leading)
            }
        }
        .frame(maxWidth: 55, alignment: .leading)
    }
    
    func renderCombinedEvents(for day: Int, weeknumber: Int) -> some View {
        // workData と events を取得
        let workDataList = getWorkData(for: day)
        let eventList = getEvents(for: day)
        
        // 両方を結合
        let combinedEvents = (workDataList as [Any]) + (eventList as [Any])
        
        let maxEventCount: Int = (weeknumber >= 6) ? 3 : 4
        let limitedEvents = Array(combinedEvents.prefix(maxEventCount))
        
        return VStack {
            // 最大4件を表示
            ForEach(0..<limitedEvents.count, id: \.self) { index in
                VStack {
                    ZStack {
                        // データの型に応じて表示内容を切り替え
                        if let workData = combinedEvents[index] as? WorkData {
                            // WorkData の表示
                            Text(workData.name ?? "No Title")
                                .font(.system(size: 10))
                                .foregroundColor(Color.from(description: workData.color ?? "black"))
                                .lineLimit(1)
                                .frame(width: 55, alignment: .leading)
                                .offset(x: 2)
                        } else if let event = combinedEvents[index] as? Event {
                            // Event の表示
                            Text(event.name ?? "No Title")
                                .font(.system(size: 10))
                                .foregroundColor(Color.from(description: event.color ?? "black"))
                                .lineLimit(1)
                                .frame(width: 55, alignment: .leading)
                                .offset(x: 2)
                        }
                        
                        // 枠線
                        RoundedRectangle(cornerRadius: 5, style: .continuous)
                            .stroke(Color.from(description: (combinedEvents[index] as? Event)?.color ?? (combinedEvents[index] as? WorkData)?.color ?? "green"), lineWidth: 0.6)
                            .frame(width: 53, height: 15)
                    }
                    Spacer().frame(height: 5)
                    
                }
            }
            if combinedEvents.count > 4 || (combinedEvents.count > 3 && weeknumber == 6) {
                Text("...")
                    .font(.system(size: 12))
                    .foregroundColor(.black)
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
                        
                        VStack(spacing: 0) {
                            Text("\(day)")
                                .font(.system(size: 20))
                                .foregroundColor(getTextColor(for: day))
                            
                            // 予定の表示を共通関数で呼び出す
                            renderCombinedEvents(for: day, weeknumber: GetWeekNumber(year: self.year, month: self.month))
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
                        
                        VStack(spacing: 0) {
                            Text("\(day)")
                                .font(.system(size: 20))
                                .foregroundColor(getTextColor(for: day))
                            
                            // 予定の表示を共通関数で呼び出す
                            renderCombinedEvents(for: day, weeknumber: GetWeekNumber(year: self.year, month: self.month))
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
                        
                        VStack(spacing: 0) {
                            Text("\(day)")
                                .font(.system(size: 20))
                                .foregroundColor(getTextColor(for: day))
                            
                            // 予定の表示を共通関数で呼び出す
                            renderCombinedEvents(for: day, weeknumber: GetWeekNumber(year: self.year, month: self.month))
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
                        
                        VStack(spacing: 0) {
                            Text("\(day)")
                                .font(.system(size: 20))
                                .foregroundColor(getTextColor(for: day))
                            
                            // 予定の表示を共通関数で呼び出す
                            renderCombinedEvents(for: day, weeknumber: GetWeekNumber(year: self.year, month: self.month))
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
                                renderCombinedEvents(for: day, weeknumber: GetWeekNumber(year: self.year, month: self.month))
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

