//
//  VCInfo.swift
//  TeacherSearchingSys
//
//  Created by ZW_apple on 2018-05-28.
//  Copyright © 2018 AwesomeBill. All rights reserved.
//

import Foundation
import UIKit

class VCInfo {
    static let barSize = CGFloat(20)
    static let radarImageRatio = CGFloat(75.0/70.0)
    static let radarImageRatioBlank = CGFloat(1.25)
    static let radarImageRatioNameOnly = CGFloat(7.5)
    static let faceImageRatio = CGFloat(3)
    static let noFaceImageRatio = CGFloat(3.5)
    static let noFace = "no-image-face"
    
    static let similarImage = "分析相似"
    static let notSelectedStar = "星星"
    static let mapStar = "首页-标记过老师列表"
    static let selectedStar = "星星-按下"
    static let select = "选取30" //"icons8-record-60"
    static let notSelectedCircle = "选中-空心2"
    static let selectedCircle = "选中-实心2"
    
    static let textLabelHeight = CGFloat(100)
    
    static func addBar(in view: UIView, with y: CGFloat) {
        let bar = UIView()
        bar.frame = CGRect(x: 0, y: y, width: view.frame.width, height: 1)
        bar.backgroundColor = UIColor(displayP3Red: 2/255.0, green: 15/255.0, blue: 50/255.0, alpha: 1.0)
        view.addSubview(bar)
    }
    
    static func addBar(in view: UIView, with y: CGFloat, of height: CGFloat) {
        let bar = UIView()
        bar.frame = CGRect(x: 0, y: y, width: view.frame.width, height: height)
        bar.backgroundColor = UIColor(displayP3Red: 2/255.0, green: 3/255.0, blue: 34/255.0, alpha: 1.0)
        view.addSubview(bar)
    }
}
