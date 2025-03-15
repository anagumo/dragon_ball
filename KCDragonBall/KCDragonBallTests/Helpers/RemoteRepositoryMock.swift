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
}
