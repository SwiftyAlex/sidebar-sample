//
//  FancyList.swift
//  sidebar
//
//  Created by Alex Logan on 08/12/2020.
//

import Foundation

enum FancyListSectionIdentifier: CaseIterable {
    case appleMusic
    case Library
}

enum FancyListItemType {
    case expandableHeader, header, row
}


enum FancyListItemIdentifier {
    // Apple Music
    case listenNow, browse, radio
    // Library
    case recentlyPlayed, artists, albums
}

struct FancyListItem: Hashable {
    var identifier: FancyListItemIdentifier?
    var type: FancyListItemType = .row
    let text: String
    var imageName: String?
}

struct FancyListSection: Hashable {
    let identifier: FancyListSectionIdentifier
    let header: FancyListItem
    let items: [FancyListItem]
    
    static let main = FancyListSection(
        identifier: .appleMusic,
        header: FancyListItem(type: .header, text: "Apple Music", imageName: nil),
        items: [
            FancyListItem(identifier: .listenNow, text: "Listen Now", imageName: "play.circle"),
            FancyListItem(identifier: .browse, text: "Browse", imageName: "music.note"),
            FancyListItem(identifier: .radio, text: "Radio", imageName: "radio"),
    ])
    
    static let secondary = FancyListSection(
        identifier: .Library,
        header: FancyListItem(type: .expandableHeader, text: "Library", imageName: nil),
        items: [
            FancyListItem(identifier: .recentlyPlayed, text: "Recently Played", imageName: "clock"),
            FancyListItem(identifier: .artists, text: "Artists", imageName: "person.fill"),
            FancyListItem(identifier: .albums, text: "Albums", imageName: "music.note.list"),
    ])
}
