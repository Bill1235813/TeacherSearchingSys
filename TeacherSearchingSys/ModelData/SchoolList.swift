//
//  SchoolList.swift
//  TeacherSearchingSys
//
//  Created by ZW_apple on 2018-05-26.
//  Copyright © 2018 AwesomeBill. All rights reserved.
//

import Foundation

class SchoolList {
    static let schoolNames = ["清华大学", "同济大学", "中央美术学院", "江南大学", "浙江大学"]
    static var schools = [String : School]()
    
    init() {
        for schoolName in SchoolList.schoolNames {
            SchoolList.schools[schoolName] = School(longName: schoolName)
        }
    }
}
