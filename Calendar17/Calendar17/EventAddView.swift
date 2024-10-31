//
//  EventAddView.swift
//  Calendar17
//
//  Created by 出口葵葉 on 2024/10/28.
//

import SwiftUI

struct EventAddView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var date: Date = Date()
    
    var body: some View {
        Form {
            TextField("タイトル", text: $title)
            TextField("説明", text: $description)
            DatePicker("日付", selection: $date, displayedComponents: .date)
            Button("予定を追加") {
                addEvent()
            }
        }
        .navigationTitle("予定の追加")
    }
    
    private func addEvent() {
        let newEvent = Event(context: viewContext)
        newEvent.title = title
        newEvent.eventDescription = description
        newEvent.date = date
        
        do {
            try viewContext.save()
        } catch {
            // エラーハンドリング
        }
    }
}

#Preview {
    EventAddView()
}
