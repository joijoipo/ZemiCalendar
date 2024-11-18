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
            total + calculateWage(for: workData)
        }
    }
    
    private func calculateWage(for workData: WorkData) -> Int {
        let hourlyWage = workData.money
        let startTime = workData.startTime ?? Date()
        let endTime = workData.endTime ?? Date()

        let standardWorkingSeconds: Double = 8.0 * 3600.0
        let workingSeconds = endTime.timeIntervalSince(startTime)
        let regularSeconds = min(workingSeconds, standardWorkingSeconds)
        let overtimeSeconds = max(workingSeconds - standardWorkingSeconds, 0)

        let regularHours = (regularSeconds / 3600.0).rounded(.down)
        let overtimeHours = (overtimeSeconds / 3600.0).rounded(.down)

        let regularWage = hourlyWage * regularHours
        let overtimeWage = hourlyWage * 1.5 * overtimeHours

        return Int(regularWage + overtimeWage)
    }
    
    var body: some View {
        VStack {
            Text("合計給与")
                .font(.title)
                .padding()
            
            // ここで totalWage を表示
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
