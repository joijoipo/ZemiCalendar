//
//  Calendar17App.swift
//  Calendar17
//
//  Created by 出口葵葉 on 2024/09/24.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

@main
struct Calendar17App: App {
    init() {
            FirebaseApp.configure()
        }
    
    let persistenceController = PersistenceController.shared
    var body: some Scene {
        WindowGroup {
            calendarView().environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
