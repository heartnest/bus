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
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var addrLabel: UILabel!
    var addr:NSDictionary!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //components configurations
        self.numStop.delegate = self;
        self.numBus.delegate = self;
        self.numStop.placeholder = "Stop number"
        self.numBus.placeholder = "Bus number"
        
        makeTextFieldBorder(self.numStop)
        makeTextFieldBorder(self.numBus)
        
        self.searchButton.layer.borderWidth = 1.5
        self.searchButton.layer.borderColor = (UIColor( red: 163/255, green: 162/255, blue:159/255, alpha: 1.0 )).CGColor;
        self.searchButton.layer.cornerRadius = 19;
        self.searchButton.clipsToBounds = true;
        
        self.spinner.hidden = true
        
        //gesture recognizers
        let tapRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        tapRecognizer.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tapRecognizer)
        
        //radio center
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadLastSearch", name: NSUserDefaultsDidChangeNotification, object: nil)
        
        
        loadAddresses();
        loadLastSearch();

    }
    
    func loadAddresses(){
        
        let path = NSBundle.mainBundle().pathForResource("data", ofType: "json")
        let jsonData = NSData(contentsOfFile:path!)
        self.addr = NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary

    }
    
    func loadLastSearch(){
        if(NSUserDefaults().objectForKey(LASTSKEY) != nil){
            let lastsearch = NSUserDefaults().objectForKey(LASTSKEY) as String;

            let splitted = lastsearch.componentsSeparatedByString(",")
            if(splitted.count == 2){
                self.numStop.text = splitted[0];
                self.numBus.text = splitted[1];
                loadAddrByStopNum(splitted[0])
            }else if(splitted.count == 3){
                self.numStop.text = splitted[0];
                self.numBus.text = splitted[1];
                self.addrLabel.text = splitted[2];
            }
        }
    }
    
    
    func loadAddrByStopNum(t:String){
        if(self.addr["k\(t)"] != nil){
            let denomination: String = self.addr["k\(t)"]! as String
            self.addrLabel.text = denomination;
        }else{
            self.addrLabel.text = "";
        }
    }

    //editing
    @IBAction func inserting(sender: UITextField) {
        let t = sender.text;
        loadAddrByStopNum(t)
    }

    //query button
    @IBAction func query(sender: UIButton) {
        self.numStop.resignFirstResponder()
        self.numBus.resignFirstResponder()
        performQuery()
        
    }
    
    //show result
    func performQuery(){
        
        self.feedPan.attributedText = NSMutableAttributedString(string:"", attributes:nil)
        
        self.spinner.hidden = false
        self.spinner.startAnimating();
        
        let ns = self.numStop.text;
        let nb = self.numBus.text;
        let al = self.addr["k\(ns)"]! as String
        
        
        //updateSearchLog("\(ns),\(nb)")
        updateSearchLog("\(ns),\(nb),\(al)")
        
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
                    //successfull
                    let splitted = splittedcombi[1].componentsSeparatedByString(", ")
                    resStr = splittedcombi[1];
                }else{
                    //help
                    let splittedcombi2 = notagArrival.componentsSeparatedByString("HellobusHelp: ")
                    if(splittedcombi2.count == 2){
                        resStr = splittedcombi2[1];
                    }else{
                        resStr = splittedcombi[0];
                    }
                    
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
    
    //default single tap outside
    func handleSingleTap(recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }

    
    // called when 'return' key pressed. return NO to ignore.
    func textFieldShouldReturn(textField: UITextField!) -> Bool
    {
        textField.resignFirstResponder()
        return true;
    }
    
    
    func makeTextFieldBorder(textField:UITextField){
        var border = CALayer()
        var width = CGFloat(1.0)
        //border.borderColor = UIColor.grayColor().CGColor
        border.borderColor = (UIColor( red: 170/255, green: 170/255, blue:172/255, alpha: 1.0 )).CGColor;
        border.frame = CGRect(x: 0, y: textField.frame.size.height - width, width:  textField.frame.size.width, height: textField.frame.size.height)
        
        border.borderWidth = width
        textField.layer.addSublayer(border)
        textField.layer.masksToBounds = true
    }

}
