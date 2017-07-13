//
//  Comic.swift
//  ComicsParser
//
//  Created by Anthony Cooper on 7/11/17.
//  Copyright © 2017 Anthony Cooper. All rights reserved.
//

import Cocoa

class Comic: NSObject, NSCoding {
    var size = NSSize(width: 1000, height: 0)
    
//    var panelsCount = 0
    var panelsArray = [Panel]()
    
    required init?(coder decoder: NSCoder) {
        super.init()
        self.size = decoder.decodeSize(forKey: "CPComicSize")
        self.panelsArray = decoder.decodeObject(forKey: "CPComicPanelsArray") as! [Panel]
    }
    
    override init() {
        super.init()
        
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(size, forKey: "CPComicSize")
        coder.encode(panelsArray, forKey: "CPComicPanelsArray")
    }
    
}
