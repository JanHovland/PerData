//
//  User.swift
//  PerData
//
//  Created by Jan Hovland on 16/11/2021.
//

import SwiftUI
import CloudKit

class User: ObservableObject {
    @Published var recordID: CKRecord.ID?
    @Published var firstname = ""
    @Published var lastname = ""
    @Published var email = "jan.hovland@lyse.net"
    @Published var password = "qwerty"
    @Published var image: UIImage?
}
