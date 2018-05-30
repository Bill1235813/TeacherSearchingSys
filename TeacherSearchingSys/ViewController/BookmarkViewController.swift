//
//  BookmarkViewController.swift
//  TeacherSearchingSys
//
//  Created by ZW_apple on 2018-05-26.
//  Copyright © 2018 AwesomeBill. All rights reserved.
//

import UIKit

class BookmarkViewController: UIViewController {
    static var bookmarkList = [PersonInfo]()
    
    let notSelectedImg = UIImage(named: VCInfo.notSelectedCircle)
    let selectedImg = UIImage(named: VCInfo.selectedCircle)
    let compareRadar = UIButton()
    
    let radarNamePrefix = "叠加雷达图-"
    
    var imgFiles = [UIImage]()
    
    var nameList = [String]()
    var compareFlag = false
    var selectMode = false
    var selectedNumber = 0
    
    @IBOutlet weak var bookmarkScrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        selectMode = false
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: VCInfo.select), style: .done, target: self, action: #selector(selectBookmark(_:)))
        setupScrollView()
        getImgFiles()
        setImgFiles()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getImgFiles() {
        imgFiles.removeAll()
        for person in BookmarkViewController.bookmarkList {
            if let img = UIImage(named: person.imageWithName) {
                imgFiles.append(img)
            }
        }
    }
    
    func setupScrollView() {
        let scrollViewTap = UITapGestureRecognizer(target: self, action: #selector(scrollViewTapped))
        scrollViewTap.numberOfTapsRequired = 1
        bookmarkScrollView.addGestureRecognizer(scrollViewTap)
    }
    
    func setImgFiles() {
        for subview in bookmarkScrollView.subviews {
            subview.removeFromSuperview()
        }
        bookmarkScrollView.frame = view.frame
        bookmarkScrollView.isScrollEnabled = true
        bookmarkScrollView.isUserInteractionEnabled = true
        
        if imgFiles.count > 0 {
            let imgRatio = 75.0/70.0
            let height = self.bookmarkScrollView.frame.width / CGFloat(imgRatio)
            for imgCount in 0..<imgFiles.count {
                let yPosition = (self.bookmarkScrollView.frame.width + VCInfo.barSize)
                    * CGFloat(imgCount) / CGFloat(imgRatio)
                // image
                let imageView = UIImageView()
                imageView.frame = CGRect(x: 0, y: yPosition, width: self.bookmarkScrollView.frame.width, height: height)
                imageView.image = imgFiles[imgCount]
                // small icon
                if let smallIcon = UIImage(named: BookmarkViewController.bookmarkList[imgCount].imageSmallIcon) {
                    let smallImage = UIImageView()
                    smallImage.frame = CGRect(x: bookmarkScrollView.frame.width*2/3, y: 0, width: bookmarkScrollView.frame.width/3, height: height/8)
                    smallImage.image = smallIcon
                    imageView.addSubview(smallImage)
                }
                bookmarkScrollView.addSubview(imageView)
                // add bar
                if imgCount != 0 {
                    VCInfo.addBar(in: bookmarkScrollView, with: yPosition - VCInfo.barSize/2)
                }
            }
            let totalHeight = (self.bookmarkScrollView.frame.width + VCInfo.barSize)
                * CGFloat(imgFiles.count) / CGFloat(imgRatio)
            bookmarkScrollView.contentSize = CGSize(width: view.frame.width, height: totalHeight)
        } else {
            print("No img exist!")
        }
    }
    
    func setImgFilesSelected() {
        for subview in bookmarkScrollView.subviews {
            subview.removeFromSuperview()
        }
        bookmarkScrollView.frame = view.frame
        bookmarkScrollView.isScrollEnabled = true
        bookmarkScrollView.isUserInteractionEnabled = true
        
        if imgFiles.count > 0 {
            let imgRatio = CGFloat(75.0/70.0)
            let scaleRatio = CGFloat(0.8)
            let height = bookmarkScrollView.frame.width / CGFloat(imgRatio)
            for imgCount in 0..<imgFiles.count {
                let yPosition = (bookmarkScrollView.frame.width + VCInfo.barSize)
                    * CGFloat(imgCount) / imgRatio
                let imageY = yPosition + (bookmarkScrollView.frame.width / imgRatio * (1 - scaleRatio) / 2)
                // set images
                let imageView = UIImageView()
                imageView.frame = CGRect(x: bookmarkScrollView.frame.width * (1 - scaleRatio), y: imageY, width: bookmarkScrollView.frame.width * scaleRatio, height: height * scaleRatio)
                imageView.image = imgFiles[imgCount]
                // set icons
                if let smallIcon = UIImage(named: BookmarkViewController.bookmarkList[imgCount].imageSmallIcon) {
                    let smallImage = UIImageView()
                    let iconX = bookmarkScrollView.frame.width * 2 / 3 * scaleRatio
                    let iconWidth = bookmarkScrollView.frame.width / 3 * scaleRatio
                    let iconHeight = height / 8 * scaleRatio
                    smallImage.frame = CGRect(x: iconX, y: 0, width: iconWidth, height: iconHeight)
                    smallImage.image = smallIcon
                    imageView.addSubview(smallImage)
                }
                bookmarkScrollView.addSubview(imageView)
                // add bar
                if imgCount != 0 {
                    VCInfo.addBar(in: bookmarkScrollView, with: yPosition - VCInfo.barSize/2)
                }
                // set buttons
                let buttonWidth = bookmarkScrollView.frame.width * (1 - scaleRatio) / 2
                let buttonY = yPosition + bookmarkScrollView.frame.width / imgRatio * 0.5
                let button = UIButton()
                button.tag = imgCount
                button.frame = CGRect(x: buttonWidth / 2, y: buttonY, width: buttonWidth, height: buttonWidth)
                button.setImage(notSelectedImg, for: .normal)
                button.addTarget(self, action: #selector(scrollButtonAction(_:)), for: .touchUpInside)
                bookmarkScrollView.addSubview(imageView)
                bookmarkScrollView.addSubview(button)
            }
            let totalHeight = (self.bookmarkScrollView.frame.width + VCInfo.barSize)
                * CGFloat(imgFiles.count) / imgRatio
            bookmarkScrollView.contentSize = CGSize(width: view.frame.width, height: totalHeight)
        } else {
            print("No img exist!")
        }
    }
    
    @objc func selectBookmark(_ sender: UIButton) {
        if selectMode {
            selectMode = false
            selectedNumber = 0
            setImgFiles()
        } else {
            selectMode = true
            setImgFilesSelected()
        }
    }
    
    @objc func scrollViewTapped() {
        if compareFlag == true {
            bookmarkScrollView.isScrollEnabled = true
            compareRadar.removeFromSuperview()
            compareFlag = false
        }
    }
    
    @objc func scrollButtonAction(_ sender: UIButton) {
        let name = BookmarkViewController.bookmarkList[sender.tag].name
        if let img = sender.imageView?.image {
            if img == selectedImg {
                sender.setImage(notSelectedImg, for: .normal)
                selectedNumber -= 1
                let idx = nameList.index(of: name)!
                nameList.remove(at: idx)
            } else {
                sender.setImage(selectedImg, for: .normal)
                selectedNumber += 1
                nameList.append(name)
            }
        }
        if selectedNumber == 2 {
            let radarNameP1 = self.radarNamePrefix + nameList[0] + "-" + nameList[1]
            let radarNameP2 = self.radarNamePrefix + nameList[1] + "-" + nameList[0]
            if let compareImg = UIImage(named: radarNameP1) {
                setRadarImg(compareImg)
            } else if let compareImg = UIImage(named: radarNameP2) {
                setRadarImg(compareImg)
            }
        }
    }
    
    func setRadarImg(_ image: UIImage) {
        compareRadar.frame = CGRect(x: 0, y: bookmarkScrollView.frame.height/2 - bookmarkScrollView.frame.width/2, width: bookmarkScrollView.frame.width, height: bookmarkScrollView.frame.width)
        compareRadar.setImage(image, for: .normal)
        compareRadar.tag = 0
        view.addSubview(compareRadar)
        compareFlag = true
        bookmarkScrollView.isScrollEnabled = false
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
