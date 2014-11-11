//
//  ViewController.swift
//  bus
//
//  Created by HeartNest on 11/11/14.
//  Copyright (c) 2014 asscubo. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    @IBOutlet weak var resLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        
//        var err: NSError
//        var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(dataVal, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
//        println("Synchronous\(jsonResult)")
//        
        
    }
  
    @IBAction func click(sender: AnyObject) {
        println("Button tapped")
        
        
//        var url: NSURL = NSURL(string: "https://solweb.tper.it/tperit/webservices/hellobus.asmx/QueryHellobus?fermata=33&linea=33&oraHHMM=")!
//        let request: NSURLRequest = NSURLRequest(URL: url)
//
//        var response: AutoreleasingUnsafeMutablePointer <NSURLResponse?>=nil
//        
//        var error: AutoreleasingUnsafeMutablePointer <NSErrorPointer?>=nil
//        var dataVal: NSData =  NSURLConnection.sendSynchronousRequest(request, returningResponse: response, error:nil)!
//        
//        //requestUrl("http://www.google.com")
//        //var data:NSData = NSData.contentsWithURL("http://www.google.com");
//        
//        let resstr = NSString(data: dataVal, encoding: NSUTF8StringEncoding)
//        var das = NSString(data: dataVal, encoding: NSUTF8StringEncoding)
//        
//        println("Button tapped2 \(das)")

        
        var url: NSURL = NSURL(string: "https://solweb.tper.it/tperit/webservices/hellobus.asmx/QueryHellobus?fermata=33&linea=33&oraHHMM=")!
        var request1: NSURLRequest = NSURLRequest(URL: url)
        let queue:NSOperationQueue = NSOperationQueue()
        
        NSURLConnection.sendAsynchronousRequest(request1, queue: queue, completionHandler:{ (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            /* Your code */
            
            var err: NSError
            
            var jsonResult = NSString(data: data, encoding: NSUTF8StringEncoding)
            println("AsSynchronous\(jsonResult)")
            
            
        })
    }
    
    func requestUrl(urlString: String){
        var url: NSURL = NSURL(string: urlString)!
        let request: NSURLRequest = NSURLRequest(URL: url)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler:{
            (response, data, error) -> Void in
            
            if (error? != nil) {
                println("hello2")
                //Handle Error here
            }else{
                
                let resstr = NSString(data: data, encoding: NSUTF8StringEncoding)
                println("hello")
                //Handle data in NSData type
            }
            
        })
    }


    
    
}

