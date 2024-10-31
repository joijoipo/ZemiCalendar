//
//  ContentView.swift
//  Calendar17
//
//  Created by 出口葵葉 on 2024/09/24.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedDate: Date? = nil
    @State private var isShowingAddEventView: Bool = false
    @State private var events: [Date: [String]] = [:] // 日付ごとの予定を保持する辞書
    @State private var currentMonthDates: [Date] = [] // 今月の日付リスト

    let calendar = Calendar.current

    var body: some View {
        VStack {
            Text("カレンダー")
                .font(.largeTitle)
                .padding()

            // カレンダーの日付をグリッド表示
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
                ForEach(currentMonthDates, id: \.self) { date in
                    VStack {
                        // 日付の表示
                        Text("\(calendar.component(.day, from: date))")
                            .font(.headline)
                            .padding(5)
                            .background(Color.blue.opacity(0.2))
                            .cornerRadius(1)
                        
                        // 該当する日付の予定を表示
                        if let eventList = events[date] {
                            ForEach(eventList.prefix(2), id: \.self) { event in
                                Text(event)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                    .lineLimit(1)
                            }
                            // 予定が多すぎる場合は「…」で続きがあることを示す
                            if eventList.count > 2 {
                                Text("…")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, minHeight: 60)
                    .padding()
                    .onTapGesture {
                        // 日付をタップしたときの処理
                        self.selectedDate = date
                        self.isShowingAddEventView = true
                    }
                }
            }
            .padding()
            .onAppear {
                // 現在の月の日付リストを初期化
                let today = Date()
                let range = calendar.range(of: .day, in: .month, for: today)!
                self.currentMonthDates = range.compactMap { day -> Date? in
                    calendar.date(byAdding: .day, value: day - 1, to: today.startOfMonth())
                }
            }

            // シートを表示して予定追加画面に遷移
            .sheet(isPresented: $isShowingAddEventView) {
                if let selectedDate = selectedDate {
                    EventAddView()
                }
            }
        }
    }
}

// 予定追加画面のビュー
struct AddEventView: View {
    let date: Date
    @Binding var events: [Date: [String]]
    @State private var newEvent: String = ""

    var body: some View {
        VStack {
            Text("予定を追加\(date.formatted())")
                .font(.title2)
                .padding()

            TextField("予定を入力してください", text: $newEvent)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button(action: {
                // 新しい予定を保存
                if !newEvent.isEmpty {
                    events[date, default: []].append(newEvent)
                    newEvent = ""
                }
            }) {
                Text("追加")
                    .font(.title3)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            Spacer()
        }
        .padding()
    }
}

// Date拡張で月初の日付を取得するメソッドを追加
extension Date {
    func startOfMonth() -> Date {
        Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: self))!
    }
}

#Preview {
    ContentView()
}
