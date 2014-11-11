// Playground - noun: a place where people can play

import UIKit

let url = NSURL(string: "http://www.stackoverflow.com")
let request = NSURLRequest(URL: url!)

NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {(response, data, error) in
    println(NSString(data: data, encoding: NSUTF8StringEncoding))
}

let connection = NSURLConnection(request: request, delegate:nil, startImmediately: true)