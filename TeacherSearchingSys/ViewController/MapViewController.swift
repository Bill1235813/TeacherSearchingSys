//
//  ViewController.swift
//  TeacherSearchingSys
//
//  Created by ZW_apple on 2018-05-24.
//  Copyright © 2018 AwesomeBill. All rights reserved.
//

import UIKit

class MapViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate {
    var schoolList = SchoolList()
    var icons = [UIButton]()
    var images = [UIButton]()
    var zoomFlag = false
    var imageFlag = false
    var selectedSchoolImg = UIButton()
    
    let mapImage = UIImageView(image: UIImage(named: "map"))
    
    @IBOutlet weak var searchingText: UITextField!
    @IBOutlet weak var bookmarkButton: UIButton!
    @IBOutlet weak var mapScrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setScrollView()
        addButtons()
        setSearchingText()
        setBookmarkButton()
        
        view.addSubview(bookmarkButton)
        view.addSubview(searchingText)
        
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
//        view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
//        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is DepartmentViewController {
            let nextController = segue.destination as! DepartmentViewController
            let button = sender as! UIButton
            if SchoolList.schools[button.titleLabel!.text!] != nil {
                nextController.school = SchoolList.schools[button.titleLabel!.text!]!
            }
        }
    }
    
    @objc func goBookmark(_ sender: UIButton) {
        if sender.titleLabel?.text != nil {
            performSegue(withIdentifier: "toBookmark", sender: sender)
        }
//        clearText()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func CentralArtEnter(_ sender: UIButton) {
        enableGesture()
        sender.removeFromSuperview()
        if sender.titleLabel != nil {
            if sender.titleLabel?.text != nil {
                performSegue(withIdentifier: "toDepartment", sender: sender)
            }
        }
    }
    
    @objc func WrongSelection(_ sender: UIButton) {
        sender.removeFromSuperview()
    }
    
    @objc func Selection(_ sender: UIButton) {
        if let idx = icons.index(of: sender) {
            view.addSubview(images[idx])
            selectedSchoolImg = images[idx]
            disableGesture()
        }
    }
    
    @objc func imageViewTapped() {
        if imageFlag == true {
            enableGesture()
            selectedSchoolImg.removeFromSuperview()
        }
        view.endEditing(true)
    }
    
    @objc func handleDoubleTapScrollView(recognizer: UITapGestureRecognizer) {
        if !imageFlag {
            if mapScrollView.zoomScale == 1 {
                mapScrollView.zoom(to: zoomRectForScale(scale: VCInfo.doubleTapRatio, center: recognizer.location(in: recognizer.view)), animated: true)
            } else {
                mapScrollView.setZoomScale(1, animated: true)
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
    
    func clearText() {
        searchingText.text = ""
    }
    
    func disableGesture() {
//        clearText()
        imageFlag = true
        mapScrollView.pinchGestureRecognizer?.isEnabled = false
        mapScrollView.panGestureRecognizer.isEnabled = false
        mapImage.isUserInteractionEnabled = false
        mapImage.layer.backgroundColor = UIColor(rgb: VCInfo.backgroundColor).cgColor
        mapImage.layer.opacity = VCInfo.shadowOpacity
        bookmarkButton.isEnabled = false
        searchingText.isEnabled = false
    }
    
    func enableGesture() {
        mapScrollView.pinchGestureRecognizer?.isEnabled = true
        mapScrollView.panGestureRecognizer.isEnabled = true
        mapImage.isUserInteractionEnabled = true
        mapImage.layer.opacity = VCInfo.fullOpacity
        bookmarkButton.isEnabled = true
        searchingText.isEnabled = true
        imageFlag = false
    }
    
    func setSearchingText() {
        searchingText.delegate = self
        searchingText.clearButtonMode = UITextFieldViewMode.always
    }
    
    func setBookmarkButton() {
        bookmarkButton.setImage(UIImage(named: VCInfo.mapStar), for: .normal)
        bookmarkButton.addTarget(self, action: #selector(goBookmark(_:)), for: .touchUpInside)
    }
    
    func addButtons() {
        if icons.count == 0 {
            for (_, school) in SchoolList.schools {
                // icons
                let iconButton = UIButton()
                let icon = UIImage(named: school.iconName)
                let width = mapImage.frame.width
                let height = mapImage.frame.height
//                let mapY = (view.frame.height - view.frame.width / CGFloat(School.map.0 / School.map.1)) / 2
                let iconX = width * CGFloat(school.position.0) - 5
                let iconY = height * CGFloat(school.position.1) - 5 // + mapY
//                iconButton.setTitle(school.longName, for: .normal)
                iconButton.setImage(icon, for: .normal)
                iconButton.frame = CGRect(x: iconX, y: iconY, width: 10, height: 10)
                iconButton.addTarget(self, action: #selector(Selection(_:)), for: .touchUpInside)
                icons.append(iconButton)
                
                // images
                let imageButton = UIButton()
                let image = UIImage(named: school.imageName)
                let side = height>width ? height/2 : width/2
                let imageX = (view.frame.width - side) / 2
                let imageY = (view.frame.height - side) / 2
                imageButton.setTitle(school.longName, for: .normal)
                imageButton.setImage(image, for: .normal)
                imageButton.frame = CGRect(x: imageX, y: imageY, width: side, height: side)
                imageButton.addTarget(self, action: #selector(CentralArtEnter(_:)), for: .touchUpInside)
//                imageButton.addTarget(self, action: #selector(WrongSelection(_:)), for: .touchUpOutside)
                images.append(imageButton)
            }
        }
    }
    
    func removeButtons() {
        if zoomFlag {
            for icon in icons {
                icon.removeFromSuperview()
            }
            zoomFlag = false
        }
    }
    
    func setButtons() {
        if !zoomFlag {
            for icon in icons {
                mapImage.addSubview(icon)
            }
            zoomFlag = true
        }
    }
    
    func setScrollView() {
        mapScrollView.minimumZoomScale = 1.0
        mapScrollView.maximumZoomScale = 8.0
        mapScrollView.frame = view.frame
        mapScrollView.pinchGestureRecognizer?.isEnabled = true
        mapScrollView.panGestureRecognizer.isEnabled = true
        mapScrollView.isScrollEnabled = true
        mapScrollView.isUserInteractionEnabled = true
        let imageViewTap = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
        imageViewTap.numberOfTapsRequired = 1
        mapScrollView.addGestureRecognizer(imageViewTap)
        let imageViewDoubleTap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTapScrollView(recognizer:)))
        imageViewDoubleTap.numberOfTapsRequired = 2
        mapScrollView.addGestureRecognizer(imageViewDoubleTap)
        let width = view.frame.width
        let height = view.frame.width / CGFloat(School.map.0 / School.map.1)
        let mapY = (view.frame.height - view.frame.width / CGFloat(School.map.0 / School.map.1)) / 2
        mapImage.frame = CGRect(x: 0, y: mapY, width: width, height: height)
        mapImage.isUserInteractionEnabled = true
//        mapScrollView.contentMode = .scaleAspectFit
        mapScrollView.addSubview(mapImage)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return mapImage
    }
    
    func zoomRectForScale(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        zoomRect.size.height = mapImage.frame.size.height / scale
        zoomRect.size.width  = mapImage.frame.size.width  / scale
        let newCenter = mapImage.convert(center, from: mapScrollView)
        zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 2.0)
        return zoomRect
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if scrollView.zoomScale < VCInfo.zoomRatio {
                removeButtons()
        } else {
                setButtons()
        }
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")

        self.init(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}

