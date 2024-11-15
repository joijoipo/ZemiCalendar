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
    
    private var totalWage: Int {
        workDataList.reduce(0) { total, workData in
            let hourlyWage = workData.money  // 時給
            let startTime = workData.startTime ?? Date()
            let endTime = workData.endTime ?? Date()
            
            // 通常勤務時間の設定
            let standardWorkingSeconds: Double = 8.0 * 3600.0  // 8時間を秒に変換
            
            // 勤務時間の計算（秒単位）
            let workingSeconds = endTime.timeIntervalSince(startTime)  // 合計勤務時間（秒単位）
            
            // 通常勤務時間と残業時間を秒単位で分ける
            let regularSeconds = min(workingSeconds, standardWorkingSeconds)  // 最大でも8時間分の秒数
            let overtimeSeconds = max(workingSeconds - standardWorkingSeconds, 0)  // 8時間を超えた秒数
            
            // 給与計算（秒単位を時間単位に変換）
            let regularWage = hourlyWage * (regularSeconds / 3600.0)
            let overtimeWage = hourlyWage * 1.5 * (overtimeSeconds / 3600.0)
            
            // 給与合計を四捨五入して整数に
            return total + Int((regularWage + overtimeWage).rounded())
        }
    }
    
    var body: some View {
        VStack {
            Text("合計給与")
                .font(.title)
                .padding()
            
            Text("合計給与: ¥\(totalWage)")
                .font(.headline)
                .padding()

            Spacer()
        }
        .padding()
    }
}

#Preview {
    TotalCash()
}
