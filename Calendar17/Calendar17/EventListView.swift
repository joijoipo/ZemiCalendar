import SwiftUI
import CoreData

struct EventListView: View {
    @FetchRequest(
        entity: Event.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Event.startDate, ascending: true)]
    ) var events: FetchedResults<Event>
    
    var body: some View {
        NavigationView {
            List {
                ForEach(events) { event in
                    HStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.from(description: event.color ?? "blue"))
                            .frame(width: 10, height: 50)
                        
                        VStack(alignment: .leading) {
                            Text(event.name ?? "No Name")
                                .font(.headline)
                            Text("開始: \(event.startDate ?? Date(), formatter: dateFormatter)")
                                .font(.subheadline)
                        }
                    }
                }
            }
            .navigationTitle("イベント一覧")
        }
    }
    
    // 日付のフォーマット
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }
}
//
//  EventListView.swift
//  Calendar17
//
//  Created by 冨成 祐羽 on 2024/12/23.
//

