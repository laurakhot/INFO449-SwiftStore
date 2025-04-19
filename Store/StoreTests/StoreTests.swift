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
    
    func testDoubleDecimalTotal() {
        register.scan(Item(name: "Soup", priceEach: 1000))
        register.scan(Item(name: "Lollipop", priceEach: 500))
        register.scan(Item(name: "Bread", priceEach: 700))
        XCTAssertEqual(2200, register.subtotal())
        let receipt = register.total()
        XCTAssertEqual(2200, receipt.total())
        let expectedReciept = """
        Receipt:
        Soup: $10.00
        Lollipop: $5.00
        Bread: $7.00
        ------------------
        TOTAL: $22.00
        """
        XCTAssertEqual(expectedReciept, receipt.output())
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
            Kindness :): $0.00
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
            TOTAL: $0.00
            """
        XCTAssertEqual(expectedOutput, receipt.output())
        XCTAssertEqual(0, receipt.total())
    }
    
    func testAddingCouponToNonValidItem() {
        let coupon = Coupon(appliedTo: "Beans")
        register.addCoupon(coupon)
        register.scan(Item(name:"Flowers", priceEach: 1099))
        XCTAssertEqual(1099, register.subtotal())
    }
    
    func testAddingCouponToValidItem() {
        let coupon = Coupon(appliedTo: "Beans")
        register.addCoupon(coupon)
        register.scan(Item(name: "Beans - 8oz Can", priceEach: 600))
        XCTAssertEqual(510, register.subtotal())
        let expectedOutput = """
            Receipt:
            Beans - 8oz Can (Discounted): $5.10
            ------------------
            TOTAL: $5.10
            """
        XCTAssertEqual(expectedOutput, register.total().output())
    }
    
    func testUsingMultipleCoupons() {
        let coupon1 = Coupon(appliedTo: "Fruit")
        let coupon2 = Coupon(appliedTo: "Chocolate")
        register.addCoupon(coupon1)
        register.addCoupon(coupon2)
        register.scan(Item(name: "Eggs", priceEach: 2099))
        XCTAssertEqual(2099, register.subtotal())
        register.scan(Item(name: "Fruit Cereal", priceEach: 800))
        XCTAssertEqual(2779, register.subtotal())
        register.scan(Item(name: "Chocolate Cereal", priceEach: 700))
        XCTAssertEqual(3374, register.subtotal())
        register.scan(Item(name: "Fruit Bar", priceEach: 499))
        XCTAssertEqual(3873, register.subtotal())
        let expected = """
        Receipt:
        Eggs: $20.99
        Fruit Cereal (Discounted): $6.80
        Chocolate Cereal (Discounted): $5.95
        Fruit Bar: $4.99
        ------------------
        TOTAL: $38.73
        """
        XCTAssertEqual(expected, register.total().output())
       
    }
    
    func testDuplicateCouponNotAdded() {
        let coupon = Coupon(appliedTo: "Chocolate")
        register.addCoupon(coupon)
        register.scan(Item(name: "Chocolate Bar", priceEach: 599))
        XCTAssertEqual(509, register.subtotal())
        register.scan(Item(name: "Chocolate Cereal", priceEach: 999))
        XCTAssertEqual(1508, register.subtotal())
        register.scan(Item(name: "Chocolate", priceEach: 499))
        XCTAssertEqual(2007, register.subtotal())
        let receipt = register.total()
        let expected = """
            Receipt:
            Chocolate Bar (Discounted): $5.09
            Chocolate Cereal: $9.99
            Chocolate: $4.99
            ------------------
            TOTAL: $20.07
            """
        XCTAssertEqual(expected, receipt.output())
    }
    
    
}
