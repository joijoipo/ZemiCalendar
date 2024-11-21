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
        workDataList.reduce(0) { total, workData in
            total + calculateWage(for: workData)
        }
    }
    
    private func calculateWage(for workData: WorkData) -> Int {
        let hourlyWage = workData.money
        let startTime = workData.startTime ?? Date()
        let endTime = workData.endTime ?? Date()

        // 総労働時間を分単位（秒を繰り上げ）で計算
        let components = Calendar.current.dateComponents([.minute, .second], from: startTime, to: endTime)
        let minutes = components.minute ?? 0
        let seconds = components.second ?? 0
        let workingMinutes = seconds > 0 ? minutes + 1 : minutes

        // 通常労働時間と残業時間を分ける
        let standardWorkingMinutes: Int = 8 * 60 // 8時間分の分数
        let regularMinutes = min(workingMinutes, standardWorkingMinutes)
        let overtimeMinutes = max(workingMinutes - standardWorkingMinutes, 0)

        // 1分あたりの賃金
        let minuteWage = hourlyWage / 60.0

        // 通常給与と残業給与の計算
        let regularWage = Double(regularMinutes) * minuteWage
        let overtimeWage = Double(overtimeMinutes) * minuteWage * 1.5

        return Int(regularWage + overtimeWage)
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


#Preview {
    TotalCash()
}
