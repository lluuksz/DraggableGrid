//
//  DraggableGridUITests.swift
//  DraggableGridUITests
//
//  Created by lluuksz on 25/03/2024.
//

import XCTest

final class DraggableGridUITests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        XCUIDevice.shared.orientation = .portrait
    }
    
    func testShould_MoveFromZeroToFifthPlace() {
        let app = XCUIApplication()
        app.launch()
        
        var element0 = app.otherElements["DraggableGridDraggableElement0"]
        var element1 = app.otherElements["DraggableGridDraggableElement1"]
        var element2 = app.otherElements["DraggableGridDraggableElement2"]
        var element3 = app.otherElements["DraggableGridDraggableElement3"]
        var element4 = app.otherElements["DraggableGridDraggableElement4"]
        var element5 = app.otherElements["DraggableGridDraggableElement5"]
        var element6 = app.otherElements["DraggableGridDraggableElement6"]
        
        let element0Label = element0.label
        let element1Label = element1.label
        let element2Label = element2.label
        let element3Label = element3.label
        let element4Label = element4.label
        let element5Label = element5.label
        let element6Label = element6.label
        
        element0.press(forDuration: 1, thenDragTo: element5)
        
        element0 = app.otherElements["DraggableGridDraggableElement0"]
        element1 = app.otherElements["DraggableGridDraggableElement1"]
        element2 = app.otherElements["DraggableGridDraggableElement2"]
        element3 = app.otherElements["DraggableGridDraggableElement3"]
        element4 = app.otherElements["DraggableGridDraggableElement4"]
        element5 = app.otherElements["DraggableGridDraggableElement5"]
        element6 = app.otherElements["DraggableGridDraggableElement6"]
        
        XCTAssertEqual(element0.label, element1Label)
        XCTAssertEqual(element1.label, element2Label)
        XCTAssertEqual(element2.label, element3Label)
        XCTAssertEqual(element3.label, element4Label)
        XCTAssertEqual(element4.label, element5Label)
        XCTAssertEqual(element5.label, element0Label)
        XCTAssertEqual(element6.label, element6Label)
    }
    
}
