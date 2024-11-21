//
//  wakudata.swift
//  Calendar17
//
//  Created by 出口葵葉 on 2024/11/07.
//

import SwiftUI

struct wakudata: View {
    @Environment(\.managedObjectContext) private var viewContext

    // WorkData の FetchRequest
    let workDataFetchRequest: FetchRequest<WorkData> = FetchRequest(
        entity: WorkData.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \WorkData.startTime, ascending: true)]
    )
    var workDataList: FetchedResults<WorkData> {
        workDataFetchRequest.wrappedValue
    }

    // Event の FetchRequest
    let eventFetchRequest: FetchRequest<Event> = FetchRequest(
        entity: Event.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Event.startDate, ascending: true)]
    )
    var eventList: FetchedResults<Event> {
        eventFetchRequest.wrappedValue
    }
    
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
    
    private func deleteEvent(at offsets: IndexSet) {
            offsets.map { eventList[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                print("Error deleting data: \(error)")
            }
        }


    var body: some View {
        List{
            Text("アルバイト↓")
            ForEach(workDataList) { workData in
                VStack(alignment: .leading, spacing: 10) {
                    VStack(alignment: .leading) {
                        Text("名前: \(workData.name ?? "")").font(.headline)
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
            
            Text("イベント↓")
            ForEach(eventList) { Event in
                VStack(alignment: .leading, spacing: 10) {
                    VStack(alignment: .leading) {
                        Text("名前: \(Event.name ?? "")").font(.headline)
                        Text("メモ: \(Event.memo ?? "")").font(.subheadline)
                        Text("開始時刻: \(Event.startDate ?? Date(), formatter: dateFormatter)").font(.subheadline)
                        Text("終了時刻: \(Event.endDate ?? Date(), formatter: dateFormatter)").font(.subheadline)
                        Text("色: \(Event.color ?? "")").font(.subheadline)
                    }
                    .padding() // 内側にパディングを追加
                }
                .padding(.vertical, 5) // リスト項目の縦の間隔を調整
            }
            .onDelete(perform: deleteEvent)
        }
    }
}

#Preview {
    wakudata()
}
