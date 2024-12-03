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
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("イベント情報")) {
                    TextField("イベント名", text: $name)
                        .textInputAutocapitalization(.words)
                    
                    TextField("説明 (オプション)", text: $memo)
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
                
                Section(header: Text("その他の設定")) {
                    
                    ColorPicker("イベントカラー", selection: $color)
                    
                }
            }
            .navigationBarTitle("イベントを追加")
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
            presentationMode.wrappedValue.dismiss() // モーダルを閉じる
        } catch {
            print("保存中にエラーが発生しました: \(error.localizedDescription)")
        }
    }
}
