//
//  TotalCash.swift
//  Calendar17
//
//  Created by 出口葵葉 on 2024/10/31.
//

import SwiftUI
import CoreData

struct TotalCash: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        entity: WorkData.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \WorkData.workDate, ascending: true)]
    )
    var workDataList: FetchedResults<WorkData>
    
    @State private var targetWage: Double = 100000 // 目標給与の初期値

    // 合計給与
    private var totalWage: Int {
        workDataList
            .filter { $0.isPastWork() }
            .reduce(0) { $0 + calculateWage(for: $1) }
    }
    
    // 合計勤務時間（分単位）
    private var totalWorkingMinutes: Int {
        workDataList
            .filter { $0.isPastWork() }
            .reduce(0) { $0 + calculateWorkingMinutes(for: $1) }
    }
    
    // 合計勤務時間を「○時間○分」の形式でフォーマット
    private var formattedWorkingHours: String {
        let hours = totalWorkingMinutes / 60
        let minutes = totalWorkingMinutes % 60
        return "\(hours)時間 \(minutes)分"
    }

    // 給与計算
    private func calculateWage(for workData: WorkData) -> Int {
        let hourlyWage = workData.money
        let premiumWages = workData.premiumWages
        let specialWages = workData.specialWages
        let startTime = workData.startTime ?? Date()
        let endTime = workData.endTime ?? Date()

        // 労働時間を計算（分単位）
        let totalMinutes = calculateMinutes(from: startTime, to: endTime)
        let nightShiftMinutes = calculateNightShiftMinutes(start: startTime, end: endTime)
        let regularMinutes = totalMinutes - nightShiftMinutes

        // 給与計算
        let regularWage = Double(regularMinutes) * (hourlyWage / 60.0)
        let nightWage = Double(nightShiftMinutes) * (premiumWages / 60.0)

        return Int(regularWage + nightWage + specialWages)
    }
    
    // 勤務時間計算
    private func calculateWorkingMinutes(for workData: WorkData) -> Int {
        let startTime = workData.startTime ?? Date()
        let endTime = workData.endTime ?? Date()
        return calculateMinutes(from: startTime, to: endTime)
    }

    // 2つの日付間の深夜勤務時間を計算
    private func calculateNightShiftMinutes(start: Date, end: Date) -> Int {
        let nightStart = Calendar.current.date(bySettingHour: 22, minute: 0, second: 0, of: start) ?? start
        let nightEnd = Calendar.current.date(bySettingHour: 5, minute: 0, second: 0, of: start.addingTimeInterval(24 * 60 * 60)) ?? start
        return calculateOverlapMinutes(start: start, end: end, rangeStart: nightStart, rangeEnd: nightEnd)
    }

    // 重複時間を計算
    private func calculateOverlapMinutes(start: Date, end: Date, rangeStart: Date, rangeEnd: Date) -> Int {
        guard start < rangeEnd && end > rangeStart else { return 0 }
        let overlapStart = max(start, rangeStart)
        let overlapEnd = min(end, rangeEnd)
        return calculateMinutes(from: overlapStart, to: overlapEnd)
    }

    // 分数を計算
    private func calculateMinutes(from start: Date, to end: Date) -> Int {
        let components = Calendar.current.dateComponents([.minute, .second], from: start, to: end)
        let minutes = components.minute ?? 0
        let seconds = components.second ?? 0
        return seconds > 0 ? minutes + 1 : minutes
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // ヘッダー
            VStack {
                Text("給与管理")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                
            }
            .padding(.top)
            
            // カードビュー
            VStack(spacing: 15) {
                // 合計給与カード
                CardView(title: "合計給与", value: "¥\(totalWage)", icon: "yen")
                // 合計勤務時間カード
                CardView(title: "合計勤務時間", value: formattedWorkingHours, icon: "clock")
            }
            .padding()
            
            // 円グラフ
            GeometryReader { geometry in
                ZStack {
                    Circle()
                        .stroke(lineWidth: 15)
                        .opacity(0.3)
                        .foregroundColor(.gray)
                    
                    Circle()
                        .trim(from: 0.0, to: CGFloat(min(Double(totalWage) / targetWage, 1.0)))
                        .stroke(style: StrokeStyle(lineWidth: 15, lineCap: .round))
                        .foregroundColor(.blue)
                        .rotationEffect(.degrees(-90))
                    
                    VStack(spacing: 8) {
                        Text("\(Int(min(Double(totalWage) / targetWage * 100, 100)))%")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                        Text("達成率")
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                }
                .frame(width: geometry.size.width * 0.7, height: geometry.size.width * 0.7)
                .padding()
            }
            .frame(height: 250)
            
            // 目標給与入力
            HStack {
                Text("目標給与:")
                    .font(.headline)
                TextField("入力してください", value: $targetWage, format: .number)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    .frame(width: 150)
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .padding()
        .background(Color(.systemGroupedBackground))
        .edgesIgnoringSafeArea(.all)
    }
}

struct CardView: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.title)
                .foregroundColor(.blue)
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.gray)
                Text(value)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
            }
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}

extension WorkData {
    func isPastWork() -> Bool {
        guard let endTime = self.endTime else { return false }
        return endTime <= Date()
    }
}






