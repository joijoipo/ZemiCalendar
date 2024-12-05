//
//  EditWorkDataView.swift
//  Calendar17
//
//  Created by 冨成 祐羽 on 2024/11/28.
//

import SwiftUI

struct EditWorkDataView: View {
    @ObservedObject var workData: WorkData  // CoreDataのWorkDataを使用するため、ObservedObjectで監視
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) private var presentationMode // 画面を閉じるため

    @State private var workName: String
    @State private var startTime: Date
    @State private var endTime: Date

    init(workData: WorkData) {
        self.workData = workData
        _workName = State(initialValue: workData.name ?? "")
        _startTime = State(initialValue: workData.startTime ?? Date())
        _endTime = State(initialValue: workData.endTime ?? Date())
    }

    var body: some View {
        Form {
            Section(header: Text("アルバイト情報の編集")) {
                TextField("仕事の名前", text: $workName)

                DatePicker("開始時間", selection: $startTime, displayedComponents: .hourAndMinute)

                DatePicker("終了時間", selection: $endTime, displayedComponents: .hourAndMinute)
            }

            HStack {
                Button("保存") {
                    saveWorkData()
                }
                .buttonStyle(.borderedProminent)

                Button("削除") {
                    deleteWorkData()
                }
                .buttonStyle(.bordered)
                .foregroundColor(.red)
            }
        }
        .navigationTitle("アルバイト編集")
    }

    private func saveWorkData() {
        workData.name = workName
        workData.startTime = startTime
        workData.endTime = endTime

        do {
            try viewContext.save()
            presentationMode.wrappedValue.dismiss() // 保存後に画面を閉じる
        } catch {
            print("保存エラー: \(error)")
        }
    }

    private func deleteWorkData() {
        viewContext.delete(workData) // Core Data から削除
        do {
            try viewContext.save()
            presentationMode.wrappedValue.dismiss() // 削除後に画面を閉じる
        } catch {
            print("削除エラー: \(error)")
        }
    }
}
