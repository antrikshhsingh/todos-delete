//
//  String+Ext.swift
//  Todo
//
//  Created by Antriksh Singh on 19/04/24.
//

import Foundation


extension String{
    func toDate() -> Date {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM DD,YYYY"
            formatter.dateStyle = .medium
        return formatter.date(from: self) ?? Date()
        }
}
