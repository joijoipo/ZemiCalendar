import SwiftUI
import CoreData

struct AddEventView: View {
    @State var startDate: Date
    @State var endDate: Date
    // イベントの入力データを保持するプロパティ
    @State private var name: String = ""
    @State private var memo: String = ""
    @State private var isNotificationEnabled: Bool = false
    @State private var notificationTime: Date = Date()
    @State private var isRecurring: Bool = false
    @State private var recurrenceRule: String = ""
    @State private var color: Color = .blue
    
    @Environment(\.presentationMode) var presentationMode // モーダルを閉じるために使用
    
    // プリセットカラーの配列と色名
    private let presetColors: [(color: Color, name: String)] = [
        (.blue, "青"), (.red, "赤"), (.green, "緑"),
        (.orange, "オレンジ"), (.purple, "紫"), (.yellow, "黄色")
    ]
    
    private let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("イベント情報")) {
                    TextField("イベント名", text: $name)
                        .textInputAutocapitalization(.words)
                    
                    TextField("メモ", text: $memo)
                        .textInputAutocapitalization(.sentences)
                    
                    DatePicker("開始日時", selection: $startDate, displayedComponents: [.date, .hourAndMinute])
                    
                    DatePicker("終了日時", selection: $endDate, displayedComponents: [.date, .hourAndMinute])
                }
                
                Section(header: Text("通知設定")) {
                    Toggle("通知を有効にする", isOn: $isNotificationEnabled)
                    
                    if isNotificationEnabled {
                        DatePicker("通知時間", selection: $notificationTime, displayedComponents: [.date, .hourAndMinute])
                    }
                }
                
                Section(header: Text("繰り返し設定")) {
                    Toggle("繰り返しイベント", isOn: $isRecurring)
                    
                    if isRecurring {
                        TextField("繰り返しルール (例: 毎週月曜)", text: $recurrenceRule)
                            .textInputAutocapitalization(.words)
                    }
                }
                
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
            .navigationBarItems(
                leading: Button("キャンセル") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("保存") {
                    saveEvent()
                }
                .disabled(name.isEmpty || startDate > endDate) // 入力チェック
            )
        }
    }
    
    private func saveEvent() {
        // Core Data またはバックエンドにデータを保存するロジック
        let newEvent = Event(context: PersistenceController.shared.container.viewContext)
        newEvent.name = name
        newEvent.memo = memo
        newEvent.startDate = startDate
        newEvent.endDate = endDate
        newEvent.isNotificationEnabled = isNotificationEnabled
        newEvent.notificationTime = isNotificationEnabled ? notificationTime : nil
        newEvent.isRecurring = isRecurring
        newEvent.recurrenceRule = recurrenceRule
        newEvent.color = color.description // 色を文字列として保存
        
        do {
            try PersistenceController.shared.container.viewContext.save()
            // 通知をスケジュール
            if isNotificationEnabled {
                scheduleNotification(for: newEvent)
            }
            presentationMode.wrappedValue.dismiss() // モーダルを閉じる
        } catch {
            print("保存中にエラーが発生しました: \(error.localizedDescription)")
        }
    }

    private func scheduleNotification(for event: Event) {
        let content = UNMutableNotificationContent()
        content.title = event.name ?? "イベント"
        content.body = event.memo ?? ""
        content.sound = .default
        
        // 通知時間を設定
        if let notificationTime = event.notificationTime {
            let triggerDate = Calendar.current.dateComponents(
                [.year, .month, .day, .hour, .minute],
                from: notificationTime
            )
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
            let request = UNNotificationRequest(
                identifier: UUID().uuidString,
                content: content,
                trigger: trigger
            )
            
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("通知のスケジュール中にエラーが発生しました: \(error)")
                } else {
                    print("通知がスケジュールされました")
                }
            }
        }
    }
}
