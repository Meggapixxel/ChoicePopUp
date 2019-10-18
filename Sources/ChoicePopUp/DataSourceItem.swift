//
//  File.swift
//  
//
//  Created by Vadim Zhydenko on 18.10.2019.
//

import Foundation

class DataSourceItem {
    
    let uuid = UUID()
    let name: String
    var isSelected: Bool
    
    init(name: String, isSelected: Bool = false) {
        self.name = name
        self.isSelected = isSelected
    }
    
}
