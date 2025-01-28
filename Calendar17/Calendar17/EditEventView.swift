import SwiftUI
import FirebaseFirestore

struct EditEventView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var event: Event
    @Environment(\.presentationMode) private var presentationMode

    @State private var name: String
    @State private var startDate: Date
    @State private var endDate: Date
    @State private var selectedColor: String // 現在の選択色

    let colorOptions = ["blue", "red", "green", "orange", "purple", "yellow"] // 色の選択肢

    init(event: Event) {
        self.event = event
        _name = State(initialValue: event.name ?? "")
        _startDate = State(initialValue: event.startDate ?? Date())
        _endDate = State(initialValue: event.endDate ?? Date())
        _selectedColor = State(initialValue: event.color ?? "blue") // 初期値を設定
    }

    var body: some View {
        Form {
            TextField("イベント名", text: $name)

            DatePicker("開始日時", selection: $startDate, displayedComponents: [.date, .hourAndMinute])

            DatePicker("終了日時", selection: $endDate, displayedComponents: [.date, .hourAndMinute])

            // 色選択セクション
            Section(header: Text("色を選択").font(.headline)) {
                HStack(spacing: 15) {
                    ForEach(colorOptions, id: \.self) { colorName in
                        ZStack {
                            // 色の表示
                            Circle()
                                .fill(Color.from(description: colorName))
                                .frame(width: 40, height: 40)

                            // 選択中の色をハイライト
                            if colorName == selectedColor {
                                Circle()
                                    .stroke(Color.black, lineWidth: 3)
                                    .frame(width: 45, height: 45)
                            }
                        }
                        .onTapGesture {
                            selectedColor = colorName // 色を選択
                        }
                    }
                }
                .padding(.vertical)
            }

            HStack {
                Button("保存") {
                    saveEvent()
                }
                .buttonStyle(.borderedProminent)

                Button("削除") {
                    deleteEvent()
                }
                .buttonStyle(.bordered)
                .foregroundColor(.red)
            }
        }
        .padding()
        .onAppear {
            // 必ず`event.color`を現在の選択に反映
            selectedColor = event.color ?? "blue"
        }
    }


    private func saveEvent() {
        event.name = name
        event.startDate = startDate
        event.endDate = endDate
        event.color = selectedColor // 選択された色を保存
        
        let db = Firestore.firestore()
            let eventData: [String: Any] = [
                "name": event.name ?? "",
                "startDate": event.startDate,
                "endDate": event.endDate,
                "color": event.color ?? ""
            ]
            
            db.collection("events").addDocument(data: eventData) { error in
                if let error = error {
                    print("Firestoreへのイベント保存に失敗しました: \(error.localizedDescription)")
                } else {
                    print("イベントがFirestoreに保存されました")
                }
            }

        do {
            try viewContext.save()
            presentationMode.wrappedValue.dismiss() // 保存後に画面を閉じる
        } catch {
            print("イベントの保存に失敗しました: \(error)")
        }
    }

    private func deleteEvent() {
        viewContext.delete(event)
        do {
            try viewContext.save()
            presentationMode.wrappedValue.dismiss() // 削除後に画面を閉じる
        } catch {
            print("イベントの削除に失敗しました: \(error)")
        }
    }
}
