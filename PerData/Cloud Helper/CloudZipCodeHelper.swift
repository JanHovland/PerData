//
//  CloudZipCodeHelper.swift
//  PerData
//
//  Created by Jan Hovland on 29/10/2021.
//

import SwiftUI
import CloudKit

func saveZipCode(_ zipCode: ZipCode) async -> LocalizedStringKey {
    var message: LocalizedStringKey = ""
    do {
        try await CloudKitZipCode().saveZipCode(zipCode)
        message = "The zipCode is saved in CloudKit"
        return message
    } catch {
        message = LocalizedStringKey(error.localizedDescription)
        return message
    }
}

func findZipCode(_ predicate: NSPredicate) async -> [ZipCode] {
    let zipCode = [ZipCode]()
    do {
        return try await CloudKitZipCode().fetchZipCodes(predicate)
    } catch {
        print(LocalizedStringKey(error.localizedDescription))
    }
    return zipCode
}

func deleteZipCode(_ recID: CKRecord.ID) async -> LocalizedStringKey {
    var message: LocalizedStringKey = ""
    do {
        try await CloudKitZipCode().deleteZipCode(recID)
        message = "The zipCode is deleted in CloudKit"
        return message
    } catch {
        message = LocalizedStringKey(error.localizedDescription)
        return message
    }
}
    
//func deleteAllZipCodes() async -> LocalizedStringKey {
//    var message: LocalizedStringKey = ""
//    do {
//        try await CloudKitZipCode().deleteAllZipCodes()
//        message = "All zip codes are deleted in CloudKit"
//        return message
//    } catch {
//        message = LocalizedStringKey(error.localizedDescription)
//        return message
//    }
//}
    

    
    
    
