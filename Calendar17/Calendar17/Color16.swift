import SwiftUI

import SwiftUI
import UIKit

extension Color {
    // HEX値からColorを初期化
    init(hex: String) {
        // #を取り除く
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        // 16進数の整数を格納するための変数
        var rgbValue: UInt64 = 0
        
        // 16進数から整数に変換
        let scanner = Scanner(string: hexSanitized)
        scanner.scanHexInt64(&rgbValue)
        
        // HEXの桁数を確認し、適切に処理
        let length = hexSanitized.count
        let red, green, blue, alpha: Double
        
        switch length {
        case 6: // #RRGGBB
            red = Double((rgbValue >> 16) & 0xFF) / 255.0
            green = Double((rgbValue >> 8) & 0xFF) / 255.0
            blue = Double(rgbValue & 0xFF) / 255.0
            alpha = 1.0
        case 8: // #RRGGBBAA
            red = Double((rgbValue >> 24) & 0xFF) / 255.0
            green = Double((rgbValue >> 16) & 0xFF) / 255.0
            blue = Double((rgbValue >> 8) & 0xFF) / 255.0
            alpha = Double(rgbValue & 0xFF) / 255.0
        default:
            // 無効なHEX値が渡された場合は、デフォルト色を設定
            red = 1.0
            green = 1.0
            blue = 1.0
            alpha = 1.0
        }
        
        self.init(red: red, green: green, blue: blue, opacity: alpha)
    }
    
    // Color -> Data
    func toData() -> Data? {
        // UIColorに変換
        let uiColor = UIColor(self)
        
        // RGBAの値を取得
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        // RGBAの値を配列に格納
        let colorArray: [CGFloat] = [red, green, blue, alpha]
        
        // 配列をDataとしてエンコード
        return try? JSONEncoder().encode(colorArray)
    }
    
    // Data -> Color
    init(fromData data: Data) {
        // DataをデコードしてRGBAの配列に変換
        guard let colorArray = try? JSONDecoder().decode([CGFloat].self, from: data),
              colorArray.count == 4 else {
            self.init(.gray) // デコード失敗時はデフォルト色
            return
        }
        
        // Colorの初期化
        self.init(red: colorArray[0], green: colorArray[1], blue: colorArray[2], opacity: colorArray[3])
    }
}


func colorToHexString(color: Color?) -> String? {
    // オプショナル型のColorをアンラップ
    guard let color = color else { return nil }
    
    // SwiftUIのColorをUIColorに変換
    let uiColor = UIColor(color)
    
    // RGBA成分を格納する変数
    var red: CGFloat = 0
    var green: CGFloat = 0
    var blue: CGFloat = 0
    var alpha: CGFloat = 0
    
    // UIColorからRGBA値を取得
    uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
    
    // RGB値を0-255の整数に変換
    let r = Int(red * 255)
    let g = Int(green * 255)
    let b = Int(blue * 255)
    
    // HEXコードを生成して返す
    return String(format: "#%02X%02X%02X", r, g, b)
}

