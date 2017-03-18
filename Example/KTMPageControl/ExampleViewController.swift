//
//  ExampleViewController.swift
//  KTMPageControl
//
//  Created by Kishore Thejasvi on 19/02/2017.
//  Copyright © 2017 Kishore Thejasvi. All rights reserved.
//

import UIKit

class ExampleViewController: UIViewController {
    @IBOutlet weak var textLabel: UILabel!
    var pageIndex: UInt!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        textLabel.text = "Page \(pageIndex!)"
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
