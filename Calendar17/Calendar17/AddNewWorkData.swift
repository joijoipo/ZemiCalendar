//
//  copy.swift
//  Calendar17
//
//  Created by 冨成 祐羽 on 2024/11/27.
//

import SwiftUI
import CoreData
import FirebaseFirestore

struct AddNewWorkDataView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) private var presentationMode // 画面を閉じるため
    @Environment(\.dismiss) var dismiss // 画面を閉じるための環境変数
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
        //joijoipo@gmail.com
        // オプショナル値の安全な処理
        guard !name.isEmpty else {
            print("名前が空です")
            return
        }
        guard money > 0 else {
            print("時給は0より大きい値である必要があります")
            return
        }
        if viewContext == nil {
            print("viewContext is nil")
        } else {
            print("viewContext is available")
        }
        
        let count = try? viewContext.count(for: PartTimeList.fetchRequest())
        print("Current number of PartTimeList items: \(count ?? 0)")
        
        newWorkData.name = name
        newWorkData.money = money
        newWorkData.move = move
        newWorkData.premiumWages = premiumWages

        // Firestore への保存データ
        let db = Firestore.firestore()
        let workerData: [String: Any] = [
            "name": newWorkData.name ?? "",
            "money": newWorkData.money,
            "move": newWorkData.move,
            "premiumWages": newWorkData.premiumWages,
            "createdAt": Timestamp(date: Date()) // 登録日時
        ]

        // Firestore への保存処理
        db.collection("partTimeList").addDocument(data: workerData) { error in
            if let error = error {
                print("Firestore への保存に失敗しました: \(error.localizedDescription)")
            } else {
                print("Firestore にデータが保存されました")
            }
        }
        
        // CoreData への保存処理
        do {
            try viewContext.save()
            print("CoreData にデータが保存されました: \(newWorkData.name ?? "無名") / 時給: \(newWorkData.money) / 交通費: \(newWorkData.move) / 深夜手当: \(newWorkData.premiumWages)")

            // 画面を閉じる処理（iOS 15 以降なら .dismiss() を推奨）
            if #available(iOS 15.0, *) {
                dismiss()
            } else {
                presentationMode.wrappedValue.dismiss()
            }
        } catch {
            print("CoreData の保存に失敗しました: \(error.localizedDescription)")
        }
    }


}
