//
//  SlashViewController.swift
//  bus
//
//  Created by HeartNest on 12/11/14.
//  Copyright (c) 2014 asscubo. All rights reserved.
//

import UIKit

class SlashViewController: UIViewController {
    
    let LOGKEY = "userdefualtlogkey"
    let LASTSKEY = "userdefualtlastsearchkey"
    
    
    var pageIndex : Int = 0
    var titleText : String = ""
    var imageFile : String = ""

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
//        view.backgroundColor = UIColor(patternImage: UIImage(named: imageFile)!)
        
//        let label = UILabel(frame: CGRectMake(0, 0, view.frame.width, 200))
//        label.textColor = UIColor.whiteColor()
//        label.text = titleText
//        label.textAlignment = .Center
//        view.addSubview(label)
        

    }

    
    func updateSearchLog(newStr:String){
        var old: String = ""
        if(NSUserDefaults().objectForKey(LOGKEY) != nil){
            old = NSUserDefaults().objectForKey(LOGKEY) as String;
        }
        let splittedcheck = old.componentsSeparatedByString(newStr)
        let size :Int = splittedcheck.count
        if(size == 1){
            old += "@\(newStr)"
            NSUserDefaults().setObject(old, forKey: LOGKEY)
            
        }
        NSUserDefaults().setObject(newStr, forKey: LASTSKEY)
        NSUserDefaults().synchronize()
    }

}
