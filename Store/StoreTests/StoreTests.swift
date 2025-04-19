//
//  StoreTests.swift
//  StoreTests
//
//  Created by Ted Neward on 2/29/24.
//

import XCTest

final class StoreTests: XCTestCase {

    var register = Register()

    override func setUpWithError() throws {
        register = Register()
    }

    override func tearDownWithError() throws { }

    func testBaseline() throws {
        XCTAssertEqual("0.1", Store().version)
        XCTAssertEqual("Hello world", Store().helloWorld())
    }
    
    func testOneItem() {
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        XCTAssertEqual(199, register.subtotal())
        
        let receipt = register.total()
        XCTAssertEqual(199, receipt.total())

        let expectedReceipt = """
Receipt:
Beans (8oz Can): $1.99
------------------
TOTAL: $1.99
"""
        XCTAssertEqual(expectedReceipt, receipt.output())
    }
    
    func testThreeSameItems() {
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        XCTAssertEqual(199 * 3, register.subtotal())
    }
    
    func testThreeDifferentItems() {
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        XCTAssertEqual(199, register.subtotal())
        register.scan(Item(name: "Pencil", priceEach: 99))
        XCTAssertEqual(298, register.subtotal())
        register.scan(Item(name: "Granols Bars (Box, 8ct)", priceEach: 499))
        XCTAssertEqual(797, register.subtotal())
        
        let receipt = register.total()
        XCTAssertEqual(797, receipt.total())

        let expectedReceipt = """
Receipt:
Beans (8oz Can): $1.99
Pencil: $0.99
Granols Bars (Box, 8ct): $4.99
------------------
TOTAL: $7.97
"""
        XCTAssertEqual(expectedReceipt, receipt.output())
    }
    
    // my unit tests:
    func testOneItemSubtotal() {
        register.scan(Item(name: "Flowers", priceEach: 1099))
        XCTAssertEqual(1099, register.subtotal())
        let receipt = register.total()
        XCTAssertEqual(1099, receipt.total())
        let expectedReceipt = """
    Receipt:
    Flowers: $10.99
    ------------------
    TOTAL: $10.99
    """
        XCTAssertEqual(expectedReceipt, receipt.output())
    }
    
    func testSubtotalBetweenScans() {
        register.scan(Item(name: "Soap", priceEach: 399))
        register.scan(Item(name: "Soap", priceEach: 399))
        XCTAssertEqual(798, register.subtotal())
        register.scan(Item(name: "Cereal", priceEach: 699))
        XCTAssertEqual(1497, register.subtotal())
        register.scan(Item(name: "Kindness :)", priceEach: 0))
        XCTAssertEqual(1497, register.subtotal())
        let receipt = register.total()
        XCTAssertEqual(1497, receipt.total())
        let expectedReceipt = """
            Receipt:
            Soap: $3.99
            Soap: $3.99
            Cereal: $6.99
            Kindness :): $0.0
            ------------------
            TOTAL: $14.97
            """
        XCTAssertEqual(expectedReceipt, receipt.output())
        
    }
    
    func testEmptyReceiptAfterTotal() {
        register.scan(Item(name: "Strawberries", priceEach: 1099))
        register.scan(Item(name: "Eggs", priceEach: 2099))
        XCTAssertEqual(3198, register.subtotal())
        let receipt = register.total()
        XCTAssertEqual(3198, receipt.total())
        XCTAssertEqual(0, register.subtotal())
    }
    
    func testEmptyReceiptOutput() {
        let receipt = register.total()
        let expectedOutput = """
            Receipt:
            ------------------
            TOTAL: $0.0
            """
        XCTAssertEqual(expectedOutput, receipt.output())
        XCTAssertEqual(0, receipt.total())
    }
    
    
}
