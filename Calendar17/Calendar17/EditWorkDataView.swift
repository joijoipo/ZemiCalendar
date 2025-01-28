//
//  EditWorkDataView.swift
//  Calendar17
//
//  Created by 冨成 祐羽 on 2024/11/28.
//

import SwiftUI
import FirebaseFirestore

struct EditWorkDataView: View {
    @ObservedObject var workData: WorkData  // CoreDataのWorkDataを使用するため、ObservedObjectで監視
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) private var presentationMode // 画面を閉じるため
    
    @FetchRequest(entity: PartTimeList.entity(),sortDescriptors: [NSSortDescriptor(keyPath: \PartTimeList.name, ascending: true)])
    var workers: FetchedResults<PartTimeList>
    
    @FetchRequest(entity: WorkData.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \WorkData.workDate, ascending: true)])
    var workDataList: FetchedResults<WorkData>

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
            Section(header: Text("{\(workName)}の編集")) {

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
        
        workData.startTime = startTime
        workData.endTime = endTime
        workData.realSTime = realSTime
        workData.realETime = realETime
        
        let db = Firestore.firestore()
            let workDataDict: [String: Any] = [
                "startTime": workData.startTime ?? Date(),
                "endTime": workData.endTime ?? Date(),
                "realSTime": workData.realSTime ?? Date(),
                "realETime": workData.realETime ?? Date()
            ]

            db.collection("workData").addDocument(data: workDataDict) { error in
                if let error = error {
                    print("Firestoreへの作業データ保存に失敗しました: \(error.localizedDescription)")
                } else {
                    print("作業データがFirestoreに保存されました")
                }
            }

        do {
            try viewContext.save()
            viewContext.refresh(workData, mergeChanges: true)
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
