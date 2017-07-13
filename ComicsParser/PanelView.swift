//
//  PanelView.swift
//  ComicsParser
//
//  Created by Anthony Cooper on 7/11/17.
//  Copyright © 2017 Anthony Cooper. All rights reserved.
//

import Cocoa

class PanelView: NSImageView, NSDraggingSource, NSPasteboardItemDataProvider {

    let panel: Panel
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(panel: Panel) {
        self.panel = panel
        let rect = NSRect(origin: panel.origin, size: panel.size)
        super.init(frame: rect)
        
        self.image = panel.image
        self.register(forDraggedTypes: [NSPasteboardTypeString])
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
    override func keyDown(with event: NSEvent) {
        debugPrint("Key down event: " + event.debugDescription)
        self.interpretKeyEvents([event])
    }
    
    override func deleteBackward(_ sender: Any?) {
        debugPrint("deleteBackward triggers")
        let comicView = self.superview as! ComicView
        comicView.viewController.deletePanel(panel: self.panel)
    }
    
    // Mouse stuff
    
    override func mouseDown(with event: NSEvent) {
        self.window?.makeFirstResponder(self)
    }
    
    override func mouseDragged(with event: NSEvent) {
        let pasteboardItem = NSPasteboardItem()
        pasteboardItem.setDataProvider(self, forTypes: [NSPasteboardTypeTIFF])
        let dragItem = NSDraggingItem(pasteboardWriter: pasteboardItem)
        
        let dragPoint = self.convert(event.locationInWindow, from: nil)
        let dragRect = NSRect(x: dragPoint.x, y: dragPoint.y, width: (self.bounds.size.width * 0.25), height: (self.bounds.size.height * 0.25))
        dragItem.setDraggingFrame(dragRect, contents: self.image)
        
        let draggingSession = self.beginDraggingSession(with: [dragItem], event: event, source: self)
        draggingSession.draggingFormation = NSDraggingFormation.none
    }
    
    // PasteboardItemDataProvider methods
    
    func pasteboard(_ pasteboard: NSPasteboard?, item: NSPasteboardItem, provideDataForType type: String) {
        if (type.compare(NSPasteboardTypeTIFF) == ComparisonResult.orderedSame) {
            pasteboard?.setData(self.image?.tiffRepresentation, forType: NSPasteboardTypeTIFF)
        }
    }
    
    // Dragging Source methods
    
    func draggingSession(_ session: NSDraggingSession, sourceOperationMaskFor context: NSDraggingContext) -> NSDragOperation {
        return NSDragOperation.every
    }
    
    func draggingSession(_ session: NSDraggingSession, willBeginAt screenPoint: NSPoint) {
        
    }
    
    // Dragging destination methods
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        let dragOp = sender.draggingSourceOperationMask()
        return dragOp
    }
    
    override func prepareForDragOperation(_ sender: NSDraggingInfo) -> Bool {
        if sender.draggingSource() is NSImageView {
            return NSImage.canInit(with: sender.draggingPasteboard())
        }
        else {
            return true
        }
    }
    
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        if sender.draggingSource() is NSImageView {
            let destinationPoint = sender.draggingLocation()
            let comicsView = self.superview as! ComicView
            let panelPoint = self.convert(destinationPoint, from: nil)
            let comicsPoint = self.convert(panelPoint, to: comicsView)
            
            let sourcePanelView = sender.draggingSource() as! PanelView
            comicsView.viewController.insertPanel(source: sourcePanelView.frame.origin, destination: comicsPoint)
        }
        else if sender.draggingSource() is NSTextField {
            let destinationPoint = sender.draggingLocation()
            let panelPoint = self.convert(destinationPoint, from: nil)
            let draggedBubble = sender.draggingSource() as! BubbleView
            draggedBubble.setFrameOrigin(panelPoint)
            draggedBubble.bubble?.origin = panelPoint
            
        }
        else {
            let text = sender.draggingPasteboard().pasteboardItems?[0].string(forType: NSPasteboardTypeString)
            
            let textField = BubbleView(string: text!)
            let bubble = Bubble(string: text!)
            textField.configBubble(with: bubble)
            
            bubble.size = textField.frame.size
            self.panel.bubbleArray.append(bubble)
            
            self.addSubview(textField)
        }
        return true;
    }

}
