import SwiftUI
import CoreData

struct AddWorkDataView: View {
    @FetchRequest(entity: WorkData.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \WorkData.workDate, ascending: true)])
    var workDataList: FetchedResults<WorkData>
    
    @FetchRequest(entity: PartTimeList.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \PartTimeList.name, ascending: true)])
    var workers: FetchedResults<PartTimeList>

    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) private var presentationMode // 画面を閉じるため
    
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
    @State private var color: Color = .blue
    
    private let presetColors: [(color: Color, name: String)] = [
        (.blue, "青"), (.red, "赤"), (.green, "緑"),
        (.orange, "オレンジ"), (.purple, "紫"), (.black, "黒")
    ]
    private let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    
    init(startTime: Date = Date(), endTime: Date = Date()) {
        _startTime = State(initialValue: startTime)
        _endTime = State(initialValue: endTime)
    }

    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    // フォーム部分
                    ScrollView {
                        Form {
                            Section(header: Text("勤務データ")) {
                                Picker("アルバイトを選択", selection: $selectedWorker) {
                                    Text("未選択").tag(nil as PartTimeList?)
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

                                TextField("メモ", text: $notes)
                                
                                Section(header: Text("イベントカラー")) {
                                    LazyVGrid(columns: columns, spacing: 20) {
                                        ForEach(presetColors, id: \.name) { preset in
                                            VStack {
                                                Circle()
                                                    .fill(preset.color)
                                                    .frame(width: 40, height: 40)
                                                    .overlay(
                                                        Circle()
                                                            .stroke(preset.color == color ? Color.black : Color.clear, lineWidth: 2)
                                                    )
                                                    .onTapGesture {
                                                        color = preset.color
                                                    }
                                                Text(preset.name)
                                                    .font(.caption)
                                            }
                                        }
                                    }
                                    .padding(.vertical)
                                }
                            }
                        }
                        .padding(.horizontal)
                        .frame(height: geometry.size.height * 0.6) // フォームの高さを調整
                    }
                    .background(Color(UIColor.systemGroupedBackground))

                    Divider()

                    // リスト部分
                    VStack(alignment: .leading, spacing: 10) {
                        Text("過去の勤務履歴から追加(過去10件)↓")
                            .font(.system(size: 30))
                            .padding([.top, .horizontal])

                        List {
                            ForEach(workDataList, id: \.id) { workData in
                                Button(action: {
                                    print("選択された勤務データ: \(workData.name ?? "未設定")")
                                    saveWorkData(from: workData)
                                }) {
                                    HStack {
                                        let startTime = workData.startTime.flatMap { timeFormatter.string(from: $0) } ?? "未設定"
                                        let endTime = workData.endTime.flatMap { timeFormatter.string(from: $0) } ?? "未設定"
                                            Text(workData.name ?? "未設定")
                                                .font(.headline)
                                            Text("\(startTime) ~ \(endTime)")
                                                .font(.subheadline)
                                                .foregroundColor(.gray)
                                    }
                                }
                            }
                        }
                        .scrollContentBackground(.hidden) // デフォルトの背景を隠す
                        .background(Color.gray) // 新しい背景色を指定
                    }
                    .frame(maxHeight: geometry.size.height * 0.4) // リストの高さを調整
                }
            }
            .navigationBarItems(trailing: Button(action: {
                addWorkData()
            }) {
                Text("保存")
                    .foregroundColor(.blue)
            })
        }
    }



    // 選択された勤務データを保存
    private func saveWorkData(from workData: WorkData) {
        let worker = selectedWorker

        // workData.startTime から時間部分を取り出し、startTime の日付部分と組み合わせる
        let calendar = Calendar.current
        
        // workData.startTime から時間を取り出す
        let workStartHour = calendar.component(.hour, from: workData.startTime ?? Date())
        let workStartMinute = calendar.component(.minute, from: workData.startTime ?? Date())
        
        // workData.endTime から時間を取り出す
        let workEndHour = calendar.component(.hour, from: workData.endTime ?? Date())
        let workEndMinute = calendar.component(.minute, from: workData.endTime ?? Date())

        // startTime の日付部分を取り出す
        let startDateComponents = calendar.dateComponents([.year, .month, .day], from: startTime)

        // endTime の日付部分を取り出す
        let endDateComponents = calendar.dateComponents([.year, .month, .day], from: endTime)

        // startTime の日付部分と workData.startTime の時間部分を組み合わせる
        let updatedStartTime = calendar.date(bySettingHour: workStartHour,
                                             minute: workStartMinute,
                                             second: 0,
                                             of: calendar.date(from: startDateComponents) ?? Date()) ?? Date()

        // endTime の日付部分と workData.endTime の時間部分を組み合わせる
        var updatedEndTime = calendar.date(bySettingHour: workEndHour,
                                           minute: workEndMinute,
                                           second: 0,
                                           of: calendar.date(from: endDateComponents) ?? Date()) ?? Date()

        // 日付をまたぐ場合の処理
        if workData.endTime ?? Date() < workData.startTime ?? Date() {
            // 終了時間が開始時間より前なら、翌日に設定
            updatedEndTime = calendar.date(byAdding: .day, value: 1, to: updatedEndTime) ?? updatedEndTime
        }


        let newWorkData = WorkData(context: viewContext)
        newWorkData.timeStamp = Date()
        newWorkData.workDate = self.workDate
        newWorkData.startTime = updatedStartTime // 組み合わせた新しい startTime を保存
        newWorkData.endTime = updatedEndTime // 組み合わせた新しい endTime を保存
        newWorkData.breakTime = breakTime ?? 0
        newWorkData.transportationCost = transportationCost ?? 0
        newWorkData.name = workData.name
        newWorkData.notes = notes
        newWorkData.money = money ?? 0
        newWorkData.premiumWages = premiumWages
        newWorkData.specialWages = specialWages ?? 0

        do {
            try viewContext.save()
            print("勤務データが保存されました: \(newWorkData)")
            presentationMode.wrappedValue.dismiss() // 保存後に画面を閉じる
        } catch {
            print("エラー: 勤務データの保存に失敗しました - \(error)")
        }
    }



    // 作業データ保存用関数
    private func addWorkData() {
        guard let worker = selectedWorker else { return }
        
        let newWorkData = WorkData(context: viewContext)
        newWorkData.timeStamp = Date()
        newWorkData.workDate = workDate
        newWorkData.startTime = startTime
        newWorkData.endTime = endTime
        newWorkData.breakTime = breakTime ?? 0
        newWorkData.transportationCost = transportationCost ?? 0
        newWorkData.name = worker.name
        newWorkData.notes = notes
        newWorkData.money = worker.money
        newWorkData.premiumWages = worker.premiumWages
        newWorkData.specialWages = specialWages ?? 0
        newWorkData.color = color.description

        do {
            try viewContext.save()
            presentationMode.wrappedValue.dismiss() // 保存後に画面を閉じる
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
    let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm" // 24時間形式（例: 14:30）
        return formatter
    }()
    
    func splitDate(_ date: Date?) -> (year: Int?, month: Int?, day: Int?) {
        guard let date = date else {
            // nilの場合はnilを返す
            return (nil, nil, nil)
        }
        
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        
        return (year, month, day)
    }
}
