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
    
    let gutter: CGFloat = 25.0
    let dimension: CGFloat = 600.0 // This could be derived, or user modified, later, maybe?
    let lefthandInset: CGFloat = 200.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let scrollView = self.view as! NSScrollView
        let origin = CGPoint(x: 0, y: 0)
        let viewRect = NSRect(origin: origin, size: comic.size)
        scrollView.documentView = ComicView(vc: self, frame: viewRect)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    func appendImage(_ sender: Any) {
        let openPanel = NSOpenPanel()
        openPanel.canChooseDirectories = false
        openPanel.canChooseFiles = true
        openPanel.allowsMultipleSelection = false // will be true later
        openPanel.allowedFileTypes = ["jpg","png"]
        
        openPanel.begin(completionHandler: {(x) -> Void in
            if x == NSFileHandlingPanelOKButton {
                let imageUrl = openPanel.urls[0]
                self.appendImage(path: imageUrl)
            }
        })
    }

    func appendImage(path: URL) {
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
            let lastInsertion = NSPoint(x: lefthandInset, y: self.gutter) // Might be this is the one place where I manually inset the panel stream
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
            
            for bubble in panel.bubbleArray {
                let bubbleView = BubbleView(string: bubble.contents)
                bubbleView.configBubble(with: bubble)
                bubbleView.setFrameOrigin(bubble.origin)
                panelView.addSubview(bubbleView)
            }
            
            comicView?.addSubview(panelView)
        }
    }
    
    // This may need a serious rework later. Seems to work reliably though, so maybe not.
    func insertPanel(source: NSPoint, destination: NSPoint) {
        // For determining the comicsView scale
        let scrollView = self.view as! NSScrollView
        let comicView = scrollView.documentView as! ComicView
        let identitySize = NSSize(width: 1.0, height: 1.0)
        let currentScaleSize = self.view.convert(identitySize, from: comicView)
        
        let scaledSourcePoint = NSPoint(x: source.x * currentScaleSize.width, y: source.y * currentScaleSize.height)
        let scaledDestinationPoint = NSPoint(x: destination.x * currentScaleSize.width, y: destination.y * currentScaleSize.height)
        let scaledPanelAndGutter = CGFloat(self.dimension + self.gutter) * currentScaleSize.height
        
        // Calculate indexs from bottom up
        let sourceIndex = Int(scaledSourcePoint.y / scaledPanelAndGutter)
        let destinationIndex = scaledDestinationPoint.y / scaledPanelAndGutter
        let destinationInt = Int(destinationIndex)
        let destinationRemainder = destinationIndex.truncatingRemainder(dividingBy: 1.0)
        
        // Index locations have to be reversed due to how panel source and destination are calculated
        let reversedSourceIndex = self.comic.panelsArray.count - sourceIndex
        let reversedDestinationIndex = self.comic.panelsArray.count - destinationInt
        
        // Start executing move in master array.
        let holdingPanel = self.comic.panelsArray[reversedSourceIndex - 1]
        self.comic.panelsArray.remove(at: reversedSourceIndex - 1)
        
        //Determine direction of move, and then execute depending on threshold.
        let threshold = (((self.dimension / 2) + gutter) / (self.dimension + gutter))
        
        // Lower bound fails with panel singleton in document. Currently disabling with check here. Zero because master array has had chosen panel pulled out
        if (self.comic.panelsArray.count == 0) {
            self.comic.panelsArray.append(holdingPanel)
            return
        }
        else if (destinationInt > sourceIndex) {
            if (destinationRemainder > CGFloat(threshold)) {self.comic.panelsArray.insert(holdingPanel, at: reversedDestinationIndex - 1)}
            else {self.comic.panelsArray.insert(holdingPanel, at: reversedDestinationIndex)}
        }
        else {
            // The below bounds check fails with one panel and trying to place itself beneath itself lol
            if (destinationRemainder > CGFloat(threshold)) {self.comic.panelsArray.insert(holdingPanel, at: reversedDestinationIndex - 2)}
            else {self.comic.panelsArray.insert(holdingPanel, at: reversedDestinationIndex - 1)}
        }
        
        // Finally, need to mark new origins for the new arrangement
        // Had trouble moving existing panels, so took the blunt approach of blanket removal, then regen page
        var point = NSPoint(x: self.lefthandInset, y: self.comic.size.height)
        comicView.subviews.removeAll(keepingCapacity: true)
        for panel in self.comic.panelsArray {
            point.y = point.y - self.gutter - self.dimension
            panel.origin = point
        }
        self.loadComicData()
    }
    
    func deletePanel(panel: Panel) {
        for p in comic.panelsArray {
            if (p == panel) {
                let x = comic.panelsArray.index(of: p)
                comic.panelsArray.remove(at: x!)
            }
        }
        
        self.comic.size.height = self.comic.size.height - self.gutter - self.dimension
        var point = NSPoint(x: self.lefthandInset, y: self.comic.size.height)
        
        for panel in self.comic.panelsArray {
            point.y = point.y - self.gutter - self.dimension
            panel.origin = point
        }
        
        let scrollView = self.view as! NSScrollView
        let comicView = scrollView.documentView as! ComicView
        comicView.subviews.removeAll(keepingCapacity: true)
        
        self.loadComicData()
    }

}

