//
//  AppTheme.swift
//  NewsApp
//
//  Created by Bogdan Pohidnya on 10.04.2021.
//

import UIKit

struct AppTheme {
    let components: UIComponentsLibrary
}

extension AppTheme {
    
    static let light = AppTheme(components: .init(
        navigationBar: .init(
            text: .init(
                color: UIStyleGuide.ColorPalette.tblack,
                font: .title1
            ),
            background: .init(color: UIStyleGuide.ColorPalette.white)
        ),
        backgroundColor: UIStyleGuide.ColorPalette.white,
        placeholder: .init(color: UIStyleGuide.ColorPalette.black, font: .titleFeed),
        feed: .init(
            title: .init(color: UIStyleGuide.ColorPalette.tblack, font: .titleFeed),
            author: .init(color: UIStyleGuide.ColorPalette.lightGray, font: .authorFeed),
            background: UIStyleGuide.ColorPalette.white
        ),
        details: .init(
            title: .init(color: UIStyleGuide.ColorPalette.black, font: .titleDetails),
            author: .init(color: UIStyleGuide.ColorPalette.black, font: .authorDetails),
            description: .init(color: UIStyleGuide.ColorPalette.black, font: .descriptionDetails),
            button: .init(
                text: .init(color: UIStyleGuide.ColorPalette.blue, font: .title1),
                background: .init(color: UIStyleGuide.ColorPalette.spaceGray)
            )
        )
    ))
    
}

extension AppTheme {
    
    static let dark = AppTheme(components: .init(
        navigationBar: .init(
            text: .init(
                color: UIStyleGuide.ColorPalette.white,
                font: .title1
            ),
            background: .init(color: UIStyleGuide.ColorPalette.dBlack)
        ),
        backgroundColor: UIStyleGuide.ColorPalette.black,
        placeholder: .init(color: UIStyleGuide.ColorPalette.white, font: .titleFeed),
        feed: .init(
            title: .init(color: UIStyleGuide.ColorPalette.white, font: .titleFeed),
            author: .init(color: UIStyleGuide.ColorPalette.lightGray, font: .authorFeed),
            background: UIStyleGuide.ColorPalette.tinyBlack
        ),
        details: .init(
            title: .init(color: UIStyleGuide.ColorPalette.white, font: .titleDetails),
            author: .init(color: UIStyleGuide.ColorPalette.gray, font: .authorDetails),
            description: .init(color: UIStyleGuide.ColorPalette.white, font: .descriptionDetails),
            button: .init(
                text: .init(color: UIStyleGuide.ColorPalette.white, font: .title1),
                background: .init(color: UIStyleGuide.ColorPalette.darkGray)
            )
        )
    ))

}
