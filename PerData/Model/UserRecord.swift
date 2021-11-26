//
//  UserRecord.swift
//  PerData
//
//  Created by Jan Hovland on 16/11/2021.
//

import SwiftUI
import CloudKit

struct UserRecord: Identifiable {
    var id = UUID()
    var recordID: CKRecord.ID?
    var firstName: String
    var lastName: String
    var email: String
    var passWord: String 
    var image: UIImage?
}
