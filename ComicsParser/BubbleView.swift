//
//  BubbleView.swift
//  ComicsParser
//
//  Created by Anthony Cooper on 7/13/17.
//  Copyright © 2017 Anthony Cooper. All rights reserved.
//

import Cocoa

class BubbleView: NSTextField, NSDraggingSource, NSPasteboardItemDataProvider  {
    var bubble: Bubble? // Wanted to put in custom init, but NSTextField itself is nothing but convienence methods ;)
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        // Drawing code here.
    }
    
    func configBubble(with: Bubble) {
        self.bubble = with
        self.isEditable = false
        self.isSelectable = false
    }
    
    override func mouseDragged(with event: NSEvent) {
        let pasteboardItem = NSPasteboardItem()
        pasteboardItem.setDataProvider(self, forTypes: [NSPasteboardTypeString])
        let dragItem = NSDraggingItem(pasteboardWriter: pasteboardItem)
        
        let dragPoint = self.convert(event.locationInWindow, from: nil)
        let dragRect = NSRect(x: dragPoint.x, y: dragPoint.y, width: self.bounds.size.width, height: self.bounds.size.height)
        dragItem.setDraggingFrame(dragRect, contents: drawSelectionRectangle())
        
        let draggingSession = self.beginDraggingSession(with: [dragItem], event: event, source: self)
        draggingSession.draggingFormation = NSDraggingFormation.none
    }
    
    // PasteboardItemDataProvider methods
    func pasteboard(_ pasteboard: NSPasteboard?, item: NSPasteboardItem, provideDataForType type: String) {
        if (type.compare(NSPasteboardTypeString) == ComparisonResult.orderedSame) {
            pasteboard?.setData(self.stringValue.data(using: String.Encoding.unicode), forType: NSPasteboardTypeString)
        }
    }
    
    // Dragging session protocol
    func draggingSession(_ session: NSDraggingSession, sourceOperationMaskFor context: NSDraggingContext) -> NSDragOperation {
        return NSDragOperation.move
    }
    
    // This is off size when the comics view is zoomed
    func drawSelectionRectangle() -> NSImage {
        let identitySize = NSSize(width: 1.0, height: 1.0)
        let currentScaleSize = self.convert(identitySize, to: nil)
        
        let dashedRectangle = NSImage(size: NSMakeSize(self.bounds.width, self.bounds.height))
        dashedRectangle.lockFocus()
        
        let pathRect = NSMakeRect(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width * currentScaleSize.width, self.bounds.size.height * currentScaleSize.height)
        let bezierPath = NSBezierPath(rect: pathRect)
        bezierPath.lineWidth = 3.0
        let pattern = [CGFloat(5),CGFloat(3)]
        bezierPath.setLineDash(pattern, count: 2, phase: 0.0)
        bezierPath.stroke()
        
        dashedRectangle.unlockFocus()
        return dashedRectangle
    }
}
