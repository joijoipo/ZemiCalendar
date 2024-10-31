//
//  okane.swift
//  Calendar17
//
//  Created by 出口葵葉 on 2024/10/31.
//

import SwiftUI

import SwiftUI

class PayrollData: ObservableObject {
    @Published var workplace: String = ""
    @Published var happyday: Int = 0
    @Published var wages: Double = 0.0
    @Published var overtimeWages: Double = 0.0
}

struct DontentView: View {
    @StateObject private var payrollData = PayrollData()

    var body: some View {
        VStack {
            PayrollInputView()
                .environmentObject(payrollData)
            PayrollSummaryView()
                .environmentObject(payrollData)
        }
    }
}

struct PayrollInputView: View {
    @EnvironmentObject var payrollData: PayrollData

    var body: some View {
        Form {
            // 勤務先入力フィールド
            HStack{
                Text("勤務先")
                TextField("", text: $payrollData.workplace)
                
            }
            HStack{
                Text("給料日")
                TextField("", value: $payrollData.happyday,format: .currency(code: "日"))
            }
            // 賃金入力フィールド
            TextField("賃金", value: $payrollData.wages, format: .currency(code: "JPY"))
                .keyboardType(.decimalPad)

            // 割増賃金入力フィールドと計算結果表示
            HStack {
                TextField("割増賃金率", value: $payrollData.overtimeWages, format: .percent)
                    .keyboardType(.decimalPad)
                
                Spacer()

                // 割増賃金率と賃金を掛けた結果を表示
                Text("割増賃金合計: \(payrollData.wages * payrollData.overtimeWages+payrollData.wages, format: .currency(code: "JPY"))")
                    .foregroundColor(.gray)
            }
        }
        .padding()
    }
}

struct PayrollSummaryView: View {
    @EnvironmentObject var payrollData: PayrollData

    var body: some View {
        VStack {
            Text("勤務先: \(payrollData.workplace)")
            Text("給料日: \(payrollData.happyday)")
            Text("賃金: \(payrollData.wages, format: .currency(code: "JPY"))")
            Text("割増賃金合計: \(payrollData.wages * payrollData.overtimeWages+payrollData.wages, format: .currency(code: "JPY"))")

        }
        .padding()
    }
}


#Preview {
    DontentView()
}
