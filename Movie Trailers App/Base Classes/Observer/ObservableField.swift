//
//  ObservableField.swift
//  MishlohaDeliveryApp
//
//  Created by Ziv Nergal on 21/06/2021.
//  Copyright © 2020 Mishloha. All rights reserved.
//

import Foundation

/*
 This protocol is necessary in order to remove all
 observers from observable field using reflection to prevent a retain cycle.
 It is a seperate protocol from Observable because of the associatedtype T in Observable Protocol
 which cannot be used with reflection
 */
protocol ClearObservableProtocol {
    func removeAllObservers()
}

class ObservableField<T: Equatable> : Observable, ClearObservableProtocol {
    
    private var _value : T! = nil
    private var _observers : [Observer] = []
    
    private let allowUpdatesWithSameValue: Bool
    
    init(initialValue: T? = nil, allowUpdatesWithSameValue: Bool = false) {
        _value = initialValue
        self.allowUpdatesWithSameValue = allowUpdatesWithSameValue
    }
    
    var value : T {
        get {
            return self._value
        }
        set {
            if allowUpdatesWithSameValue || newValue != self._value {
                self._value = newValue
                self.notifyAllObservers(with: newValue)
            }
        }
    }
    
    var observers : [Observer] {
        get {
            return self._observers
        }
        set {
            self._observers = newValue
        }
    }
    
    func addObserver(observer observerToAdd: Observer) {
        for observer in observers {
            if observerToAdd.id == observer.id {
                return
            }
        }
        observers.append(observerToAdd)
        if _value != nil {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                observerToAdd.update(with: self._value)
            }
        }
    }
    
    func removeObserver(observer: Observer) {
        observers = observers.filter({$0.id != observer.id})
    }
    
    func removeAllObservers() {
        observers.removeAll()
    }
    
    func notifyAllObservers<T>(with newValue: T) {
        
        for observer in observers {
            
            if observer is LoadableObserver && newValue is LoadingState {
                
                let state = newValue as! LoadingState
                
                if state == .Loading {
                    (observer as! Loadable).showLoader()
                } else {
                    (observer as! Loadable).hideLoader()
                }
            } else {
                DispatchQueue.main.async {
                    observer.update(with: newValue)
                }
            }
        }
    }
}
