//
//  Panel.swift
//  ComicsParser
//
//  Created by Anthony Cooper on 7/11/17.
//  Copyright © 2017 Anthony Cooper. All rights reserved.
//

import Cocoa

class Panel: NSObject {
    
    let imageUrl: URL
    var image: NSImage? = nil
    var size: NSSize = NSSize(width: 0, height: 0)
    
    var origin = NSPoint(x: 0, y: 0)

    override var description: String {
        return "\(imageUrl) \(origin)"
    }
    
    init(imagePath: URL) {
        self.imageUrl = imagePath
        
        if let image = NSImage(contentsOf: imagePath) {
            self.image = image
            
            let size = NSSize(width: (self.image?.size.width)!, height: (self.image?.size.height)!)
            self.size = size
        }
        super.init()
    }
}
