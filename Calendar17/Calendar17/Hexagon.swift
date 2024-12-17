//
//  Hexagon.swift
//  Calendar17
//
//  Created by 冨成 祐羽 on 2024/12/17.
//
import SwiftUI

struct Hexagon: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let width = rect.size.width
        let height = rect.size.height
        
        // 六角形の6つの頂点を計算
        let points = [
            CGPoint(x: width * 0.5, y: 0),
            CGPoint(x: width, y: height * 0.25),
            CGPoint(x: width, y: height * 0.75),
            CGPoint(x: width * 0.5, y: height),
            CGPoint(x: 0, y: height * 0.75),
            CGPoint(x: 0, y: height * 0.25)
        ]
        
        // 頂点を繋げてパスを作成
        path.move(to: points[0])
        points.dropFirst().forEach { path.addLine(to: $0) }
        path.closeSubpath()
        
        return path
    }
}
