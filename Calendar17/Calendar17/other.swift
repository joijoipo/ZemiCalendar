//
//  other.swift
//  Calendar17
//
//  Created by 出口葵葉 on 2024/10/03.
//

import SwiftUI
import Foundation
import FirebaseAuth
//joijoipo@gmail.com

struct other: View {
    @State private var isLoggedIn = true
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    if isLoggedIn {
                        // サインアウトリンク
                        Button("サインアウト") {
                            signOut(isLoggedIn: $isLoggedIn)
                        }
                        .padding()
                    } else {
                        // ログイン画面
                        LoginView(isLoggedIn: $isLoggedIn)
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
                                    .frame(width: 30, height: 30)
                                Text("カレンダー").tint(Color(hex: "#f1f2f2"))
                            }
                        }
                        
                        NavigationLink {
                            CashView()
                        } label: {
                            VStack {
                                Image("money-3")
                                    .resizable()
                                    .frame(width: 40, height: 30)
                                Text("給与計算").tint(Color(hex: "#f1f2f2"))
                            }
                        }
                        
                        NavigationLink {
                            other()
                        } label: {
                            VStack {
                                Image("other")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                Text("その他").tint(Color(hex: "#f1f2f2"))
                            }
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width, height: 60)
                    .background(Color(hex: "#00abc1"))
                    .padding(.top) // メニューバーを少し上に移動
                }
            }
        }.navigationBarBackButtonHidden(true)
    }
    
    func signOut(isLoggedIn: Binding<Bool>) {
        do {
            try Auth.auth().signOut() // Firebaseでサインアウト
            isLoggedIn.wrappedValue = false // ログイン状態を解除
        } catch {
            print("サインアウトに失敗しました: \(error.localizedDescription)")
        }
    }
    
}

#Preview {
    other()
}
