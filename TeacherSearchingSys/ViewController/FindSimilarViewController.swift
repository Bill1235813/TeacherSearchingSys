//
//  FindSimilarViewController.swift
//  TeacherSearchingSys
//
//  Created by ZW_apple on 2018-05-25.
//  Copyright © 2018 AwesomeBill. All rights reserved.
//

import UIKit

class FindSimilarViewController: UIViewController {
    var professor = PersonInfo()
    var imgFiles = [UIImage]()
    var smallIconFiles = [UIImage]()
    
    @IBOutlet weak var findSimilarScrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getImgFiles()
        setImgFiles()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func findTeacher(with name: String) -> PersonInfo? {
        for (_, value) in SchoolList.schools {
            for department in value.departmentList {
                for person in department.personList {
                    if person.name == name {
                        return person
                    }
                }
            }
        }
        return nil
    }
    
    func getImgFiles() {
        imgFiles.removeAll()
        if let personList = PersonInfo.similarList[professor.name] {
            for name in personList {
                if let person = findTeacher(with: name), let img = UIImage(named: person.imageWithName) {
                    imgFiles.append(img)
                    if let smallIcon = UIImage(named: person.imageSmallIcon) {
                        smallIconFiles.append(smallIcon)
                    } else {
                        print("Error! No Icon")
                    }
                }
            }
        }
    }
    
    func setImgFiles() {
        for subview in findSimilarScrollView.subviews {
            subview.removeFromSuperview()
        }
        findSimilarScrollView.frame = view.frame
        findSimilarScrollView.isScrollEnabled = true
        findSimilarScrollView.isUserInteractionEnabled = true
        
        if imgFiles.count > 0, imgFiles.count == smallIconFiles.count {
            let imgRatio = 75.0/70.0
            let height = self.findSimilarScrollView.frame.width / CGFloat(imgRatio)
            for imgCount in 0..<imgFiles.count {
                let yPosition = (self.findSimilarScrollView.frame.width + VCInfo.barSize)
                    * CGFloat(imgCount) / CGFloat(imgRatio)
                // image
                let imageView = UIImageView()
                imageView.frame = CGRect(x: 0, y: yPosition, width: findSimilarScrollView.frame.width, height: height)
                imageView.image = imgFiles[imgCount]
                // small icon
                let smallImage = UIImageView()
                smallImage.frame = CGRect(x: findSimilarScrollView.frame.width*2/3, y: 0, width: findSimilarScrollView.frame.width/3, height: height/8)
                smallImage.image = smallIconFiles[imgCount]
                imageView.addSubview(smallImage)
                findSimilarScrollView.addSubview(imageView)
                // add bar
                if imgCount != 0 {
                    VCInfo.addBar(in: findSimilarScrollView, with: yPosition - VCInfo.barSize/2)
                }
            }
            let totalHeight = (self.findSimilarScrollView.frame.width + VCInfo.barSize)
                * CGFloat(imgFiles.count) / CGFloat(imgRatio)
            findSimilarScrollView.contentSize = CGSize(width: view.frame.width, height: totalHeight)
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
