import SwiftUI
import CoreData

struct TotalCash: View {
    @Environment(\.managedObjectContext) private var viewContext

    // 現在選択中の月
    @State private var selectedMonth: Date = Date()
    
    @FetchRequest(
        entity: WorkData.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \WorkData.workDate, ascending: true)]
    )
    private var allWorkData: FetchedResults<WorkData>
    
    // 現在選択中の月のデータを取得
    private var workDataForSelectedMonth: [WorkData] {
        allWorkData.filter { workData in
            guard let startTime = workData.startTime else { return false }
            return Calendar.current.isDate(startTime, equalTo: selectedMonth, toGranularity: .month)
        }
    }

    
    @State private var targetWage: Double = 100000 // 目標給与

    // 現在選択中の月の合計給与
    private var totalWageForMonth: Int {
        workDataForSelectedMonth.reduce(0) { total, workData in
            total + calculateWage(for: workData)
        }
    }


    // 月の実際の合計給与
    private var totalRealWageForMonth: Int {
        workDataForSelectedMonth
            .filter { $0.isPastWork() }
            .reduce(0) { $0 + calculateRealWage(for: $1) }
    }

    // 合計勤務時間（分単位）
    private var totalWorkingMinutesForMonth: Int {
        workDataForSelectedMonth
            .filter { $0.isPastWork() }
            .reduce(0) { $0 + calculateWorkingMinutes(for: $1) }
    }

    // 合計勤務時間を「○時間○分」の形式でフォーマット
    private var formattedWorkingHours: String {
        let hours = totalWorkingMinutesForMonth / 60
        let minutes = totalWorkingMinutesForMonth % 60
        return "\(hours)時間 \(minutes)分"
    }

    private func calculateWage(for workData: WorkData) -> Int {
        guard let startTime = workData.startTime, let endTime = workData.endTime else { return 0 }
        let hourlyWage = Int(workData.money)
        let totalMinutes = calculateMinutes(from: startTime, to: endTime)

        return (hourlyWage * totalMinutes) / 60
    }


    func calculateRealWage(for workData: WorkData) -> Int {
        let baseWage = Int(workData.money)
        
        // Night shift minutes calculation
        let nightShiftMinutes = calculateNightShiftMinutes(start: workData.startTime, end: workData.endTime)
        
        // OverTime calculation
        let overTimeRate = workData.overTime.map { calculateMinutes(from: $0, to: Date()) } ?? 0
        
        return baseWage + (nightShiftMinutes * overTimeRate)
    }

    private func calculateWorkingMinutes(for workData: WorkData) -> Int {
        guard let startTime = workData.startTime, let endTime = workData.endTime else { return 0 }
        return calculateMinutes(from: startTime, to: endTime)
    }

    private func calculateNightShiftMinutes(start: Date?, end: Date?) -> Int {
        guard let start = start, let end = end else { return 0 }
        let calendar = Calendar.current
        let nightStart = calendar.date(bySettingHour: 22, minute: 0, second: 0, of: start) ?? start
        let nightEnd = calendar.date(bySettingHour: 5, minute: 0, second: 0, of: end) ?? end
        return calculateOverlapMinutes(start: start, end: end, rangeStart: nightStart, rangeEnd: nightEnd)
    }

    private func calculateOverlapMinutes(start: Date, end: Date, rangeStart: Date, rangeEnd: Date) -> Int {
        let effectiveStart = max(start, rangeStart)
        let effectiveEnd = min(end, rangeEnd)
        return effectiveStart < effectiveEnd ? calculateMinutes(from: effectiveStart, to: effectiveEnd) : 0
    }

    private func calculateMinutes(from start: Date, to end: Date) -> Int {
        let interval = end.timeIntervalSince(start)
        return max(0, Int(interval / 60))
    }

    // 月の切り替え
    private func changeMonth(by offset: Int) {
        if let newMonth = Calendar.current.date(byAdding: .month, value: offset, to: selectedMonth) {
            selectedMonth = newMonth
        }
    }

    // 月をフォーマット
    private func formattedMonth(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月"
        return formatter.string(from: date)
    }

    var body: some View {
        VStack(spacing: 20) {
            // 現在の月表示
            Text("給与管理 (\(formattedMonth(selectedMonth)))")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.blue)

            // 給与情報のカードビュー
            VStack(spacing: 15) {
                CardView(title: "合計給与", value: "¥\(totalWageForMonth)", icon: "yen")
                CardView(title: "実際の合計給与", value: "¥\(totalRealWageForMonth)", icon: "yen")
                CardView(title: "合計勤務時間", value: formattedWorkingHours, icon: "clock")
            }
            
            

            // 月変更ボタン
            HStack {
                Button(action: { changeMonth(by: -1) }) {
                    Text("前月")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                Spacer()
                Button(action: { changeMonth(by: 1) }) {
                    Text("次月")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding(.horizontal, 30)

            Spacer()
        }
        .padding()
        .background(Color(.systemGroupedBackground))
        .edgesIgnoringSafeArea(.all)
    }
}
struct CardView: View {
    let title: String
    let value: String
    let icon: String

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 40, height: 40)
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.gray)
                Text(value)
                    .font(.title)
                    .bold()
            }
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 4)
    }
}

extension WorkData {
    func isPastWork() -> Bool {
        guard let endTime = self.endTime else { return false }
        return endTime <= Date()
    }
}
