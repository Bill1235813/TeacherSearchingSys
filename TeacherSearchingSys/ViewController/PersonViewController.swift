//
//  PersonViewController.swift
//  TeacherSearchingSys
//
//  Created by ZW_apple on 2018-05-25.
//  Copyright © 2018 AwesomeBill. All rights reserved.
//

import UIKit

class PersonViewController: UIViewController {
    var professor = PersonInfo()
    let similarImg = UIImage(named: VCInfo.similarImage)!
    let notMarkedImg = UIImage(named: VCInfo.notSelectedStar)!
    let markedImg = UIImage(named: VCInfo.selectedStar)!

    var topHeight : CGFloat = 0
    
    @IBOutlet weak var personScrollView: UIScrollView!
    @IBOutlet weak var personNavigation: UINavigationItem!
    @IBOutlet weak var bookmarkButton: UIButton!
    @IBOutlet weak var similarButton: UIButton!
    @IBOutlet weak var describeText: UILabel!
    
    @IBAction func addBookmark(_ sender: UIButton) {
        if (professor.marked) {
            professor.marked = false
            while let idx = BookmarkViewController.bookmarkList.index(of: professor) {
                BookmarkViewController.bookmarkList.remove(at: idx)
            }
        } else {
            professor.marked = true
            BookmarkViewController.bookmarkList.append(professor)
        }
        setImageIcon()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextController = segue.destination as! FindSimilarViewController
        nextController.professor = self.professor
    }
    
    @IBAction func findSimilar(_ sender: UIButton) {
        performSegue(withIdentifier: "toSimilar", sender: sender)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        topHeight = (self.navigationController?.navigationBar.frame.height ?? 0.0) + UIApplication.shared.statusBarFrame.size.height
        personNavigation.title = professor.name
        setImageIcon()
        setScrollView()
        view.addSubview(bookmarkButton)
        view.addSubview(similarButton)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setImageIcon() {
        similarButton.setImage(similarImg, for: .normal)
        if professor.marked {
            bookmarkButton.setImage(markedImg, for: .normal)
        } else {
            bookmarkButton.setImage(notMarkedImg, for: .normal)
        }
    }
    
    func setScrollView() {
        personScrollView.frame = view.frame
        personScrollView.isScrollEnabled = true
        personScrollView.isUserInteractionEnabled = true
        // add image
        let professorImg = UIImage(named: professor.imageWithName)!
        let imgRatio = VCInfo.radarImageRatio
        let imageView = UIImageView()
        imageView.image = professorImg
        let width = personScrollView.frame.width
        let height = personScrollView.frame.width / CGFloat(imgRatio)
        let yPosition = (personScrollView.frame.height - height)/2
        imageView.frame = CGRect(x: 0, y: yPosition, width: width, height: height)
        personScrollView.addSubview(imageView)
        // add bar
        VCInfo.addBar(in: personScrollView, with: yPosition, of: width/VCInfo.radarImageRatioNameOnly)
        // add face
        var faceRatio = VCInfo.faceImageRatio
        var faceImg = UIImage(named: professor.imageFace)
        if faceImg == nil {
            faceImg = UIImage(named: VCInfo.noFace)
            faceRatio = VCInfo.noFaceImageRatio
        }
        let faceView = UIImageView()
        let faceX = (width - width/faceRatio)/2
        let faceY = (yPosition + width/VCInfo.radarImageRatioNameOnly)/2 - width/faceRatio/2
        faceView.image = faceImg
        faceView.contentMode = .scaleAspectFit
        faceView.frame = CGRect(x: faceX, y: faceY, width: width/faceRatio, height: width/faceRatio)
        personScrollView.addSubview(faceView)
        // add label
        var text = String()
        if let list = PersonInfo.textList[professor.name] {
            if list.count > 2, list[2].count <= 15 {
                text = list[0] + "\n" + list[1] + "\n" + list[2]
            } else {
                text = list[0] + "\n" + list[1]
            }
        }
        describeText.frame = CGRect(x: 0, y: yPosition + width/VCInfo.radarImageRatio, width: width, height: VCInfo.textLabelHeight)
        describeText.text = text
        describeText.numberOfLines = 0
        describeText.textAlignment = .center
        describeText.font = UIFont.boldSystemFont(ofSize: 18)
        describeText.centerXAnchor.constraint(equalTo: self.personScrollView.centerXAnchor).isActive = true
        personScrollView.addSubview(describeText)
        personScrollView.contentSize = CGSize(width: width, height: yPosition + width/VCInfo.radarImageRatio + VCInfo.textLabelHeight)
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

extension UIImage {
    func alpha(_ value:CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: CGPoint.zero, blendMode: .normal, alpha: value)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}
