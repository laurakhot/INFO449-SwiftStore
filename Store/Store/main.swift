//
//  main.swift
//  Store
//
//  Created by Ted Neward on 2/29/24.
//

import Foundation

protocol SKU {
    var name: String {get set}
    func price() -> Int
}

class Item: SKU {
    var name: String
    var priceEach: Int
    
    init(name: String, priceEach: Int) {
        self.name = name
        self.priceEach = priceEach
    }
    
    func price() -> Int {
        return self.priceEach
    }
    
    func applyDiscount(_ discount: Double) -> Void {
        self.name += " (Discounted)"
        self.priceEach = Int((Double(self.priceEach) * (1.0 - discount)).rounded())
    }
}

class Receipt {
    var allItems: [SKU] = []
    
    func items() -> [SKU] {
        return self.allItems
    }
    
    func output() -> String {
        var str = "Receipt:\n"
        for item in self.items() {
            str.append("\(item.name): $\(String(format: "%.2f", Double(item.price()) / 100.0))\n")
        }
        str.append("------------------\n")
        str.append("TOTAL: $\(String(format: "%.2f", Double(self.total()) / 100.0))")
        return str
    }
    
    func total() -> Int {
        var total = 0
        for item in self.items() {
            total += item.price()
        }
        return total
    }
}

class Register {
    var receipt: Receipt
    var coupons: [Coupon] = []
    
    init() {
        self.receipt = Receipt()
    }
    
    func addCoupon(_ coupon: Coupon) -> Void {
        self.coupons.append(coupon)
    }
    
    func scan(_ item: SKU) -> Void {
        for coupon in coupons {
            if item.name.contains(coupon.itemType) && !coupon.applied {
                coupon.applyCoupon(item as! Item)
            }
        }
        receipt.allItems.append(item)
        
    }
    
    func subtotal() -> Int {
        return receipt.total()
    }
    
    func total() -> Receipt {
        let finalReceipt = self.receipt
        self.receipt = Receipt()
        return finalReceipt
    }
}

class Coupon {
    var itemType: String
    var discount: Double = 0.15
    var applied: Bool = false
    
    init(appliedTo: String) {
        self.itemType = appliedTo
    }
    
    func applyCoupon(_ item: Item) -> Void {
        item.applyDiscount(self.discount)
        self.applied = true
    }
}

class Store {
    let version = "0.1"
    func helloWorld() -> String {
        return "Hello world"
    }
}

