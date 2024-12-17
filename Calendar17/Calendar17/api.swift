import SwiftUI

struct api: View {
    @State private var selectedColor: Color = .red
    @State private var hexCode: String? = nil
    
    var body: some View {
        VStack {
            // ColorPickerで色を選択
            ColorPicker("色を選択", selection: $selectedColor, supportsOpacity: true)
                .padding()
            
            // HEXコードに変換
            Button("HEXコードに変換") {
                hexCode = colorToHexString(color: selectedColor)
            }
            .padding()
            
            // HEXコード表示
            Text("HEXコード: \(hexCode ?? "不明")")
                .font(.headline)
                .padding()
            
            // 変換したHEXコードから色を適用
            Rectangle()
                .fill(Color(hex: hexCode ?? "#000000"))
                .frame(width: 100, height: 100)
        }
    }
}

#Preview {
    api()
}
