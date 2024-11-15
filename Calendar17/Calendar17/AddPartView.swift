//
//  AddPartView.swift
//  Calendar17
//
//  Created by 出口葵葉 on 2024/11/15.
//

import SwiftUI

struct AddPartView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: WorkData.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \WorkData.workDate, ascending: true)])
    var workDataList: FetchedResults<WorkData>
    
    var body: some View {
        Text("↓アルバイトを選択↓")
        ForEach(workDataList) { workData in
            VStack(alignment: .leading, spacing: 10) {
                Text("名前: \(workData.name ?? "")").font(.headline)
            }
        }
    }
}

#Preview {
    AddPartView()
}
