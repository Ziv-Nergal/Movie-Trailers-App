//
//  Observer.swift
//  MishlohaDeliveryApp
//
//  Created by Ziv Nergal on 21/06/2021.
//  Copyright © 2020 Mishloha. All rights reserved.
//

import UIKit

protocol Observer {
    var id : String { get }
    func update<T>(with newValue: T)
    func update<T>(with newValue: T, oldValue: T)
}

extension Observer {
    func update<T>(with newValue: T, oldValue: T) {}
}
