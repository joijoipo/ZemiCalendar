//
//  part.swift
//  Calendar17
//
//  Created by 出口葵葉 on 2024/10/07.
//

import SwiftUI
import Combine

// ObservableObjectクラスの定義
class EmploymentData: ObservableObject {
    @Published var inputName: String = ""
    @Published var inputMoney: Int = 0
    @Published var inputPp: Int = 0
    
    var sum: Int {
        inputMoney + inputMoney * inputPp / 100
    }
}

struct part: View {
    
    // ObservableObjectインスタンスをプロパティとして保持
    @ObservedObject var employmentData: EmploymentData
    
    var body: some View {
        Form {
            HStack {
                Text("勤務先：")
                TextField("名前を入力してください", text: $employmentData.inputName)
                    .textFieldStyle(.plain)
            }
            .padding(8)
            .overlay(
                RoundedRectangle(cornerRadius: 30)
                    .stroke(Color.gray, lineWidth: 1)
            )
            
            HStack {
                Text("賃金：")
                TextField("時給を入力してください", value: $employmentData.inputMoney, format: .number)
                    .textFieldStyle(.plain)
                Text("円")
            }
            .padding(8)
            .overlay(
                RoundedRectangle(cornerRadius: 30)
                    .stroke(Color.gray, lineWidth: 1)
            )
            
            HStack {
                Text("割増賃金：")
                TextField("深夜手当てなどを入力してください", value: $employmentData.inputPp, format: .number)
                    .textFieldStyle(.plain)
                Text("合計：\(employmentData.sum)円")
            }
            .padding(8)
            .overlay(
                RoundedRectangle(cornerRadius: 30)
                    .stroke(Color.gray, lineWidth: 1)
            )
        }
    }
}

struct Part_Previews: PreviewProvider {
    static var previews: some View {
        let employmentData = EmploymentData() // インスタンス作成
        part(employmentData: employmentData) // インスタンスを渡す
    }
}
