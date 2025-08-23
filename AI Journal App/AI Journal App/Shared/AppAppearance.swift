//
//  AppAppearance.swift
//  AI Journal App
//
//  Centralizes app-wide UIKit appearance configuration for bars.
//

import SwiftUI

struct AppAppearance {
    static func configure() {
        let tab = UITabBarAppearance()
        tab.configureWithDefaultBackground()
        tab.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        UITabBar.appearance().standardAppearance = tab
        UITabBar.appearance().scrollEdgeAppearance = tab
        
        let nav = UINavigationBarAppearance()
        nav.configureWithDefaultBackground()
        nav.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        UINavigationBar.appearance().standardAppearance = nav
        UINavigationBar.appearance().scrollEdgeAppearance = nav
        
        UITabBar.appearance().tintColor = UIColor(named: "Coral") ?? .systemOrange
        UITabBar.appearance().unselectedItemTintColor = UIColor.label.withAlphaComponent(0.7)
    }
}
