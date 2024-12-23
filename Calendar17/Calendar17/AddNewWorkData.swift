//
//  copy.swift
//  Calendar17
//
//  Created by 冨成 祐羽 on 2024/11/27.
//

import SwiftUI
import CoreData

struct AddNewWorkDataView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var workDate = Date()
    @State private var name = ""
    @State private var notes = ""
    @State private var money: Double = 0
    @State private var move: Double = 0
    @State private var premiumWages: Double = 0
    @State private var specialWages: Double = 0
    @State private var color: Color = .blue
    
    @State private var showingAddWorkDataView = false
    
    private let presetColors: [(color: Color, name: String)] = [
        (.blue, "青"), (.red, "赤"), (.green, "緑"),
        (.orange, "オレンジ"), (.purple, "紫"), (.yellow, "黄色")
    ]
    private let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    

    var body: some View {
        Form {
            Section(header: Text("勤務データ")) {
                HStack {
                    Text("名前：")
                    TextField("", text: $name)
                        .keyboardType(.decimalPad) // 数字入力をしやすくするためにキーボードを指定
                }
                
                HStack {
                    Text("時給：")
                    TextField("", value: $money, formatter: NumberFormatter())
                        .keyboardType(.decimalPad) // 数字入力をしやすくするためにキーボードを指定
                }
                
                HStack {
                    Text("深夜時給：")
                    TextField("", value: $premiumWages, formatter: NumberFormatter())
                        .keyboardType(.decimalPad) // 数字入力をしやすくするためにキーボードを指定
                }
                
                HStack {
                    Text("交通費：")
                    TextField("", value: $move, formatter: NumberFormatter())
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

            Button("保存する") {
                addWorkData()
            }
        }
        .padding()
        Button("アルバイト一覧") {
                        showingAddWorkDataView.toggle()
                    }
                    .sheet(isPresented: $showingAddWorkDataView) {
                        wakudata()
                    }
    }

    // addWorkData 関数
    private func addWorkData() {
        let newWorkData = PartTimeList(context: viewContext)
        newWorkData.name = name
        newWorkData.money = money
        newWorkData.move = move

        do {
            try viewContext.save()
        } catch {
            print("Error saving data: \(error)")
        }
    }
}
