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
    @FetchRequest(entity: WorkData.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \WorkData.workDate, ascending: true)])
    var workDataList: FetchedResults<WorkData>
    
    @State private var targetWage: Double = 100000 // 目標給与の初期値
    
    private var totalWage: Int {
        // 現在時刻を基準に、終了日時が過去のデータのみ合計給与を計算
        workDataList.filter { workData in
            let now = Date()
            if let endTime = workData.endTime {
                return endTime <= now
            }
            return false
        }
        .reduce(0) { total, workData in
            total + calculateWage(for: workData)
        }
    }
    
    private func calculateWage(for workData: WorkData) -> Int {
        let hourlyWage = workData.money
        let premiumWages = workData.premiumWages
        let specialWages = workData.specialWages
        let startTime = workData.startTime ?? Date()
        let endTime = workData.endTime ?? Date()

        // 総労働時間を分単位（秒を繰り上げ）で計算
        let components = Calendar.current.dateComponents([.minute, .second], from: startTime, to: endTime)
        let minutes = components.minute ?? 0
        let seconds = components.second ?? 0
        let workingMinutes = seconds > 0 ? minutes + 1 : minutes

        // 深夜労働時間を計算（22:00〜翌5:00）
        let nightShiftStart = Calendar.current.date(bySettingHour: 22, minute: 0, second: 0, of: startTime) ?? startTime
        let nightShiftEnd = Calendar.current.date(bySettingHour: 5, minute: 0, second: 0, of: startTime.addingTimeInterval(24 * 60 * 60)) ?? startTime
        
        let nightShiftMinutes = calculateNightShiftMinutes(start: startTime, end: endTime, nightStart: nightShiftStart, nightEnd: nightShiftEnd)

        // 通常労働時間を深夜労働時間を除いて計算
        let regularMinutes = workingMinutes - nightShiftMinutes

        // 1分あたりの賃金
        let minuteWage = hourlyWage / 60.0
        let nightMinuteWage = premiumWages / 60.0

        // 通常給与と深夜給与の計算
        let regularWage = Double(regularMinutes) * minuteWage
        let nightWage = Double(nightShiftMinutes) * nightMinuteWage

        return Int(regularWage + nightWage + specialWages)
    }

    // 深夜労働時間を計算する関数
    private func calculateNightShiftMinutes(start: Date, end: Date, nightStart: Date, nightEnd: Date) -> Int {
        var nightShiftMinutes = 0
        
        if start < nightEnd && end > nightStart {
            let effectiveStart = max(start, nightStart)
            let effectiveEnd = min(end, nightEnd)
            let components = Calendar.current.dateComponents([.minute, .second], from: effectiveStart, to: effectiveEnd)
            let minutes = components.minute ?? 0
            let seconds = components.second ?? 0
            nightShiftMinutes = seconds > 0 ? minutes + 1 : minutes
        }
        return nightShiftMinutes
    }

    var body: some View {
        VStack {
            Text("合計給与")
                .font(.title)
                .padding()
            
            Text("合計給与: ¥\(totalWage)")
                .font(.headline)
            
            // 目標給与入力
            HStack {
                Text("目標給与:")
                TextField("目標を入力", value: $targetWage, format: .number)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    .frame(width: 150)
            }
            .padding()

            // 円グラフ表示
            GeometryReader { geometry in
                ZStack {
                    Circle()
                        .stroke(lineWidth: 20)
                        .opacity(0.3)
                        .foregroundColor(.gray)
                    
                    Circle()
                        .trim(from: 0.0, to: CGFloat(min(Double(totalWage) / targetWage, 1.0)))
                        .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round))
                        .foregroundColor(.blue)
                        .rotationEffect(.degrees(-90))
                    
                    Text("\(Int(min(Double(totalWage) / targetWage * 100, 100)))%")
                        .font(.headline)
                }
                .padding()
                .frame(width: geometry.size.width * 0.8, height: geometry.size.width * 0.8)
            }
            .frame(height: 200)

            Spacer()
        }
        .padding()
    }
}



