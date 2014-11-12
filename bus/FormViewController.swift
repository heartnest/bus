//
//  FormViewController.swift
//  bus
//
//  Created by HeartNest on 12/11/14.
//  Copyright (c) 2014 asscubo. All rights reserved.
//

import UIKit

class FormViewController: SlashViewController, UITextFieldDelegate {

  
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var numStop: UITextField!
    @IBOutlet weak var numBus: UITextField!
    @IBOutlet  var feedPan: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.numStop.delegate = self;
        self.numBus.delegate = self;
    
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        tapRecognizer.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tapRecognizer)
        
        self.spinner.hidden = true
        
        loadLastSearch();
    }
    
    
    func handleSingleTap(recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }


    @IBAction func query(sender: UIButton) {
        self.numStop.resignFirstResponder()
        self.numBus.resignFirstResponder()
        performQuery()
        
        
        
    }
    
    func performQuery(){
        
        self.spinner.hidden = false
        self.spinner.startAnimating();
        
        let ns = self.numStop.text;
        let nb = self.numBus.text;
        
        updateSearchLog("\(ns),\(nb)")
        
        var url: NSURL = NSURL(string: "https://solweb.tper.it/tperit/webservices/hellobus.asmx/QueryHellobus?fermata=\(ns)&linea=\(nb)&oraHHMM=")!
        var request1: NSURLRequest = NSURLRequest(URL: url)
        let queue:NSOperationQueue = NSOperationQueue()
        
        NSURLConnection.sendAsynchronousRequest(request1, queue: queue, completionHandler:{ (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            
            var err: NSError
            
            if(data != nil){
                let xmlArrival = NSString(data: data, encoding: NSUTF8StringEncoding)
                let xmlNSArrival: String = xmlArrival!
                
                
                var notagArrival = xmlNSArrival.stringByReplacingOccurrencesOfString("</string>", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                
                notagArrival = notagArrival.stringByReplacingOccurrencesOfString(", ", withString: "\n", options: NSStringCompareOptions.LiteralSearch, range: nil)
                
                
                let splittedcombi = notagArrival.componentsSeparatedByString("TperHellobus: ")
                var resStr:String;
                
                if(splittedcombi.count == 2){
                    let splitted = splittedcombi[1].componentsSeparatedByString(", ")
                    resStr = splittedcombi[1];
                }else{
                    resStr = splittedcombi[0];
                }
                
                dispatch_async (dispatch_get_main_queue (), {
                    
                    var attrs = [NSFontAttributeName : UIFont.systemFontOfSize(24.0)]
                    var gString = NSMutableAttributedString(string:resStr, attributes:attrs)
                    self.feedPan.attributedText = gString
                    self.spinner.hidden = true
                    self.spinner.stopAnimating();
                    
                });
            }else{
                dispatch_async (dispatch_get_main_queue (), {
                    
                    var attrs = [NSFontAttributeName : UIFont.systemFontOfSize(24.0)]
                    var gString = NSMutableAttributedString(string:"A connection problem occured ..", attributes:attrs)
                    self.feedPan.attributedText = gString
                    self.spinner.hidden = true
                    self.spinner.stopAnimating();
                    
                });
            }
        })
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        textField.resignFirstResponder()
        return true;
    }
    

    
    func loadLastSearch(){
        if(NSUserDefaults().objectForKey(LASTSKEY) != nil){
            let lastsearch = NSUserDefaults().objectForKey(LASTSKEY) as String;
            let splitted = lastsearch.componentsSeparatedByString(",")
            self.numStop.text = splitted[0];
            self.numBus.text = splitted[1];
        }
    }

}
