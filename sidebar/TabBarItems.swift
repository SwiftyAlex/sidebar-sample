//
//  TabBarItems.swift
//  sidebar
//
//  Created by Alex Logan on 08/12/2020.
//

import Foundation

enum TabBarItem: CaseIterable {
    case listenNow, browse, radio, library, search
    
    var title: String {
        switch self {
        case .listenNow:
            return "Listen Now"
        case .browse:
            return "Browse"
        case .radio:
            return "Radio"
        case .library:
            return "Library"
        case .search:
            return "Search"
        }
    }
    
    var imageName: String {
        switch self {
        case .listenNow:
            return "play.circle.fill"
        case .browse:
            return "square.grid.2x2.fill"
        case .radio:
            return "dot.radiowaves.left.and.right"
        case .library:
            return "music.note.house.fill"
        case .search:
            return "magnifyingglass"
        }
    }
}
