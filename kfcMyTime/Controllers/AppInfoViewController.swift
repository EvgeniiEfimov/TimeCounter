//
//  AppInfoViewController.swift
//  kfcMyTime
//
//  Created by Евгений Ефимов on 13.07.2022.
//

import UIKit

class AppInfoViewController: UIViewController {
    @IBOutlet weak var pageControlOutlet: UIPageControl!
    @IBOutlet weak var imageViewOutlet: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func swipeHandler(_ gestureRecognizer : UISwipeGestureRecognizer) {
        if gestureRecognizer.state == .ended {
            print("true")
            if pageControlOutlet.currentPage < pageControlOutlet.numberOfPages - 1 {
            pageControlOutlet.currentPage += 1
            } else {
                pageControlOutlet.currentPage = 0
            }
        }
        if pageControlOutlet.currentPage == 0 {
            imageViewOutlet.image = UIImage(named: "infoAdd")
        }
        if pageControlOutlet.currentPage == 1 {
            imageViewOutlet.image = UIImage(named: "addIDataInfo")
        }
    }
}
