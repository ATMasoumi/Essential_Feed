//
//  UITableView+Dequeueing.swift
//  Essential_FeediOS
//
//  Created by Amin on 6/18/1401 AP.
//

import UIKit


extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>() -> T {
        let identifier = String(describing: T.self)
        return dequeueReusableCell(withIdentifier: identifier) as! T
    }
}
