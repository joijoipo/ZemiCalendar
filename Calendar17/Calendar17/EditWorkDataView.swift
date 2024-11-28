//
//  EditWorkDataView.swift
//  Calendar17
//
//  Created by 冨成 祐羽 on 2024/11/28.
//

import SwiftUI

struct EditWorkDataView: View {
    @ObservedObject var workData: WorkData  // CoreDataのWorkDataを使用するため、ObservedObjectで監視
    
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
            
            Button("保存") {
                // 編集された内容を保存
                workData.name = workName
                workData.startTime = startTime
                workData.endTime = endTime
                
                // ここで変更内容を保存するために、CoreDataに変更を反映させる
                do {
                    try workData.managedObjectContext?.save()
                } catch {
                    print("保存エラー: \(error)")
                }
            }
            .padding()
        }
        .navigationTitle("アルバイト編集")
    }
}
