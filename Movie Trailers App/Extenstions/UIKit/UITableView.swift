//
//  UITableView.swift
//  Interacting Technology Test
//
//  Created by Ziv Nergal on 23/06/2021.
//

import UIKit

extension UITableView {
    
    public func register<T: UITableViewCell>(cellType: T.Type, bundle: Bundle? = nil) {
        let className = cellType.className
        let nib = UINib(nibName: className, bundle: bundle)
        register(nib, forCellReuseIdentifier: className)
    }

    public func register<T: UITableViewCell>(cellTypes: [T.Type], bundle: Bundle? = nil) {
        cellTypes.forEach { register(cellType: $0, bundle: bundle) }
    }

    public func dequeueReusableCell<T: UITableViewCell>(with type: T.Type, for indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withIdentifier: type.className, for: indexPath) as! T
    }
    
    public func reloadDataWithAnimation(animation: RowAnimation = .automatic) {
        
        if numberOfSections > 1 {
            reloadData()
        }
        
        let range = NSMakeRange(0, numberOfSections)
        let sections = NSIndexSet(indexesIn: range)
        reloadSections(sections as IndexSet, with: animation)
    }
    
    public func tableViewHeaderSizeToFit() {
        
        guard let headerView = tableHeaderView else { return }
        
        let size = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        
        if headerView.frame.size.height != size.height {
            headerView.frame.size.height = size.height
            tableHeaderView = headerView
            layoutIfNeeded()
        }
    }
}

