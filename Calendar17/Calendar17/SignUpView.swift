//
//  SignUpView.swift
//  Calendar17
//
//  Created by 冨成 祐羽 on 2025/01/29.
//

import SwiftUI
import FirebaseAuth

struct SignUpView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var errorMessage: String? = nil

    var body: some View {
        VStack {
            Text("新規アカウント作成")
                .font(.largeTitle)
                .padding()

            // メールアドレス入力フィールド
            TextField("メールアドレス", text: $email)
                .keyboardType(.emailAddress)  // メールアドレス用のキーボード
                .autocapitalization(.none)    // 自動的な大文字変換を無効にする
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()


            // パスワード入力フィールド
            SecureField("パスワード", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            // パスワード確認入力フィールド
            SecureField("パスワード確認", text: $confirmPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            // エラーメッセージ表示
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }

            // 登録ボタン
            Button(action: {
                signUp()
            }) {
                Text("アカウントを作成")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()

            Spacer()
        }
        .padding()
    }
    
    // サインアップ処理
    func signUp() {
        guard !email.isEmpty, !password.isEmpty, !confirmPassword.isEmpty else {
            errorMessage = "すべてのフィールドを入力してください。"
            return
        }

        // パスワード確認
        guard password == confirmPassword else {
            errorMessage = "パスワードが一致しません。"
            return
        }

        // Firebase に新しいアカウントを作成
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                errorMessage = "アカウント作成に失敗しました: \(error.localizedDescription)"
                return
            }

            // アカウント作成成功時
            print("アカウント作成成功")
            navigateToMainScreen()
        }
    }

    // メイン画面に遷移
    func navigateToMainScreen() {
        // サインアップ後にメイン画面へ遷移
        // この例では、TabViewなどに遷移することを想定しています
        if let window = UIApplication.shared.windows.first {
            let contentView = calendarView()
            window.rootViewController = UIHostingController(rootView: contentView)
        }
    }
}

