//
//  LoginViewController.swift.swift
//  Calendar17
//
//  Created by 冨成 祐羽 on 2025/01/29.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
   
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // 初期設定があればここで行う
    }
   
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        guard let email = emailTextField.text, !email.isEmpty else {
            print("メールアドレスを入力してください")
            return
        }
        guard let password = passwordTextField.text, !password.isEmpty else {
            print("パスワードを入力してください")
            return
        }
        
        signIn(email: email, password: password)
    }
   
    // サインイン処理
    func signIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print("サインインエラー: \(error.localizedDescription)")
                return
            }

            // サインイン成功時の処理
            print("サインイン成功")
            self.navigateToMainScreen()
        }
    }
   
    // メイン画面に遷移
    func navigateToMainScreen() {
        if let tabBarController = self.storyboard?.instantiateViewController(withIdentifier: "MainTabBarController") {
            self.present(tabBarController, animated: true, completion: nil)
        }
    }
}
