//
//  PresetAppearanceConfigs.swift
//  Tabman-Example
//
//  Created by Merrick Sapsford on 10/03/2017.
//  Copyright © 2018 UI At Six. All rights reserved.
//

import Foundation
import Tabman

class PresetAppearanceConfigs: Any {
    
    static func forStyle(_ style: TabmanBar.Style, currentAppearance: TabmanBar.Appearance?) -> TabmanBar.Appearance? {
        let appearance = currentAppearance ?? TabmanBar.Appearance.defaultAppearance
        
        appearance.style.background = .solid(color: Color.mediumGreen)
        
        appearance.state.selectedColor = UIColor.white
        appearance.state.color = UIColor.white.withAlphaComponent(0.3)
        appearance.indicator.color = UIColor.white
        
        appearance.indicator.bounces = true
        appearance.indicator.lineWeight = .normal
        appearance.layout.itemDistribution = .centered
        
        appearance.text.font = UIFont.systemFont(ofSize: 16.0, weight: .regular)
        
        return appearance
    }
}
