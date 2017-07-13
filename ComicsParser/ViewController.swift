//
//  ViewController.swift
//  ComicsParser
//
//  Created by Anthony Cooper on 7/11/17.
//  Copyright © 2017 Anthony Cooper. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    var comic = Comic()
//    var panelsArray = [Panel]()
    
    let gutter: CGFloat = 25.0
    let dimension: CGFloat = 600.0 // This could be derived, or user modified, later, maybe?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let scrollView = self.view as! NSScrollView
        let origin = CGPoint(x: 0, y: 0)
        let viewRect = NSRect(origin: origin, size: comic.size)
        scrollView.documentView = NSView(frame: viewRect)
        
        let centerline = NSLayoutGuide()
        scrollView.addLayoutGuide(centerline)
        scrollView.centerYAnchor.constraint(equalTo: centerline.centerYAnchor).isActive = true
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    func insertImage(_ sender: Any) {
        let openPanel = NSOpenPanel()
        openPanel.canChooseDirectories = false
        openPanel.canChooseFiles = true
        openPanel.allowsMultipleSelection = false // will be true later
        openPanel.allowedFileTypes = ["jpg","png"]
        
        openPanel.begin(completionHandler: {(x) -> Void in
            if x == NSFileHandlingPanelOKButton {
                let imageUrl = openPanel.urls[0]
                self.insertImage(path: imageUrl)
            }
        })
    }

    func insertImage(path: URL) {
        if NSImage(contentsOf: path) != nil {
            let scrollView = self.view as! NSScrollView
            let comicView = scrollView.documentView
            
            var comicHeight = comic.size.height
            if (comicHeight == 0) {
                comicHeight = self.gutter // To account for that spare gutter.
            }
            comicHeight = comicHeight + self.dimension + self.gutter
            comic.size.height = comicHeight
            
            let newComicSize = NSSize(width: self.comic.size.width, height: comicHeight)
            debugPrint("Comic page size: " + newComicSize.debugDescription)
            comicView?.setFrameSize(newComicSize)
            
            for panel in self.comic.panelsArray {
                debugPrint("Panel info: " + panel.debugDescription)
            }
            
            // Move the panels up a slot via the panel model class
            for panel in self.comic.panelsArray {
                let y = panel.origin.y + self.dimension + self.gutter
                panel.origin.y = y
            }
            
            // Execute the move for the visual parts
            let panelViewArray = comicView?.subviews as! [PanelView]
            for panelView in panelViewArray {
                panelView.setFrameOrigin(panelView.panel.origin)
            }
            
            let newPanel = Panel(imagePath: path)
            let lastInsertion = NSPoint(x: 200, y: self.gutter) // Might be this is the one place where I manually inset the panel stream
            newPanel.origin = lastInsertion
            
            let newPanelView = PanelView(panel: newPanel)
            comicView?.addSubview(newPanelView)
            self.comic.panelsArray.append(newPanel)
        }
        else {
            debugPrint("Image load failed at ViewController.insertImage(path: URL)")
        }
    }
    
    // Written for opening a saved file
    func loadComicData() {
        let scrollView = self.view as! NSScrollView
        let comicView = scrollView.documentView
        comicView?.setFrameSize(self.comic.size)
        
        for panel in comic.panelsArray {
            let panelView = PanelView(panel: panel)
            panelView.setFrameOrigin(panel.origin)
            comicView?.addSubview(panelView)
        }
    }
    
}

