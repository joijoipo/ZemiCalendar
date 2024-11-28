import SwiftUI
import CoreData

struct EditWorkDataView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: WorkData.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \WorkData.workDate, ascending: true)])
    var workDataList: FetchedResults<WorkData>
    
    @ObservedObject var worker: PartTimeList // 編集対象
    @Environment(\.dismiss) var dismiss // 画面を閉じるための環境変数

    var body: some View {
        VStack {
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
            
            Spacer()  // ボタンを下部に配置するためにスペースを確保
            
            // 削除ボタン
            Button("このアルバイトを削除") {
                deleteWorker()
                dismiss() // 削除後に画面を閉じる
            }
            .foregroundColor(.red)
            .frame(maxWidth: .infinity, maxHeight: 50) // ボタンを横幅いっぱいに広げる
            .background(Color.red.opacity(0.1)) // ボタン背景色
            .cornerRadius(10)
            .padding(.horizontal) // 横の余白
            .padding(.bottom) // 下の余白
        }
        .navigationBarItems(trailing: Button("完了") {
            saveContext()
            dismiss() // 編集を保存して戻る
        })
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

    // PartTimeList の削除
    private func deleteWorker() {
        viewContext.delete(worker) // `worker` を削除
        saveContext() // コンテキストを保存して変更を確定
    }
}

#Preview {
    EditWorkDataView(worker: PartTimeList())
}
