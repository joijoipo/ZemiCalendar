//  LoginViewController.swift
//  Calendar17
//
//  Created by 冨成 祐羽 on 2025/01/29.
//joijoipo@gmail.com

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String? = nil
    @State private var isShowingSignUpView = false // 新規登録画面を表示するフラグ

    @Binding var isLoggedIn: Bool
    
    var body: some View {
        VStack {
            Text("ログイン")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.blue) // タイトル色を変更
                .padding()

            // メールアドレス入力フィールド
            TextField("メールアドレス", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .background(Color(hex: "#f1f2f2"))
                .cornerRadius(10)
                .padding(.horizontal)

            // パスワード入力フィールド
            SecureField("パスワード", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .background(Color(hex: "#f1f2f2"))
                .cornerRadius(10)
                .padding(.horizontal)

            // エラーメッセージ表示
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }

            // ログインボタン
            Button(action: {
                signIn()
            }) {
                Text("ログイン")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal)

            // 新規登録画面に遷移
            Button(action: {
                isShowingSignUpView = true
            }) {
                Text("新しいアカウントを作成")
                    .foregroundColor(.blue)
                    .padding(.top)
            }
            .padding(.horizontal)

            Spacer()
        }
        .padding()
        .background(Color.white) // 背景色
        .fullScreenCover(isPresented: $isShowingSignUpView) {
            SignUpView() // サインアップ画面を表示
        }
    }

    // サインイン処理
    func signIn() {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "メールアドレスとパスワードを入力してください。"
            return
        }

        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                errorMessage = "サインインに失敗しました: \(error.localizedDescription)"
                return
            }

            // サインイン成功時の処理
            print("サインイン成功")
            navigateToMainScreen()
        }
    }

    // メイン画面に遷移
    func navigateToMainScreen() {
        // サインイン後にメイン画面へ遷移
        // この例では、TabViewなどに遷移することを想定しています
        if let window = UIApplication.shared.windows.first {
            let contentView = calendarView()
            window.rootViewController = UIHostingController(rootView: contentView)
        }
    }
}
