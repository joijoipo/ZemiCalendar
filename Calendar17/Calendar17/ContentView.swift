import SwiftUI
import CoreData
import Foundation

struct ContentView: View {
    @State private var selectedWorker: PartTimeList?
    @State private var startTime = Date()
    @State private var endTime = Date()
    @State private var specialWages: Double = 0.0

    // FetchRequest の設定
    @FetchRequest(
        entity: PartTimeList.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \PartTimeList.name, ascending: true)]
    ) var workers: FetchedResults<PartTimeList>

    // @Environment を使って managedObjectContext を取得
    @Environment(\.managedObjectContext) private var managedObjectContext

    var body: some View {
        Form {
            Picker("アルバイトを選択", selection: $selectedWorker) {
                ForEach(workers, id: \.self) { worker in
                    Text(worker.name ?? "Unknown").tag(worker as PartTimeList?)
                }
            }
            HStack {
               Text("特別給料：")
                TextField("", value: $specialWages, formatter: NumberFormatter())
                .keyboardType(.decimalPad) // 数字入力をしやすくするためにキーボードを指定
            }
            DatePicker("開始日時", selection: $startTime, displayedComponents: [.date, .hourAndMinute])
            
            DatePicker("終了日時", selection: $endTime, displayedComponents: [.date, .hourAndMinute])
            Button("勤務記録を追加") {
                addWorkRecord()
            }
        }
    }

    func addWorkRecord() {
        guard let worker = selectedWorker else { return }

        

        let workRecord = WorkData(context: managedObjectContext)
        workRecord.name = worker.name
        workRecord.money = worker.money
        workRecord.transportationCost = worker.move
        workRecord.startTime = startTime
        workRecord.endTime = endTime
        workRecord.specialWages = specialWages

        do {
            try managedObjectContext.save() // 保存処理
        } catch {
            print("保存に失敗しました: \(error)")
        }
    }
}

#Preview {
    ContentView()
}
