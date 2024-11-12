//
//  Calendar17App.swift
//  Calendar17
//
//  Created by 出口葵葉 on 2024/09/24.
//

import SwiftUI

@main
struct Calendar17App: App {
    
    let persistenceController = PersistenceController.shared
    var body: some Scene {
        WindowGroup {
            AddWorkDataView().environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
