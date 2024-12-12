//
//  EditEventView.swift
//  Calendar17
//
//  Created by 冨成 祐羽 on 2024/12/03.
//

//
//  EditEventView.swift
//  Calendar17
//
//  Created by 冨成 祐羽 on 2024/12/03.
//

import SwiftUI

struct EditEventView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var event: Event
    @Environment(\.presentationMode) private var presentationMode

    @State private var name: String
    @State private var startDate: Date
    @State private var endDate: Date

    init(event: Event) {
        self.event = event
        _name = State(initialValue: event.name ?? "")
        _startDate = State(initialValue: event.startDate ?? Date())
        _endDate = State(initialValue: event.endDate ?? Date())
    }

    var body: some View {
        Form {
            TextField("イベント名", text: $name)

            DatePicker("開始日時", selection: $startDate, displayedComponents: [.date, .hourAndMinute])

            DatePicker("終了日時", selection: $endDate, displayedComponents: [.date, .hourAndMinute])
            
            Text("名前: \(event.color ?? "")").font(.headline)

            HStack {
                Button("保存") {
                    saveEvent()
                }
                .buttonStyle(.borderedProminent)

                Button("削除") {
                    deleteEvent()
                }
                .buttonStyle(.bordered)
                .foregroundColor(.red)
            }
        }
        .padding()
    }

    private func saveEvent() {
        event.name = name
        event.startDate = startDate
        event.endDate = endDate

        do {
            try viewContext.save()
            presentationMode.wrappedValue.dismiss() // 保存後に画面を閉じる
        } catch {
            print("イベントの保存に失敗しました: \(error)")
        }
    }

    private func deleteEvent() {
        viewContext.delete(event)
        do {
            try viewContext.save()
            presentationMode.wrappedValue.dismiss() // 削除後に画面を閉じる
        } catch {
            print("イベントの削除に失敗しました: \(error)")
        }
    }
}
