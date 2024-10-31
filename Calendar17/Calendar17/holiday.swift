import SwiftUI

struct HolidayInfo: Identifiable {
    let id = UUID()
    let date: String
    let name: String
    let year: Int
    let month: Int
    let day: Int

    init(date: String, name: String) {
        self.date = date
        self.name = name
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if let dateObj = dateFormatter.date(from: date) {
            let calendar = Calendar.current
            self.year = calendar.component(.year, from: dateObj)
            self.month = calendar.component(.month, from: dateObj)
            self.day = calendar.component(.day, from: dateObj)
        } else {
            self.year = 0
            self.month = 0
            self.day = 0
        }
    }
}

var holidays: [HolidayInfo] = [] // グローバルな変数として定義

func fetchHolidays(completion: @escaping () -> Void) {
    guard let url = URL(string: "https://holidays-jp.github.io/api/v1/date.json") else {
        return
    }

    let task = URLSession.shared.dataTask(with: url) { data, response, error in
        if let error = error {
            print("Network error: \(error.localizedDescription)")
            return
        }

        guard let data = data else {
            print("No data received")
            return
        }

        do {
            let decodedHolidays = try JSONDecoder().decode([String: String].self, from: data)
            holidays = decodedHolidays.map { HolidayInfo(date: $0.key, name: $0.value) }
            completion() // データ取得完了を通知
        } catch {
            print("Failed to decode JSON: \(error.localizedDescription)")
        }
    }
    task.resume()
}

func checkHoliday(year: Int, month: Int, day: Int) -> Color {
    // 引数の年、月、日と一致する祝日があるかチェック
    for holiday in holidays {
        if holiday.year == year && holiday.month == month && holiday.day == day {
            return .red
        }
    }
    return .black // 一致しない場合は黒色を返す
}

struct HolidayView: View {
    @State private var errorMessage: String?

    var body: some View {
        VStack {
            if let errorMessage = errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
            } else {
                ForEach(holidays, id: \.id) { holiday in
                    Text("\(holiday.name) \(holiday.year)-\(holiday.month)-\(holiday.day)")
                        .foregroundColor(checkHoliday(year: holiday.year, month: holiday.month, day: holiday.day))
                }
            }
        }
        .onAppear {
            fetchHolidays {
                // データ取得後の処理
                // UIを更新するためのロジックをここに追加することもできま
            }
        }
    }
}
