import SwiftUI
import CoreData

struct EditPartListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) var dismiss // 画面を閉じるための環境変数
    
    // 編集対象のworker
    @ObservedObject var worker: PartTimeList
    
    // 編集用の一時プロパティ
    @State private var name: String
    @State private var wage: String
    @State private var move: String
    @State private var premiumWages: String

    // イニシャライザ
    init(worker: PartTimeList) {
        self.worker = worker
        // 初期値を設定
        _name = State(initialValue: worker.name ?? "")
        _wage = State(initialValue: String(format: "%.2f", worker.money))
        _move = State(initialValue: String(format: "%.2f", worker.move))
        _premiumWages = State(initialValue: String(format: "%.2f", worker.premiumWages))
    }

    var body: some View {
        VStack {
            Form {
                Section(header: Text("基本情報")) {
                    // 名前の編集
                    TextField("名前", text: $name)
                    
                    // 時給の編集
                    HStack {
                        Text("時給: ¥")
                        TextField("時給を入力", text: $wage)
                            .keyboardType(.decimalPad)
                    }
                    
                    // 交通費の編集
                    HStack {
                        Text("交通費: ¥")
                        TextField("交通費を入力", text: $move)
                            .keyboardType(.decimalPad)
                    }
                    
                    HStack {
                        Text("深夜給料: ¥")
                        TextField("交通費を入力", text: $premiumWages)
                            .keyboardType(.decimalPad)
                    }
                }
            }
            .navigationTitle("編集: \(name)")
            
            Spacer()
            
            // 削除ボタン
            Button("このアルバイトを削除") {
                deleteWorker()
                dismiss()
            }
            .foregroundColor(.red)
            .frame(maxWidth: .infinity, maxHeight: 50)
            .background(Color.red.opacity(0.1))
            .cornerRadius(10)
            .padding(.horizontal)
            .padding(.bottom)
        }
        .navigationBarItems(trailing: Button("完了") {
            saveChanges()
            dismiss()
        })
    }

    // 編集内容を保存
    private func saveChanges() {
        // 入力値をworkerに反映
        worker.name = name
        
        if let wageValue = Double(wage) {
            worker.money = wageValue
        }
        
        if let transportationCostValue = Double(move) {
            worker.move = transportationCostValue
        }
        
        if let premiumWagesValue = Double(premiumWages) {
            worker.premiumWages = premiumWagesValue
        }

        // CoreDataに保存
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }

    // workerを削除
    private func deleteWorker() {
        viewContext.delete(worker)
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

#Preview {
    EditPartListView(worker: PartTimeList())
}
