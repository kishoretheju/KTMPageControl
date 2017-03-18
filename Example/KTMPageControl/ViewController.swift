//
//  ViewController.swift
//  KTMPageControl
//
//  Created by Kishore Thejasvi on 14/02/2017.
//  Copyright © 2017 Kishore Thejasvi. All rights reserved.
//

import UIKit
import KTMPageControl

class ViewController: UIViewController, KTMPageControlDataSource {
    @IBOutlet weak var containerView: UIView!
    var totalPages: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        automaticallyAdjustsScrollViewInsets = false
        
        createPageControl()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func createPageControl() {
        
        if let pageControl = KTMUtilities.viewForFileWith(name: "KTMPageControl") as? KTMPageControl {
            
            pageControl.datasource = self 
            pageControl.headerTextColor = UIColor.white
            pageControl.headerTextFont = UIFont.boldSystemFont(ofSize: 14)
            pageControl.highlightViewColor = UIColor.white
            pageControl.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview(pageControl)
            containerView.addConstraints(KTMUtilities.constraintsToPin(subView: pageControl, toSuperView: containerView))
            
            pageControl.initializePageControlUsing(firstViewController: eachPageViewController(forIndex: 0), andAddTo: self)
        }
    }
    
    func eachPageViewController(forIndex index: UInt) -> ExampleViewController {
        let exampleVc: ExampleViewController = KTMUtilities.viewControllerWith(identifier: "pageViewController", inStoryboardWithName: "Main") as! ExampleViewController
        exampleVc.pageIndex = index
        return exampleVc
    }
    
    // MARK: - KTMPageControlDataSource
    func titlesForPagesInPageControl(_ pageControl: KTMPageControl) -> [String] {
        let titles = ["FIRST", "SECOND", "THIRD", "FOURTH", "FIFTH"]
        totalPages = titles.count
        return titles
    }
    
    func pageControl(_ pageControl: KTMPageControl, indexFor viewController: UIViewController) -> UInt {
        let exampleVc: ExampleViewController = viewController as! ExampleViewController
        return exampleVc.pageIndex
    }
    
    func pageControl(_ pageControl: KTMPageControl, viewControllerFor index: UInt) -> UIViewController {
        let exampleVc = eachPageViewController(forIndex: index)
        return exampleVc
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let exampleVc = viewController as! ExampleViewController
        
        if exampleVc.pageIndex > 0 {
            return eachPageViewController(forIndex: exampleVc.pageIndex - 1)
        }
        
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let exampleVc = viewController as! ExampleViewController
        
        if exampleVc.pageIndex < UInt(totalPages) - 1 {
            return eachPageViewController(forIndex: exampleVc.pageIndex + 1)
        }
        
        return nil
    }
    
}
