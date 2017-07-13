//
//  Bubble.swift
//  ComicsParser
//
//  Created by Anthony Cooper on 7/13/17.
//  Copyright © 2017 Anthony Cooper. All rights reserved.
//

import Cocoa

class Bubble: NSObject, NSCoding {
    
    let contents: String
    var origin = NSPoint(x: 0, y: 0)
    var size = NSSize(width: 0, height: 0)
    
    override var description: String {
        return "\(origin), \(size)"
    }
    
    required init?(coder decoder: NSCoder) {
        
        self.contents = decoder.decodeObject(forKey: "CPBubbleContents") as! String
        self.origin = decoder.decodePoint(forKey: "CPBubbleOrigin")
        self.size = decoder.decodeSize(forKey: "CPBubbleSize")
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(contents, forKey: "CPBubbleContents")
        coder.encode(origin, forKey: "CPBubbleOrigin")
        coder.encode(size, forKey: "CPBubbleSize")
    }
    
    init(string: String) {
        self.contents = string
        super.init()
    }
}
