import SwiftUI
import CoreData
import Foundation

struct ContentView: View {
    @State private var selectedWorker: PartTimeList?
    @State private var hoursWorked: Double = 0.0
    @State private var money: Double = 0.0

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

            TextField("時給", value: $money, formatter: NumberFormatter())
                .keyboardType(.decimalPad)

            TextField("勤務時間", value: $hoursWorked, formatter: NumberFormatter())
                .keyboardType(.decimalPad)

            Button("勤務記録を追加") {
                addWorkRecord()
            }
        }
        ForEach(workers) { workData in
            VStack(alignment: .leading, spacing: 10) {
                VStack(alignment: .leading) {
                    Text("名前: \(workData.name ?? "")").font(.headline)
                    Text("時給: ¥\(workData.money, specifier: "%.0f")").font(.subheadline)
                }
            }
        }
        
        .padding()
    }

    func addWorkRecord() {
        guard let worker = selectedWorker else { return }

        let totalWage = hoursWorked * money
        print("給与計算: \(totalWage)")

        let workRecord = WorkData(context: managedObjectContext)
        workRecord.name = worker.name
        workRecord.money = worker.money
        workRecord.transportationCost = totalWage

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
