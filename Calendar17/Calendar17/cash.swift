import SwiftUI
import CoreData

struct CashView: View {
    @Environment(\.managedObjectContext) private var viewContext
    // ここをWorkDataからPartTimeListに変更
    @FetchRequest(entity: PartTimeList.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \PartTimeList.name, ascending: true)])
    var workers: FetchedResults<PartTimeList>
    
    @State private var showNextView = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // メインコンテンツ部分
                VStack {
                    Text("給与計算")
                        .font(.headline)
                        .padding()
                    
                    ScrollView {
                        VStack {
                            // PartTimeListの内容を表示
                            ForEach(workers) { worker in
                                NavigationLink(destination: EditPartListView(worker: worker)) {
                                    VStack(alignment: .leading, spacing: 10) {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(.black, lineWidth: 0.2)
                                                .frame(width: 350, height: 80)
                                            VStack {
                                                // PartTimeListのnameとmoneyを表示
                                                Text("名前: \(worker.name ?? "")")
                                                    .font(.headline)
                                                    .tint(Color.black)
                                                Text("時給: ¥\(worker.money, specifier: "%.0f")")
                                                    .font(.subheadline)
                                            }
                                        }
                                    }
                                }
                            }
                            
                            // 新しいバイト先を追加
                            NavigationLink {
                                AddNewWorkDataView()
                            } label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color(hex: "#00abc1"), lineWidth: 1)
                                        .fill(Color(hex: "#00abc1"))
                                        .frame(width: 200, height: 40)
                                    Text("新しいバイト先を追加")
                                        .tint(Color(hex: "#f1f2f2"))
                                }
                            }

                            // その他のリンク
                            HStack {
                                NavigationLink {
                                    TotalCash()
                                } label: {
                                    Text("給与合計")
                                        .background(.clear)
                                }
                            }
                            
                            NavigationLink {
                                ContentView()
                            } label: {
                                Text("シフトを追加")
                                    .background(.clear)
                            }
                        }
                    }
                }
                
                // メニューバー部分
                VStack {
                    Spacer()  // メインコンテンツとの間隔を空ける
                    HStack(spacing: 40) {
                        NavigationLink {
                            calendarView()
                        } label: {
                            VStack {
                                Image("cal-3")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                Text("カレンダー").tint(Color(hex: "#f1f2f2"))
                            }
                        }

                        NavigationLink {
                            CashView()
                        } label: {
                            VStack {
                                Image("money-3")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                Text("給与計算").tint(Color(hex: "#f1f2f2"))
                            }
                        }

                        NavigationLink {
                            other()
                        } label: {
                            VStack {
                                Image("other")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                Text("その他").tint(Color(hex: "#f1f2f2"))
                            }
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width, height: 60)
                    .background(Color(hex: "#00abc1"))
                    .padding(.top, -90) // メニューバーを少し上に移動
                }
                .edgesIgnoringSafeArea(.bottom)  // メニューバーを画面下部に固定
            }
        }.navigationBarBackButtonHidden(true)
    }
}

#Preview {
    CashView()
}
