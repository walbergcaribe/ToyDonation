//
//  Toy.swift
//  ToyDonation
//
//  Created by user195143 on 12/21/21.
//

import Foundation

struct ToyDonation {
    let id: String
    let name: String
    let state: Int
    let donor: String
    let address: String
    let phone: String
    
    var toyState: String {
        switch state {
        case 0:
            return "Novo"
        case 1:
            return "Usado"
        default:
            return "Precisa de reparo"
        }
    }
}
