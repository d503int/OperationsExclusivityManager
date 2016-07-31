//
//  UnitTestExclusivityManager.swift
//  PowerDot-Athlete
//
//  Created by d503 on 6/24/16.
//  Copyright © 2016 Polecat. All rights reserved.
//

import Foundation
import Operations

final class UnitTestExclusivityManager {
    
    private let queue = Queue.Initiated.serial("com.unitTests.UnitTestExclusivityManager")
    private var operations: [String: [NSOperation]] = [:]
    
    init() {}
    
    func addOperation(operation: NSOperation, category: String) {
        dispatch_sync(queue) {
            self._addOperation(operation, category: category)
        }
    }
    
    func removeOperation(operation: NSOperation, category: String) {
        dispatch_async(queue) {
            self._removeOperation(operation, category: category)
        }
    }
    
    private func _addOperation(operation: NSOperation, category: String) {
        if let op = operation as? Operation {
            op.addObserver(DidFinishObserver { [unowned self] op, _ in
                self.removeOperation(op, category: category)
                })
        }
        else {
            operation.addCompletionBlock { [unowned self, weak operation] in
                if let op = operation {
                    self.removeOperation(op, category: category)
                }
            }
        }
        
        var operationsWithThisCategory = operations[category] ?? []
        
        if let last = operationsWithThisCategory.last {
            operation.addDependency(last)
        }
        
        operationsWithThisCategory.append(operation)
        
        operations[category] = operationsWithThisCategory
    }
    
    private func _removeOperation(operation: NSOperation, category: String) {
        if var operationsWithThisCategory = operations[category], let index = operationsWithThisCategory.indexOf(operation) {
            operationsWithThisCategory.removeAtIndex(index)
            operations[category] = operationsWithThisCategory
        }
    }
}