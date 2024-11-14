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
    
    private var totalWage: Double {
        workDataList.reduce(0) { total, workData in
            let hourlyWage = workData.money  // 時給
            let startTime = workData.startTime ?? Date()
            let endTime = workData.endTime ?? Date()
            let overtime = workData.overTime ?? Date()
            
            // 通常勤務時間の計算 (通常勤務時間を8時間に設定)
            let workingHours = endTime.timeIntervalSince(startTime) / 3600.0
            let standardWorkingHours: Double = 8.0 // 通常勤務時間を8時間と仮定
            let regularHours = max(workingHours - standardWorkingHours, 0)  // 通常勤務時間
            let overtimeHours = max(overtime.timeIntervalSince(startTime) / 3600.0, 0)  // 残業時間
            
            // 給与計算
            let regularWage = hourlyWage * regularHours
            let overtimeWage = hourlyWage * 1.5 * overtimeHours  // 残業代（1.5倍）
            
            return total + regularWage + overtimeWage
        }
    }
    
    var body: some View {
        VStack {
            Text("合計給与")
                .font(.title)
                .padding()
            
            Text("合計給与: ¥\(totalWage, specifier: "%.2f")")
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
