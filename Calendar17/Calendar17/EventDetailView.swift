import SwiftUI

struct EventDetailView: View {
    var year: Int
    var month: Int
    var day: Int
    var events: [Event]
    var workData: [WorkData]

    var body: some View {
            NavigationView {
                VStack {
                    HStack{
                        Text("\(String(year))年 \(month)月 \(day) 日の予定")
                            .font(.headline)
                            .padding()
                        VStack {
                            NavigationLink(destination: AddEventView(
                                                        startDate: makeDate(year: year, month: month, day: day) ?? Date(),
                                                        endDate: makeDate(year: year, month: month, day: day)?.addingTimeInterval(60 * 60) ?? Date()
                                                    )) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.title)
                                    .foregroundColor(.blue)
                            }
                            Text("イベント")
                                .font(.caption)
                                .foregroundColor(.blue)
                        }
                        VStack {
                            NavigationLink(destination: AddWorkDataView(
                                                        startTime: makeDate(year: year, month: month, day: day) ?? Date(),
                                                        endTime: makeDate(year: year, month: month, day: day)?.addingTimeInterval(60 * 60) ?? Date()
                                                    )) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.title)
                                    .foregroundColor(.blue)
                            }
                            Text("アルバイト")
                                .font(.caption)
                                .foregroundColor(.green)
                        }
                    }

                    List {
                        Section(header: Text("イベント")) {
                            ForEach(events, id: \.self) { event in
                                NavigationLink(destination: EditEventView(event: event)) {
                                    HStack {
                                        Text(event.name ?? "No Title")
                                            .font(.body)
                                        Spacer()
                                        eventTimeText(event)
                                    }
                                }
                            }
                        }
                        Section(header: Text("アルバイト")) {
                            ForEach(workData, id: \.self) { work in
                                NavigationLink(destination: EditWorkDataView(workData: work)) {
                                    HStack{
                                        Text(work.name ?? "No Work Title")
                                            .font(.body)
                                        Spacer()
                                        workTimeText(work)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

    // イベントの時間表示用関数
    func eventTimeText(_ event: Event) -> some View {
        if let startTime = event.startDate, let endTime = event.endDate {
            return Text("\(formattedTime(startTime)) ～ \(formattedTime(endTime))")
                .font(.body)
                .foregroundColor(.gray)
        } else {
            return Text("情報なし")
                .font(.body)
                .foregroundColor(.gray)
        }
    }
    
    // アルバイトの時間表示用関数
    func workTimeText(_ work: WorkData) -> some View {
        if let startTime = work.startTime, let endTime = work.endTime {
            return Text("\(formattedTime(startTime)) ～ \(formattedTime(endTime))")
                .font(.body)
                .foregroundColor(.gray)
        } else {
            return Text("情報なし")
                .font(.body)
                .foregroundColor(.gray)
        }
    }

    // 時間のフォーマット関数
    func formattedTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
    
    func makeDate(year: Int, month: Int, day: Int) -> Date? {
            var dateComponents = DateComponents()
            dateComponents.year = year
            dateComponents.month = month
            dateComponents.day = day
            return Calendar.current.date(from: dateComponents)
        }
}
