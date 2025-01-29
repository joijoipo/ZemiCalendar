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
    @State private var isSignedIn: Bool = false
    @State private var isLoggedIn = true
    
    init() {
            FirebaseApp.configure()
        
        // 認証状態の確認
            if let user = Auth.auth().currentUser {
                // サインインしている場合
                isSignedIn = true
            } else {
                // サインインしていない場合
                isSignedIn = false
            }
        }
    
    let persistenceController = PersistenceController.shared
    var body: some Scene {
        WindowGroup {
            // サインイン状態に応じて遷移先を決定
            if isSignedIn {
            calendarView().environment(\.managedObjectContext, persistenceController.container.viewContext)  // サインイン後のメイン画面
            } else {
                LoginView(isLoggedIn: $isLoggedIn)  // ログイン画面
            }
        }
    }
}
