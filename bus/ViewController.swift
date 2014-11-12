//
//  ViewController.swift
//  bus
//
//  Created by HeartNest on 11/11/14.
//  Copyright (c) 2014 asscubo. All rights reserved.
//

import UIKit


class ViewController: SlashViewController,UIPageViewControllerDataSource {
    @IBOutlet weak var resLabel: UILabel!

    var pageViewController : UIPageViewController?
    
    var pageTitles : Array<String> = ["God vs Man", "Cool Breeze", "Fire Sky"]
    var pageImages : Array<String> = ["page1.png", "page2.png", "page3.png"]
    var currentIndex : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
        pageViewController!.dataSource = self
        
        let startingViewController = viewControllerAtIndex(0)!
        let viewControllers: NSArray = [startingViewController]
        pageViewController!.setViewControllers(viewControllers, direction: .Forward, animated: false, completion: nil)
        pageViewController!.view.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
        
        addChildViewController(pageViewController!)
        view.addSubview(pageViewController!.view)
        pageViewController!.didMoveToParentViewController(self)
        
        
    }
  
    @IBAction func click(sender: AnyObject) {
        println("Button tapped")
        
        var url: NSURL = NSURL(string: "https://solweb.tper.it/tperit/webservices/hellobus.asmx/QueryHellobus?fermata=33&linea=33&oraHHMM=")!
        var request1: NSURLRequest = NSURLRequest(URL: url)
        let queue:NSOperationQueue = NSOperationQueue()
        
        NSURLConnection.sendAsynchronousRequest(request1, queue: queue, completionHandler:{ (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            /* Your code */
            
            
            var err: NSError
            
            let xmlArrival = NSString(data: data, encoding: NSUTF8StringEncoding)
            let xmlNSArrival: String = xmlArrival!
            
            println("original "+xmlNSArrival)
            
            let notagArrival = xmlNSArrival.stringByReplacingOccurrencesOfString("</string>", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
            let splittedcombi = notagArrival.componentsSeparatedByString("TperHellobus: ")
            
            println("then "+splittedcombi[1])
            
            let splitted = splittedcombi[1].componentsSeparatedByString(", ")
            

            println("Result\n \(splitted[0]) \n \(splitted[1])")
            
            
        })
    }
    
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController?
    {
        var index = (viewController as TableViewController).pageIndex
        
        if (index == 0) || (index == NSNotFound) {
            return nil
        }
        
        index--
        
        return viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController?
    {
        var index = (viewController as TableViewController).pageIndex
        
        if index == NSNotFound {
            return nil
        }
        
        index++
        
        if (index == self.pageTitles.count) {
            return nil
        }
        
        return viewControllerAtIndex(index)
    }
    
    func viewControllerAtIndex(index: Int) -> SlashViewController?
    {
        if self.pageTitles.count == 0 || index >= self.pageTitles.count
        {
            println("here")
            return nil
        }
        
        if(index == 0){
            
        }else{
            // Create a new view controller and pass suitable data.
            let pageContentViewController = TableViewController()
            pageContentViewController.titleText = pageTitles[index]
            pageContentViewController.pageIndex = index
        }
        
        
        currentIndex = index
        
        return pageContentViewController
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int
    {
        return self.pageTitles.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int
    {
        return 0
    }
    
    
}

