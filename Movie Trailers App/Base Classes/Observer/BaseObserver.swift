//
//  BaseObserver.swift
//  MishlohaDeliveryApp
//
//  Created by Ziv Nergal on 21/06/2021.
//  Copyright © 2020 Mishloha. All rights reserved.
//

import Foundation

class BaseObserver<Z>: Observer {
    
    private let ignoreFirstUpdate: Bool
    
    private var identifier = UUID().uuidString
    private var updateCount: Int = 0
    private var callback: ((Z)->())?
    private var callbackWithOldvalue: ((Z, Z)->())?
    
    // MARK: - Initiation
    
    init(onValueChanged callback: @escaping ((Z)->()), ignoreFirstUpdate: Bool = false) {
        self.callback = callback
        self.ignoreFirstUpdate = ignoreFirstUpdate
    }
    
    init(onValueChanged callback: @escaping ((Z, Z)->()), ignoreFirstUpdate: Bool = false) {
        self.callbackWithOldvalue = callback
        self.ignoreFirstUpdate = ignoreFirstUpdate
    }
    
    // MARK: - Observer Protocol
    
    var id: String {
        return identifier
    }
    
    func update<T>(with newValue: T) {
        
        if !ignoreFirstUpdate || updateCount != 0 {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.callback?(newValue as! Z)
            }
        }
        
        updateCount += 1
    }
    
    func update<T>(with newValue: T, oldValue: T) {
        
        if !ignoreFirstUpdate || updateCount != 0 {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.callbackWithOldvalue?(newValue as! Z, oldValue as! Z)
            }
        }
        
        updateCount += 1
    }
}
