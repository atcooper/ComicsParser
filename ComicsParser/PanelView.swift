//
//  PanelView.swift
//  ComicsParser
//
//  Created by Anthony Cooper on 7/11/17.
//  Copyright © 2017 Anthony Cooper. All rights reserved.
//

import Cocoa

class PanelView: NSImageView {

    let panel: Panel
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(panel: Panel) {
        self.panel = panel
        let rect = NSRect(origin: panel.origin, size: panel.size)
        super.init(frame: rect)
        
        self.image = panel.image
//        self.register(forDraggedTypes: [NSPasteboardTypeString])
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
}
