//
//  CustomExclusivityManager.swift
//  PowerDot-Athlete
//
//  Created by d503 on 7/10/16.
//  Copyright © 2016 Polecat. All rights reserved.
//

import Foundation
import Operations

class CustomExclusivityManager {
    
    private let queue = Queue.Initiated.serial("com.CustomExclusivityManager")
    private var operations: [String: [NSOperation]] = [:]
    
    func addOperation(operation: NSOperation, identifier: String) {
        dispatch_sync(queue) {
            self._addOperation(operation, identifier: identifier)
        }
    }
    
    func removeOperation(operation: NSOperation, identifier: String) {
        dispatch_async(queue) {
            self._removeOperation(operation, identifier: identifier)
        }
    }
    
    private func _addOperation(operation: NSOperation, identifier: String) {
        if let op = operation as? Operation {
            op.addObserver(DidFinishObserver { [unowned self] op, _ in
                self.removeOperation(op, identifier: identifier)
                })
        }
        else {
            operation.addCompletionBlock { [unowned self, weak operation] in
                if let op = operation {
                    self.removeOperation(op, identifier: identifier)
                }
            }
        }
        
        var operationsWithThisIdentifier = operations[identifier] ?? []
        
        if let last = operationsWithThisIdentifier.last {
            operation.addDependency(last)
        }
        
        operationsWithThisIdentifier.append(operation)
        
        operations[identifier] = operationsWithThisIdentifier
    }
    
    private func _removeOperation(operation: NSOperation, identifier: String) {
        if let operationsWithThisIdentifier = operations[identifier],
            index = operationsWithThisIdentifier.indexOf(operation) {
            var mutableOperationsWithThisIdentifier = operationsWithThisIdentifier
            mutableOperationsWithThisIdentifier.removeAtIndex(index)
            operations[identifier] = mutableOperationsWithThisIdentifier
        }
    }
    
}