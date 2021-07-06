//
//  Loadable.swift
//  MishlohaDeliveryApp
//
//  Created by Ziv Nergal on 21/06/2021.
//  Copyright © 2020 Mishloha. All rights reserved.
//

import Foundation

typealias LoadableObserver = Loadable & Observer

enum LoadingState: Int {
    case Idle
    case Loading
}

protocol Loadable {
    func showLoader()
    func hideLoader()
}

extension Observer where Self: LoadableObserver {
    
    func update<T>(with newValue: T) {
        
        // MARK: - Keep Empty
        
        // Loadables get notified with loading state
        // directly from the observableFields and not from the update method.
        // in order of getting notified with other values,
        // you can override update method anyway in the observer class.
    }
}
