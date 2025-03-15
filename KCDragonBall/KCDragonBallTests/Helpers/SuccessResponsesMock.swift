//
//  RemoteRepositoryMock.swift
//  KCDragonBall
//
//  Created by Ariana Rodríguez on 14/03/25.
//

import Foundation
@testable import KCDragonBall

enum SuccessResonsesMock {
    static let heros = [
        Hero(id: "D13A40E5-4418-4223-9CE6-D2F9A28EBE94",
             favorite: false,
             name: "Goku",
             description: "Sobran las presentaciones cuando se habla de Goku.",
             photo: "https://cdn.alfabetajuega.com/alfabetajuega/2020/12/goku1.jpg?width=300"),
        Hero(id: "D13A40E5-4418-4223-9CE6-D2F9A28EBE95",
             favorite: true,
             name: "Gohan",
             description: "Sobran las presentaciones cuando se habla de Gohan.",
             photo: "https://cdn.alfabetajuega.com/alfabetajuega/2020/12/goku1.jpg?width=300"),
        Hero(id: "64143856-12D8-4EF9-9B6F-F08742098A18",
             favorite: false,
             name: "Bulma",
             description: "",
             photo: "https://cdn.alfabetajuega.com/alfabetajuega/2021/01/Bulma-Dragon-Ball.jpg?width=300"),
        Hero(id: "CBCFBDEC-F89B-41A1-AC0A-FBDA66A33A06",
             favorite: true,
             name: "Piccolo",
             description: "",
             photo: "")
    ]
    
    static let trasformations = [
        Transformation(
            name: "2. Kaio-Ken",
            description: "La técnica de Kaio-sama permitía a Goku...",
            photo: "https://areajugones.sport.es/wp-content/uploads/2017/05/Goku_Kaio-Ken_Coolers_Revenge.jpg",
            id: "9D6012A0-B6A9-4BAB-854D-67904E96CE01"
        ),
        Transformation(
            name: "8. Super Kaio-ken",
            description: "En la lucha de Goku contra Paikuhan...",
            photo: "https://areajugones.sport.es/wp-content/uploads/2021/05/kaioken.jpg.webp",
            id: "D13A40E5-4418-4223-9CE6-D2F9A28EBE44"
        ),
        Transformation(
            name: "12. Super Saiyan Blue",
            description: "El Super Saiyan Blue es el resultado de un Super Saiyan God...",
            photo: "https://areajugones.sport.es/wp-content/uploads/2015/10/super_saiyan_god_super_saiyan__ssgss__goku_by_mikkkiwarrior3-d8wv7hx.jpg",
            id: "EE4DEC64-1B2D-47C1-A8EA-3208894A57A3")
    ]
}
