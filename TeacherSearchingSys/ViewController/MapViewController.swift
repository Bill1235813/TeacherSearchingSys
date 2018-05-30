//
//  ViewController.swift
//  TeacherSearchingSys
//
//  Created by ZW_apple on 2018-05-24.
//  Copyright © 2018 AwesomeBill. All rights reserved.
//

import UIKit

class MapViewController: UIViewController, UIScrollViewDelegate {
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
        bookmarkButton.setImage(UIImage(named: VCInfo.notSelectedStar), for: .normal)
        view.addSubview(bookmarkButton)
        view.addSubview(searchingText)
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
    }
    
    func disableGesture() {
        searchingText.text = ""
        imageFlag = true
        mapScrollView.pinchGestureRecognizer?.isEnabled = false
        mapScrollView.panGestureRecognizer.isEnabled = false
        mapImage.isUserInteractionEnabled = false
        bookmarkButton.isEnabled = false
        searchingText.isEnabled = false
    }
    
    func enableGesture() {
        mapScrollView.pinchGestureRecognizer?.isEnabled = true
        mapScrollView.panGestureRecognizer.isEnabled = true
        mapImage.isUserInteractionEnabled = true
        bookmarkButton.isEnabled = true
        searchingText.isEnabled = true
        imageFlag = false
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
        let width = view.frame.width
        let height = view.frame.width / CGFloat(School.map.0 / School.map.1)
        let mapY = (view.frame.height - view.frame.width / CGFloat(School.map.0 / School.map.1)) / 2
        mapImage.frame = CGRect(x: 0, y: mapY, width: width, height: height)
        mapImage.isUserInteractionEnabled = true
//        mapImage.contentMode = .scaleAspectFit
        mapScrollView.addSubview(mapImage)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return mapImage
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if scrollView.zoomScale < 3 {
                removeButtons()
        } else {
                setButtons()
        }
    }
}

