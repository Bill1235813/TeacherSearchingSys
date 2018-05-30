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
        "南艺-副教授":["刘谯","孙海燕","戈洪","童芳","莫雄"],
        "南艺-正教授":[],
        "同济-副教授":["丁峻峰","刘力丹","刘震元","杜守帅","陈永群","高搏"],
        "同济-正教授":["曹楠","曹炜","范凌","董华","陈健"],
        "央美-工业设计":["吴永平","张所家","李卫","江黎","王沂蓬","赵斌"],
        "江南-工业设计":["钱晓波","巩淼森","邓嵘","陈香","鲍懿喜"],
        "江南-正教授":["张凌浩","徐诚一","杨茂川","王安霞","辛向阳","过伟敏"],
        "浙大-工业设计":["历向东","孙凌云","孙守迁","应放天","张三元","张克俊","张旭生","彭韧","徐雯洁","杨颖","柴春雷","汤永川","罗仕鉴","郑林风","陈实","黄琦"],
        "浙大-艺术学":["刘国柱","吴小平","吴强","吴晓明","周慧军","李承华","来萧敏","杨丰","林如","毛晓芬","江崇岩","池长庆","汪永江","沈华清","沙伟","王小松","王钟涛","章屹","胡小军","苏阿香","谢继胜","赵敏住","邱建新","郭翀","金晓明","陈振濂","陈谷香","马楠","高艳","黄厚明","黄杰","黄河清"],
        "清华-工业设计":["蔡军","刘吉昆","张旭晨","范寅良","蒋红斌"],
        "清华-陶瓷艺术设计":["李正安","李泓","王耀玲","白明","邱耿鈺"],
        "湖南-副教授":["宋立新","易军","花景勇","赵丹华","陈珂"],
        "湖南-正教授":["何人可","刘永红","谭浩","赵江洪","陈飞虎"],
        "苏州-艺术学":["姜竹松","李从芹","束霞平","范英豪","郑丽虹"]
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
