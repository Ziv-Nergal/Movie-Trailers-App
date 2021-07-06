//
//  String.swift
//  Interacting Technology Test
//
//  Created by Ziv Nergal on 25/06/2021.
//

import Foundation

extension String {
    
    func formatDate(originFormat: K.DateFormats, destinationFormat: K.DateFormats) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = originFormat.rawValue
        let date = formatter.date(from: self) ?? Date()
        formatter.dateFormat = destinationFormat.rawValue
        return formatter.string(from: date)
    }
}
