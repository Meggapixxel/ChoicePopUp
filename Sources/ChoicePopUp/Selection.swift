//
//  File.swift
//  
//
//  Created by Vadim Zhydenko on 18.10.2019.
//

import Foundation

public enum Selection<T> {
    
    case single((T?) -> ())
    case multiple(([T]) -> ())
    
}
