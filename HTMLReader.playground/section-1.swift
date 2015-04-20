// Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"


class HTMLReader {
    
    init () {
        
    }
    
    
    func ScanMenu() -> String
    {
        let url = NSURL(string: "http://www.bates.edu/dining/menu")!
        // Dining menu website html stored in variable: html
        var html = NSString(contentsOfURL: url, encoding: NSUTF8StringEncoding, error: nil)!
        var trimmedString:NSString?
        // Declare NSScanner object and give it html string
        var htmlScanner = NSScanner(string: html)
        // Look for <footer> in the html code and create string upto that point
        htmlScanner.scanUpToString("<footer>", intoString: &trimmedString)
        
        return trimmedString!
    }
}


var reader = HTMLReader()


reader.ScanMenu()
