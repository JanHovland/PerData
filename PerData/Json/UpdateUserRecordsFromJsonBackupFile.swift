//
//  UpdateUserRecordsFromJsonBackupFile.swift
//  PerData
//
//  Created by Jan Hovland on 27/11/2021.
//

import SwiftUI
import CloudKit

let jsonUserRecordFile = "UserRecordBackup.json"

private var message: LocalizedStringKey = ""

func UpdateUserRecordsFromJsonBackupFile() async -> LocalizedStringKey {
    
    var userRecordElem : [UserRecordElem] = []
    var counter = 0
    
    var message: LocalizedStringKey = ""
    var modifyImage = false
    var userRecord = UserRecord(firstName: "",
                                lastName: "",
                                email: "",
                                passWord: "",
                                image: nil)
    
    ///
    ///Leser inn fra Json til [userRecordElem]
    ///
    if let url = Bundle.main.url(forResource: jsonUserRecordFile, withExtension: nil) {
        print(url)
        if let data = try? Data(contentsOf: url) {
            print(data)
            let jsondecoder = JSONDecoder()
            print(jsondecoder)
            do{
                let result = try jsondecoder.decode([UserRecordElem].self, from: data)
                userRecordElem = result
            }
            catch {
                message = "Error trying parse Json file"
                return message
            }
        }
    } else {
        message =  "Unknown Json file"
        return message
    }
    ///
    ///Lagre person i Person tabellen
    ///
    for index in 0..<userRecordElem.count {
        userRecord = UserRecord(
            firstName: userRecordElem[index].userRecordData.firstName,
            lastName: userRecordElem[index].userRecordData.lastName,
            email: userRecordElem[index].userRecordData.email,
            passWord: userRecordElem[index].userRecordData.passWord,
            image: nil)
        ///
        /// Sjekk om brukeren finnes
        ///
        var value : (LocalizedStringKey, Bool)
        value = await userRecordExist(userRecord)
        if value.0 != "" {
            ///
            ///Feilmelding
            ///
            message = value.0
            return message
        } else {
            if value.1 == true { // Personen finnes fra før
                /// Finn recordID for userRecord som finnes fra før
                var valueID: (LocalizedStringKey, CKRecord.ID?)
                await valueID = userRecordRecordID(userRecord)
                if valueID.0 != "" {
                    message = value.0
                    return message
                } else {
                    userRecord.recordID = valueID.1
                    modifyImage = false
                    await message = modifyUserRecord(userRecord, modifyImage)
                }
            } else { // Personen finnes ikke
                await message = saveUserRecord(userRecord)
            }
            
            counter += 1
         }
    }
    
    message = LocalizedStringKey("Number of userRecords saved/modified from the Json backup file: \(counter)")
    return message
}

