//
//  CoreLocationComponentApp.swift
//  CoreLocationComponent
//
//  Created by Christian Aldrich Darrien on 10/07/24.
//

import SwiftUI
import WidgetKit

@main
struct CoreLocationComponentApp: App {
    
    init(){
        WidgetCenter.shared.reloadTimelines(ofKind: "WidgetApp")
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
