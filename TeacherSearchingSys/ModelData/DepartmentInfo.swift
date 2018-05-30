//
//  DepartmentInfo.swift
//  TeacherSearchingSys
//
//  Created by ZW_apple on 2018-05-25.
//  Copyright © 2018 AwesomeBill. All rights reserved.
//

import Foundation

class DepartmentInfo {
    var schoolName : String
    var departmentName : String
    var personList = [PersonInfo]()
    
    static let personDict : [String : [String]] = [
        "同济-正教授":["曹楠", "曹炜", "范凌", "董华", "陈健"],
        "央美-工业设计":["吴永平", "张所家", "李卫", "江黎", "王沂蓬", "赵斌"],
        "江南-工业设计":["钱晓波", "巩淼森", "邓嵘", "陈香", "鲍懿喜"],
        "江南-正教授":["张凌浩", "徐诚一", "杨茂川", "王安霞", "辛向阳", "过伟敏"],
        "浙大-工业设计":["历向东", "孙凌云", "孙守迁", "应放天", "张三元", "张克俊", "张旭生",
                       "彭韧", "徐雯洁", "杨颖", "柴春雷", "汤永川", "罗仕鉴", "郑林风", "陈实", "黄琦"],
        "清华-工业设计":["蔡军", "刘吉昆", "张旭晨", "范寅良", "蒋红斌"]
    ]
    
    init(schoolName: String, departmentName: String) {
        self.schoolName = schoolName
        self.departmentName = departmentName
        if let persons = DepartmentInfo.personDict[schoolName + "-" + departmentName] {
            for person in persons {
                personList.append(PersonInfo(name: person, schoolName: schoolName, departmentName: departmentName))
            }
        }
    }
}
