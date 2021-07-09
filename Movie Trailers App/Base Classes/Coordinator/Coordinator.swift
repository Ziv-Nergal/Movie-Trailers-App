//
//  Coordinator.swift
//  Interacting Technology Test
//
//  Created by Ziv Nergal on 25/06/2021.
//

import UIKit

protocol Coordinator {
    
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
}
