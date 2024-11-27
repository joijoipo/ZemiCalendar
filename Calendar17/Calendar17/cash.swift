//
//  cash.swift
//  Calendar17
//
//  Created by 出口葵葉 on 2024/10/03.
//

import SwiftUI

struct CashView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: WorkData.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \WorkData.workDate, ascending: true)])
    var workDataList: FetchedResults<WorkData>
    
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
                            ForEach(workDataList) { workData in
                                NavigationLink(destination: EditWorkDataView(worker: workData)) {
                                    VStack(alignment: .leading, spacing: 10) {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(.black, lineWidth: 0.2)
                                                .frame(width: 350, height: 80)
                                            VStack {
                                                Text("名前: \(workData.name ?? "")")
                                                    .font(.headline)
                                                    .tint(Color.black)
                                                Text("時給: ¥\(workData.money, specifier: "%.0f")")
                                                    .font(.subheadline)
                                            }
                                        }
                                    }
                                }
                            }
                            
                            NavigationLink {
                                AddWorkDataView()
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

                            HStack {
                                NavigationLink {
                                    TotalCash()
                                } label: {
                                    Text("給与合計")
                                        .background(.clear)
                                }
                            }
                            
                            NavigationLink {
                                AddEventView()
                            } label: {
                                Text("イベント（富成が使ってます）")
                                    .background(.clear)
                            }
                            NavigationLink {
                                ContentView()
                            } label: {
                                Text("contentVIew")
                                    .background(.clear)
                            }
                            NavigationLink {
                                copyView()
                            } label: {
                                Text("kぴーVIew")
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

