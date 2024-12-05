import SwiftUI
import CoreData

struct AddWorkDataView: View {
    @FetchRequest(entity: WorkData.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \WorkData.workDate, ascending: true)])
    var workDataList: FetchedResults<WorkData>
    
    @FetchRequest(entity: PartTimeList.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \PartTimeList.name, ascending: true)])
    var workers: FetchedResults<PartTimeList>

    @Environment(\.managedObjectContext) private var viewContext
    
    @State var startTime: Date
    @State var endTime: Date
    @State private var selectedWorker: PartTimeList?
    @State private var workDate = Date()
    @State private var breakTime: Double? = nil
    @State private var transportationCost: Double? = nil
    @State private var name = ""
    @State private var notes = ""
    @State private var money: Double? = nil
    @State private var premiumWages: Double = 0
    @State private var specialWages: Double? = nil
    @State private var showingAddWorkDataView = false

    var body: some View {
        Form {
            // アルバイト選択のPicker
            Picker("アルバイトを選択", selection: $selectedWorker) {
                ForEach(workers, id: \.self) { worker in
                    Text(worker.name ?? "Unknown").tag(worker as PartTimeList?)
                }
            }

            // 特別給料
            HStack {
                Text("特別給料：")
                TextField("", value: $specialWages, formatter: currencyFormatter)
                    .keyboardType(.decimalPad)
            }

            // 開始日時と終了日時
            DatePicker("開始日時", selection: $startTime, displayedComponents: [.date, .hourAndMinute])
            DatePicker("終了日時", selection: $endTime, displayedComponents: [.date, .hourAndMinute])

            // 交通費
            HStack {
                Text("交通費：")
                TextField("", value: $transportationCost, formatter: currencyFormatter)
            }

            // 名前とノート
            TextField("name", text: $name)
            TextField("Notes", text: $notes)

            // 保存ボタン
            Button("保存する") {
                addWorkData()
            }

            // 作業データリストを表示
            ForEach(workDataList, id: \.self) { workData in
                HStack {
                    Text("\(workData.name ?? "Unknown") \(workData.startTime) ~ \(workData.endTime)")
                }
            }
        }
        .padding()

        // アルバイト一覧ボタン
        Button("アルバイト一覧") {
            showingAddWorkDataView.toggle()
        }
        .sheet(isPresented: $showingAddWorkDataView) {
            wakudata() // 必要に応じてアルバイト一覧画面を表示
        }
    }

    // 作業データ保存用関数
    private func addWorkData() {
        let newWorkData = WorkData(context: viewContext)
        newWorkData.timeStamp = Date()
        newWorkData.workDate = workDate
        newWorkData.startTime = startTime
        newWorkData.endTime = endTime
        newWorkData.breakTime = breakTime ?? 0
        newWorkData.transportationCost = transportationCost ?? 0
        newWorkData.name = name
        newWorkData.notes = notes
        newWorkData.money = money ?? 0
        newWorkData.premiumWages = premiumWages
        newWorkData.specialWages = specialWages ?? 0

        do {
            try viewContext.save()
        } catch {
            print("Error saving data: \(error)")
        }
    }

    // NumberFormatterの設定
    private var currencyFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }

    // 日付フォーマット用のDateFormatter
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter
    }
}
