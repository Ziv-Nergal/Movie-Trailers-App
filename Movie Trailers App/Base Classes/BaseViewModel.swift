//
//  BaseViewModel.swift
//  Interacting Technology Test
//
//  Created by Ziv Nergal on 22/06/2021.
//

import Foundation

protocol SharedViewModel {
    /*This protocol indicates that the view model
    is shared between several view controllers
    and must not be deallocated when destroying
    view models in base view controller viewWillDisappear method*/
}

internal class BaseViewModel {
    
    // MARK: - Observables
    
    let loadingStateObs = ObservableField<LoadingState>(initialValue: .Idle)
    let errorMsgObs = ObservableField<String>(allowUpdatesWithSameValue: true)
    
    // MARK: - Public Variables
    
    public var isLoading: Bool { loadingStateObs.value == .Loading }
    
    deinit {
        print("Deinitialized viewmodel \(self)")
    }
    
    // MARK: - Public Methods
    
    public func clearObservers() {
        
        loadingStateObs.observers.removeAll()
        errorMsgObs.observers.removeAll()
        
        let mirror = Mirror(reflecting: self)
        
        for child in mirror.children {
            
            if let observable = child.value as? ClearObservableProtocol {
                observable.removeAllObservers()
            }
        }
    }
}
