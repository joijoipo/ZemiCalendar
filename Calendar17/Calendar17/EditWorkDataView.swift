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
    @FetchRequest(
        entity: PartTimeList.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \PartTimeList.name, ascending: true)]
    ) var workers: FetchedResults<PartTimeList>

    @State private var selectedWorker: PartTimeList?
    @State private var workName: String
    @State private var startTime: Date
    @State private var endTime: Date
    @State private var realSTime: Date
    @State private var realETime: Date

    init(workData: WorkData) {
        self.workData = workData
        _workName = State(initialValue: workData.name ?? "")
        _startTime = State(initialValue: workData.startTime ?? Date())
        _endTime = State(initialValue: workData.endTime ?? Date())
        _realSTime = State(initialValue: workData.realSTime ?? workData.startTime ?? Date())
        _realETime = State(initialValue: workData.realETime ?? workData.endTime ?? Date())
    }

    var body: some View {
        Form {
            Section(header: Text("アルバイト情報の編集")) {
                Picker("アルバイトを選択", selection: $selectedWorker) {
                    ForEach(workers, id: \.self) { worker in
                        Text(worker.name ?? "Unknown").tag(worker as PartTimeList?)
                    }
                }

                DatePicker("開始時間", selection: $startTime, displayedComponents: [.date, .hourAndMinute])

                DatePicker("終了時間", selection: $endTime, displayedComponents: [.date, .hourAndMinute])
                
                DatePicker("実際の開始時間", selection: $realSTime, displayedComponents: [.date, .hourAndMinute])

                DatePicker("実際の終了時間", selection: $realETime, displayedComponents: [.date, .hourAndMinute])
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
        guard let worker = selectedWorker else { return }
        
        workData.name = worker.name
        workData.startTime = startTime
        workData.endTime = endTime
        workData.realSTime = realSTime
        workData.realETime = realETime

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
