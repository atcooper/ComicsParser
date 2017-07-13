//
//  Panel.swift
//  ComicsParser
//
//  Created by Anthony Cooper on 7/11/17.
//  Copyright © 2017 Anthony Cooper. All rights reserved.
//

import Cocoa

class Panel: NSObject, NSCoding {
    
    let imageUrl: URL
    var image: NSImage? = nil
    var size: NSSize = NSSize(width: 0, height: 0)
    
    var origin = NSPoint(x: 0, y: 0)

    var bubbleArray = [Bubble]()
    
    
    
    required init?(coder decoder: NSCoder) {
        self.imageUrl = decoder.decodeObject(forKey: "CPPanelImageUrl") as! URL
        self.image = decoder.decodeObject(forKey: "CPPanelImage") as? NSImage
        self.size = decoder.decodeSize(forKey: "CPPanelSize")
        self.origin = decoder.decodePoint(forKey: "CPPanelOrigin")
        self.bubbleArray = decoder.decodeObject(forKey: "CPPanelBubbleArray") as! [Bubble]
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(imageUrl, forKey: "CPPanelImageUrl")
        coder.encode(image, forKey: "CPPanelImage")
        coder.encode(size, forKey: "CPPanelSize")
        coder.encode(origin, forKey: "CPPanelOrigin")
        coder.encode(bubbleArray , forKey: "CPPanelBubbleArray")
    }
    
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
