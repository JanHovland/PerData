//
//  CloudPersonHelper.swift
//  PerData
//
//  Created by Jan Hovland on 11/10/2021.
//

import SwiftUI
import CloudKit

///
/// Ved å endre f. eks. func save(person: Person)  til:
///     func save(_ person: Person)  kan den kalles slik:
///     save(person) i stedet for save(person: person)
///

func save(_ person: Person) async -> LocalizedStringKey {
    var message: LocalizedStringKey = ""
    do {
        try await CloudKitPerson().savePerson(person)
        message = "The person has been saved in CloudKit"
        return message
    } catch {
        message = LocalizedStringKey(error.localizedDescription)
        return message
    }
}

func modify(_ person: Person, _ newImage: Bool) async -> LocalizedStringKey {
    var message: LocalizedStringKey = ""
    do {
        try await CloudKitPerson().modifyPerson(person, newImage)
        message = "The person has been modified in CloudKit"
        return message
    } catch {
        message = LocalizedStringKey(error.localizedDescription)
        return message
    }
}

func personExist(_ person: Person) async -> (err: LocalizedStringKey, exist: Bool) {
    var err : LocalizedStringKey = ""
    var exist : Bool = false
    do {
        exist = try await CloudKitPerson().existPerson(person)
        err = ""
    } catch {
        print(error.localizedDescription)
        err  = LocalizedStringKey(error.localizedDescription)
        exist = false
    }
    return (err, exist)
}

func findPersons(_ predicate: NSPredicate) async -> (err: LocalizedStringKey, person: [Person]) {
    var err : LocalizedStringKey = ""
    var person = [Person]()
    do {
        err = ""
        person = try await CloudKitPerson().getAllPersons(predicate)
    } catch {
        err  = LocalizedStringKey(error.localizedDescription)
        person = [Person]()
    }
    
    return (err , person)
}


func deletePerson(_ recID: CKRecord.ID) async -> LocalizedStringKey {
    var message: LocalizedStringKey = ""
    do {
        try await CloudKitPerson().deleteOnePerson(recID)
        message = "The person has been deleted"
        return message
    } catch {
        message = LocalizedStringKey(error.localizedDescription)
        return message
    }
}

func personRecordID(_ person: Person) async -> (err: LocalizedStringKey, id: CKRecord.ID?) {
    var err : LocalizedStringKey = ""
    var id: CKRecord.ID?
    do {
        id = try await CloudKitPerson().getPersonRecordID(person)
        err = ""
    } catch {
        print(error.localizedDescription)
        err = LocalizedStringKey(error.localizedDescription)
        id = nil
    }
    return (err, id)
}
    
