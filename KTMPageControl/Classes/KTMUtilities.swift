//
//  KTMUtilities.swift
//  KTMPageControl
//
//  Created by Kishore Thejasvi on 15/02/2017.
//  Copyright © 2017 Kishore Thejasvi. All rights reserved.
//

import UIKit

open class KTMUtilities: NSObject {
    public static func viewForFileWith(name fileName: String, in bundle: Bundle = Bundle(for: KTMPageControl.self)) -> UIView? {
        let array = bundle.loadNibNamed(fileName, owner: nil, options: nil)
        
        if let unwrappedArray = array {
            return unwrappedArray[0] as? UIView
        }
        
        return nil
    }
    
    public static func constraintsToPin(subView view1: UIView, toSuperView view2: UIView) -> [NSLayoutConstraint] {
        
        let leading = constraintToPin(attribute: .leading, ofView: view1, toAttribute: .leading, ofView: view2)
        let trailing = constraintToPin(attribute: .trailing, ofView: view1, toAttribute: .trailing, ofView: view2)
        let top = constraintToPin(attribute: .top, ofView: view1, toAttribute: .top, ofView: view2)
        let bottom = constraintToPin(attribute: .bottom, ofView: view1, toAttribute: .bottom, ofView: view2)
        
        return [leading, trailing, top, bottom]
    }
    
    public static func constraintToPin(attribute attr1: NSLayoutAttribute, ofView view1: UIView, toAttribute attr2: NSLayoutAttribute, ofView view2: UIView?, withMultiplier multiplier: CGFloat = 1.0, constant const: CGFloat = 0.0, andRelation relation: NSLayoutRelation = .equal) -> NSLayoutConstraint {
        return NSLayoutConstraint.init(item: view1, attribute: attr1, relatedBy: relation, toItem: view2, attribute: attr2, multiplier: multiplier, constant: const)
    }
    
    public static func viewControllerWith(identifier id: String, inStoryboardWithName name: String) -> UIViewController {
        let storyboard = UIStoryboard.init(name: name, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: id)
    }
    
    public static func add(childVC vc: UIViewController, toView view: UIView, inVC parentVC: UIViewController) {
        parentVC.addChildViewController(vc)
        view.addSubview(vc.view)
        vc.didMove(toParentViewController: parentVC)
    }
}
