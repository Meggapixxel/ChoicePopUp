//
//  P_ChoiceItem.swift
//  
//
//  Created by Vadim Zhydenko on 18.10.2019.
//

import Foundation

public protocol P_ChoiceItem {
    
    var choiceItemDisplayValue: String { get }
    var isChoiceItemSelected: Bool { get set }
    
}
