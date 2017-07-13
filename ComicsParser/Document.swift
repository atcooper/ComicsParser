//
//  Document.swift
//  ComicsParser
//
//  Created by Anthony Cooper on 7/11/17.
//  Copyright © 2017 Anthony Cooper. All rights reserved.
//

import Cocoa

class Document: NSDocument {

    var comic = Comic()
    
    override init() {
        super.init()
        // Add your subclass-specific initialization here.
    }

    override class func autosavesInPlace() -> Bool {
        return false
    }

    override func makeWindowControllers() {
        // Returns the Storyboard that contains your Document window.
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let windowController = storyboard.instantiateController(withIdentifier: "Document Window Controller") as! NSWindowController
        self.addWindowController(windowController)
        
        let vc = windowController.contentViewController as! ViewController
        vc.comic = self.comic
        vc.loadComicData()
    }

    override func data(ofType typeName: String) throws -> Data {
        // Insert code here to write your document to data of the specified type. If outError != nil, ensure that you create and set an appropriate error when returning nil.
        // You can also choose to override fileWrapperOfType:error:, writeToURL:ofType:error:, or writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
        // If I add undo, unregister it or deactivate it while reading.
        
        let windowController = self.windowControllers[0]
        let viewController = windowController.contentViewController as! ViewController
        
        let data = NSKeyedArchiver.archivedData(withRootObject: viewController.comic)
        return data
        
//        throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
    }

    override func read(from data: Data, ofType typeName: String) throws {
        // Insert code here to read your document from the given data of the specified type. If outError != nil, ensure that you create and set an appropriate error when returning false.
        // You can also choose to override readFromFileWrapper:ofType:error: or readFromURL:ofType:error: instead.
        // If you override either of these, you should also override -isEntireFileLoaded to return false if the contents are lazily loaded.
        
        let comic = NSKeyedUnarchiver.unarchiveObject(with: data) as! Comic
        self.comic = comic
        debugPrint("Done with read")
    }

    override func windowControllerDidLoadNib(_ windowController: NSWindowController) {
        debugPrint("Inside windowControllerDidLoadNib")
        let windowController = self.windowControllers[0]
        let viewController = windowController.contentViewController as! ViewController
        viewController.comic = self.comic
        for panel in self.comic.panelsArray {
            debugPrint("Panel: " + panel.description)
        }
    }
}

