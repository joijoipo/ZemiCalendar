//
//  wakudata.swift
//  Calendar17
//
//  Created by 出口葵葉 on 2024/11/07.
//

import SwiftUI

struct wakudata: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: WorkData.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \WorkData.workDate, ascending: true)])
    var workDataList: FetchedResults<WorkData>
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        formatter.timeZone = .current  // 現在のタイムゾーンを指定
        return formatter
    }()
    
    private func deleteWorkData(at offsets: IndexSet) {
            offsets.map { workDataList[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                print("Error deleting data: \(error)")
            }
        }


    var body: some View {
        List{
            ForEach(workDataList) { workData in
                VStack(alignment: .leading, spacing: 10) {
                    VStack(alignment: .leading) {
                        Text("名前: \(workData.name ?? "")").font(.headline)
                        Text("Date: \(workData.workDate ?? Date(), formatter: dateFormatter)").font(.subheadline)
                        Text("時給: ¥\(workData.money, specifier: "%.0f")").font(.subheadline)
                        Text("開始時刻: \(workData.startTime ?? Date(), formatter: dateFormatter)").font(.subheadline)
                        Text("終了時刻: \(workData.endTime ?? Date(), formatter: dateFormatter)").font(.subheadline)
                        Text("めも: \(workData.notes ?? "")").font(.subheadline)
                        Text("割増給料: ¥\(workData.premiumWages, specifier: "%.0f")").font(.subheadline)
                        Text("交通費: ¥\(workData.transportationCost, specifier: "%.0f")").font(.subheadline)
                        Text("更新した時間: \(workData.timeStamp ?? Date(), formatter: dateFormatter)").font(.subheadline)
                    }
                    .padding() // 内側にパディングを追加
                }
                .padding(.vertical, 5) // リスト項目の縦の間隔を調整
            }
            .onDelete(perform: deleteWorkData)
        }
    }
}

#Preview {
    wakudata()
}
