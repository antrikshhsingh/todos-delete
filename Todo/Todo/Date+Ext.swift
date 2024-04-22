//
//  Date+Ext.swift
//  Todo
//
//  Created by Antriksh Singh on 19/04/24.
//
import Foundation

extension Date {
    func getCurrentDateAsString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM DD,YYYY"
        formatter.dateStyle = .medium
        return formatter.string(from: self)
    }
}




