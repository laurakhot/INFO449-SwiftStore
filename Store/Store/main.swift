//
//  main.swift
//  Store
//
//  Created by Ted Neward on 2/29/24.
//

import Foundation

protocol SKU {
    var name: String {get}
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
}

class Receipt {
    var allItems: [SKU] = []
    
    func items() -> [SKU] {
        return self.allItems
    }
    
    func output() -> String {
        var str = "Receipt:\n"
        for item in self.items() {
            str.append("\(item.name): $\(Double(item.price())/100.0)\n")
        }
        str.append("------------------\n")
        str.append("TOTAL: $\(Double(self.total())/100.0)")
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
    
    init() {
        self.receipt = Receipt()
    }
    
    // param: SKU
    // adds SKU to receipt
    func scan(_ item: SKU) -> Void {
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

class Store {
    let version = "0.1"
    func helloWorld() -> String {
        return "Hello world"
    }
}

