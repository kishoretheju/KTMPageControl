//
//  KTMPageControl.swift
//  KTMPageControl
//
//  Created by Kishore Thejasvi on 14/02/2017.
//  Copyright © 2017 Kishore Thejasvi. All rights reserved.
//

import UIKit

public protocol KTMPageControlDataSource: UIPageViewControllerDataSource {
    func titlesForPagesInPageControl(_ pageControl: KTMPageControl) -> [String]
    func pageControl(_ pageControl: KTMPageControl, indexFor viewController: UIViewController) -> UInt
    func pageControl(_ pageControl: KTMPageControl, viewControllerFor index: UInt) -> UIViewController
}

open class KTMPageControl: UIView, UIPageViewControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var pagesContainerView: UIView!
    
    public var datasource: KTMPageControlDataSource!
    public var headerCollectionView: UICollectionView!
    public let cellIdentifier = "headerCellIdentifier"
    public var pageVC: KTMPageViewController!
    public var headerTextFontSize = UIFont.systemFont(ofSize: 14)
    
    public var pageTitles: [String]! {
        didSet {
            createAndAddCollectionView()
        }
    }
    public var currentPage: Int?
    
    // #MARK: - Header Related Values
    public var headerTextFont: UIFont?
    public var headerTextColor = UIColor.white
    public var highlightViewColor = UIColor.white
    public var normalTextAlpha: CGFloat = 0.75
    public var headerCellBackgroundColor = UIColor(red: 0, green: 188.0/255.0, blue: 212/255.0, alpha: 1.0)
    
    override open func awakeFromNib() {
        super.awakeFromNib()    
    }
    
    open func initializePageControlUsing(firstViewController firstVc: UIViewController, andAddTo parentViewController: UIViewController) {
        pageTitles = datasource.titlesForPagesInPageControl(self)
        
        guard pageTitles.count != 0 else {
            return
        }
        
        pageVC = KTMPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        pageVC.dataSource = datasource
        pageVC.delegate = self
        pageVC.view.translatesAutoresizingMaskIntoConstraints = false;
        
        KTMUtilities.add(childVC: pageVC, toView: pagesContainerView, inVC: parentViewController)
        
        pagesContainerView.addConstraints(KTMUtilities.constraintsToPin(subView: pageVC.view, toSuperView: pagesContainerView))
        
        pageVC.setViewControllers([firstVc], direction: .forward, animated: false, completion: nil)
        
        currentPage = 0;
    }
    
    open func createAndAddCollectionView() {
        headerCollectionView = collectionViewWith(frame: CGRect.init(x: 0, y: 0, width: 100, height: 35))
        headerCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        let nibName = UINib(nibName: "KTMHeaderCollectionViewCell", bundle: Bundle(for: KTMPageControl.self))
        headerCollectionView.register(nibName, forCellWithReuseIdentifier: cellIdentifier)
        
        headerCollectionView.delegate = self
        headerCollectionView.dataSource = self
        
        headerView.addSubview(headerCollectionView)
        headerView.addConstraints(KTMUtilities.constraintsToPin(subView: headerCollectionView, toSuperView: headerView))
        let heightConstraint = KTMUtilities.constraintToPin(attribute: .height, ofView: headerCollectionView, toAttribute: .notAnAttribute, ofView: nil, withMultiplier: 1.0, constant: 35.0, andRelation: .equal)
        headerCollectionView.addConstraint(heightConstraint)
        
        headerCollectionView.reloadData()
    }
    
    open func collectionViewWith(frame viewFrame: CGRect) -> UICollectionView {
        let collectionView = UICollectionView.init(frame: viewFrame, collectionViewLayout: collectionViewLayout())
        collectionView.backgroundColor = UIColor.clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.bounces = false
        return collectionView
    }
    
    open func collectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize.init(width: 100, height: 35)
        layout.minimumInteritemSpacing = 0.0
        layout.minimumLineSpacing = 0.0
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        layout.scrollDirection = .horizontal
        return layout
    }
    
    // MARK: - UIPageViewControllerDelegate
    public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        guard let vc = pageViewController.viewControllers?[0] else {
            return
        }
        
        currentPage = Int(datasource.pageControl(self, indexFor: vc))
        headerCollectionView.reloadData()
        headerCollectionView.scrollToItem(at: IndexPath(row: currentPage!, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    // MARK: - UICollectionViewDataSource
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        assert(pageTitles != nil , "pageTitles value is not set, please set a valid value to that property")
        return pageTitles.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: KTMHeaderCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! KTMHeaderCollectionViewCell
        
        if let _ = headerTextFont {
            cell.textLabel.font = headerTextFont
        }
        
        cell.textLabel.textColor = headerTextColor
        cell.highlightViewColor = highlightViewColor
        
        if let _ = headerTextFont {
            cell.textLabel.font = headerTextFont
        }
        
        cell.normalTextAlpha = normalTextAlpha
        
        cell.should(hightlightCell: currentPage! == indexPath.row)
        cell.backgroundColor = headerCellBackgroundColor
        cell.textLabel.text = pageTitles[indexPath.row]
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row != currentPage {
            let vc = datasource.pageControl(self, viewControllerFor: UInt(indexPath.row))
            
            var direction:UIPageViewControllerNavigationDirection
            if indexPath.row > currentPage! {
                direction = .forward
            }
            else {
                direction = .reverse
            }
            
            pageVC.setViewControllers([vc], direction: direction, animated: true, completion: nil)
            
            currentPage = indexPath.row
            collectionView.reloadData()
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellText = pageTitles[indexPath.row]
        let textFont = headerTextFontSize
        
        let textRect = cellText.boundingRect(with: CGSize.init(width: 200, height: textFont.lineHeight + 1), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: textFont], context: nil)
        let roundOffSize = CGSize.init(width: ceil(textRect.size.width), height: ceil(textRect.size.height))
        let outSize = CGSize.init(width: max(roundOffSize.width + 16, 125), height: headerCollectionView.frame.size.height)
        return outSize
    }
}
