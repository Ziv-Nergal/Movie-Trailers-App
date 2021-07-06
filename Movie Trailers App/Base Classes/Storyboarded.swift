//
//  Storyboarded.swift
//  Interacting Technology Test
//
//  Created by Ziv Nergal on 25/06/2021.
//

import UIKit

protocol Storyboarded {
    static func instantiate(storyboardName: K.StoryBoards) -> Self
}

extension Storyboarded where Self: UIViewController {
    
    static func instantiate(storyboardName: K.StoryBoards = .main) -> Self {
        let id = String(describing: self)
        let storyboard = UIStoryboard(name: storyboardName.rawValue, bundle: Bundle.main)
        return storyboard.instantiateViewController(identifier: id) as! Self
    }
}
