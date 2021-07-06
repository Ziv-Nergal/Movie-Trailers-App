//
//  ObservableViewModel.swift
//  MishlohaDeliveryApp
//
//  Created by Ziv Nergal on 21/06/2021.
//  Copyright © 2020 Mishloha. All rights reserved.
//

import Foundation

protocol Observable {
    
    associatedtype T
    
    var value : T { get set }
    var observers : [Observer] { get set }
    
    func addObserver(observer: Observer)
    func removeObserver(observer: Observer)
    func notifyAllObservers<T>(with newValue: T)
}
