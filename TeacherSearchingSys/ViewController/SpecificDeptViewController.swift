//
//  SpecificDeptViewController.swift
//  TeacherSearchingSys
//
//  Created by ZW_apple on 2018-05-25.
//  Copyright © 2018 AwesomeBill. All rights reserved.
//

import UIKit

class SpecificDeptViewController: UIViewController {
    var department = DepartmentInfo(schoolName: "", departmentName: "")
    var imgFiles = [UIImage]()
    
    @IBOutlet weak var specificScrollView: UIScrollView!
    
    @IBOutlet weak var specificNavigation: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        specificNavigation.title = department.departmentName
        getImgFiles()
        setImgFiles()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextController = segue.destination as! PersonViewController
        let button = sender as! UIButton
        nextController.professor = department.personList[button.tag]
    }
    
    @objc func scrollButtonAction(_ sender: UIButton) {
        performSegue(withIdentifier: "toPerson", sender: sender)
    }
    
    func getImgFiles() {
        imgFiles.removeAll()
        for person in department.personList {
            if let img = UIImage(named: person.imageWithName) {
                imgFiles.append(img)
            }
        }
    }
    
    func setImgFiles() {
        for subview in specificScrollView.subviews {
            subview.removeFromSuperview()
        }
        specificScrollView.frame = view.frame
        specificScrollView.isScrollEnabled = true
        specificScrollView.isUserInteractionEnabled = true
        
        if imgFiles.count > 0 {
            let imgRatio = 75.0/70.0
            let height = self.specificScrollView.frame.width / CGFloat(imgRatio)
            for imgCount in 0..<imgFiles.count {
                let yPosition = (self.specificScrollView.frame.width + VCInfo.barSize)
                    * CGFloat(imgCount) / CGFloat(imgRatio)
                let Button = UIButton()
                Button.tag = imgCount
                Button.frame = CGRect(x: 0, y: yPosition, width: self.specificScrollView.frame.width, height: height)
                Button.backgroundColor = UIColor.black
                Button.setImage(imgFiles[imgCount], for: .normal)
                Button.addTarget(self, action: #selector(scrollButtonAction(_:)), for: .touchUpInside)
                specificScrollView.addSubview(Button)
                // add bar
                if imgCount != 0 {
                    VCInfo.addBar(in: specificScrollView, with: yPosition - VCInfo.barSize/2)
                }
            }
            let totalHeight = (self.specificScrollView.frame.width + VCInfo.barSize)
                * CGFloat(imgFiles.count) / CGFloat(imgRatio)
            specificScrollView.contentSize = CGSize(width: view.frame.width, height: totalHeight)
        } else {
            print("No img exist!")
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
