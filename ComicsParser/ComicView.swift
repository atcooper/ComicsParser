//
//  ComicView.swift
//  ComicsParser
//
//  Created by Anthony Cooper on 7/12/17.
//  Copyright © 2017 Anthony Cooper. All rights reserved.
//

import Cocoa

class ComicView: NSView {

    let viewController: ViewController
    
    init(vc: ViewController, frame: NSRect) {
        self.viewController = vc
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
}
