//
//  School.swift
//  TeacherSearchingSys
//
//  Created by ZW_apple on 2018-05-25.
//  Copyright © 2018 AwesomeBill. All rights reserved.
//

import Foundation

class School {
    var longName : String
    var shortName : String
    var departmentList = [DepartmentInfo]()
    var position : (Double, Double)
    
    var iconName = String()
    var imageName = String()
    
    static let map = (1521.0, 1540.0)
    static let departmentDict : [String : [String]] = [
        "同济" : ["正教授"],
        "央美" : ["工业设计"],
        "江南" : ["工业设计", "正教授"],
        "浙大" : ["工业设计", "艺术学"],
        "清华" : ["工业设计", "陶瓷艺术设计"]
    ]
    static let nameDict : [String : String] = [
        "同济大学" : "同济",
        "中央美术学院" : "央美",
        "江南大学" : "江南",
        "浙江大学" : "浙大",
        "清华大学" : "清华"
    ]
    static let positionDist : [String: (Double, Double)] = [
        "同济" : (1295, 760),
        "央美" : (1135, 482),
        "江南" : (1245, 737),
        "浙大" : (1252, 800),
        "清华" : (1110, 482)
    ]
    
    init(longName : String) {
        self.longName = longName
        if let short = School.nameDict[longName] {
            shortName = short
            let positionInt = School.positionDist[short]!
            position.0 = positionInt.0 / School.map.0
            position.1 = positionInt.1 / School.map.1
            iconName = "学校位置icons-" + short + "-尺寸417"
            imageName = short + "350"
            if let deparments = School.departmentDict[shortName] {
                for department in deparments {
                    departmentList.append(DepartmentInfo(schoolName: shortName, departmentName: department))
                }
            }
        } else {
            shortName = ""
            position = (0, 0)
            print("Error!" + longName + " not in database")
        }
    }
}
