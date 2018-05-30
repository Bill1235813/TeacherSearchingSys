//
//  DepartmentViewController.swift
//  TeacherSearchingSys
//
//  Created by ZW_apple on 2018-05-25.
//  Copyright © 2018 AwesomeBill. All rights reserved.
//

import UIKit
import SwiftGifOrigin

class DepartmentViewController: UIViewController {
    var school = School(longName: "同济大学")
    var gifFiles = [UIImage]()
    
    @IBOutlet weak var departmentScrollView: UIScrollView!
    
    @IBOutlet weak var departmentNavigation: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        departmentNavigation.title = "专业类别"
        getGifFiles()
        setGifFiles()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextController = segue.destination as! SpecificDeptViewController
        let button = sender as! UIButton
        nextController.department = school.departmentList[button.tag]
    }
    
    @objc func scrollButtonAction(_ sender: UIButton) {
        performSegue(withIdentifier: "toSpecific", sender: sender)
    }
    
    func getGifFiles() {
        gifFiles.removeAll()
        let prefix = "UI-GIF"
        for department in school.departmentList {
            let filename = prefix + school.shortName + department.departmentName
            if let gif = UIImage.gif(asset: filename) {
                gifFiles.append(gif)
            }
        }
    }
    
    func setGifFiles() {
        for subview in departmentScrollView.subviews {
            subview.removeFromSuperview()
        }
        departmentScrollView.frame = view.frame
        departmentScrollView.isScrollEnabled = true
        departmentScrollView.isUserInteractionEnabled = true
        
        if gifFiles.count > 0 {
            let gifRatio = 1.25
            let height = self.departmentScrollView.frame.width / CGFloat(gifRatio)
            for gifCount in 0..<gifFiles.count {
                let yPosition = (self.departmentScrollView.frame.width + VCInfo.barSize)
                    * CGFloat(gifCount) / CGFloat(gifRatio)
                let Button = UIButton()
                Button.tag = gifCount
                Button.frame = CGRect(x: 0, y: yPosition, width: self.departmentScrollView.frame.width, height: height)
                Button.backgroundColor = UIColor.black
//                Button.setTitle(school.longName, for: .normal)
                Button.setImage(gifFiles[gifCount], for: .normal)
                Button.addTarget(self, action: #selector(scrollButtonAction(_:)), for: .touchUpInside)
                departmentScrollView.addSubview(Button)
                // add bar
                if gifCount != 0 {
                    VCInfo.addBar(in: departmentScrollView, with: yPosition - VCInfo.barSize/2)
                }
            }
            let totalHeight = (self.departmentScrollView.frame.width + VCInfo.barSize)
                * CGFloat(gifFiles.count) / CGFloat(gifRatio)
            departmentScrollView.contentSize = CGSize(width: view.frame.width, height: totalHeight)
        } else {
            print("No gif exist!")
        }
    }
}

extension UIImage {
    public class func gif(asset: String) -> UIImage? {
        if let asset = NSDataAsset(name: asset) {
            return UIImage.gif(data: asset.data)
        }
        return nil
    }
}
