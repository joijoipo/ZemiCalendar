import SwiftUI
import CoreData
import FirebaseFirestore

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

    private func saveChanges() {

        // 入力値を worker に反映
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

        // Firestore への保存処理
        let db = Firestore.firestore()
        let workerData: [String: Any] = [
            "name": worker.name ?? "無名",  // もしnameがnilの場合、"無名"をデフォルトに
            "money": worker.money,
            "move": worker.move,
            "premiumWages": worker.premiumWages
        ]
        
        db.collection("partTimeList").addDocument(data: workerData){ error in
            if let error = error {
                print("Firestore への保存に失敗しました: \(error.localizedDescription)")
            } else {
                print("Firestore にデータが保存されました")
            }
        }

        // CoreData に保存
        do {
            try viewContext.save()
            print("CoreData にデータが保存されました: \(worker.name ?? "無名")")
        } catch {
            let nsError = error as NSError
            print("CoreData の保存に失敗しました: \(nsError), \(nsError.userInfo)")
        }
    }


    // workerを削除
    private func deleteWorker() {
        // Firestore から削除
        let db = Firestore.firestore()
        db.collection("partTimeList")
            .whereField("name", isEqualTo: worker.name ?? "") // 名前で検索（固有IDがあればそちらを使用）
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Firestore の削除に失敗しました: \(error.localizedDescription)")
                    return
                }
                for document in querySnapshot?.documents ?? [] {
                    db.collection("partTimeList").document(document.documentID).delete { err in
                        if let err = err {
                            print("Firestore の削除に失敗しました: \(err.localizedDescription)")
                        } else {
                            print("Firestore のデータを削除しました")
                        }
                    }
                }
            }
        
        // CoreData から削除
        viewContext.delete(worker)
        do {
            try viewContext.save()
            print("CoreData から削除しました")
        } catch {
            let nsError = error as NSError
            print("CoreData の削除に失敗しました: \(nsError), \(nsError.userInfo)")
        }
    }

}

#Preview {
    EditPartListView(worker: PartTimeList())
}
