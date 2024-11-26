
//
//  EditWorkDataView.swift
//  Calendar17
//
//  Created by 冨成 祐羽 on 2024/11/26.
//

import SwiftUI
import CoreData

struct EditWorkDataView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: WorkData.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \WorkData.workDate, ascending: true)])
    var workDataList: FetchedResults<WorkData>
    @ObservedObject var worker: WorkData // 編集対象

    @Environment(\.dismiss) var dismiss // 画面を閉じるための環境変数

    var body: some View {
        Form {
            Section(header: Text("基本情報")) {
                TextField("名前", text: Binding(
                    get: { worker.name ?? "" },
                    set: { worker.name = $0 }
                ))
                Stepper("時給: ¥\(worker.money)", value: $worker.money, in: 0...10000, step: 50)
            }
        }
        .navigationTitle("編集: \(worker.name ?? "")")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("完了") {
                    saveContext()
                    dismiss() // 編集を保存して戻る
                }
            }
        }
    }

    // Contextの保存
    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            // エラーハンドリング
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
