//
//  copy.swift
//  Calendar17
//
//  Created by 冨成 祐羽 on 2024/11/27.
//

import SwiftUI
import CoreData

struct copyView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var workDate = Date()
    @State private var startTime = Date()
    @State private var endTime = Date()
    @State private var breakTime: Double = 0
    @State private var transportationCost: Double = 0
    @State private var name = ""
    @State private var notes = ""
    @State private var money: Double = 0
    @State private var premiumWages: Double = 0
    @State private var specialWages: Double = 0
    
    @State private var showingAddWorkDataView = false
    

    var body: some View {
        Form {
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
                Text("特別給料：")
                TextField("", value: $specialWages, formatter: NumberFormatter())
                    .keyboardType(.decimalPad) // 数字入力をしやすくするためにキーボードを指定
            }
            
            DatePicker("開始日時", selection: $startTime, displayedComponents: [.date, .hourAndMinute])
            
            DatePicker("終了日時", selection: $endTime, displayedComponents: [.date, .hourAndMinute])
            HStack {
                Text("交通費：")
                TextField("", value: $transportationCost, formatter: NumberFormatter())
            }
            
            TextField("name", text: $name)
            TextField("Notes", text: $notes)

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

        do {
            try viewContext.save()
        } catch {
            print("Error saving data: \(error)")
        }
    }
}

#Preview {
    AddWorkDataView()
}
