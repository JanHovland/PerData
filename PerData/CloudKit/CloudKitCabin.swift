//
//  CloudKitCabin.swift
//  PerData
//
//  Created by Jan Hovland on 15/11/2021.
//

import CloudKit
import SwiftUI

struct CloudKitCabin {
    
    var database = CKContainer(identifier: Config.containerIdentifier).publicCloudDatabase
    
    struct RecordType {
        static let Cabin = "Cabin"
    }
    
    func saveCabin(_ cabin: Cabin) async throws {
        let cabinRecord = CKRecord(recordType: RecordType.Cabin)
        cabinRecord["firstName"] = cabin.firstName
        cabinRecord["lastName"] = cabin.lastName
        cabinRecord["fromDate"] = cabin.fromDate
        cabinRecord["toDate"] = cabin.toDate
        do {
            try await database.save(cabinRecord)
        } catch {
            throw error
        }
    }
    
    func existCabin(_ cabin: Cabin) async throws -> Bool {
        let predicate = NSPredicate(format: "firstName == %@ AND lastName == %@ AND fromDate == %i AND toDate == %i", cabin.firstName, cabin.lastName, cabin.fromDate as CVarArg, cabin.toDate as CVarArg)
        let query = CKQuery(recordType: RecordType.Cabin, predicate: predicate)
        do {
            let result = try await database.records(matching: query)
            for _ in result.0 {
                return true
            }
        } catch {
            throw error
        }
        return false
    }

    func getAllCabins() async throws -> [Cabin] {
        var cabins = [Cabin]()
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: RecordType.Cabin, predicate: predicate)
        do {
            let result = try await database.records(matching: query)
            for res in result.0 {
                var cabin = Cabin(firstName: "",
                                  lastName: "",
                                  fromDate: 0,
                                  toDate: 0)
                let id = res.0.recordName
                let recID = CKRecord.ID(recordName: id)
                let per = try await database.record(for: recID)
                let firstName = per.value(forKey: "firstName") ?? ""
                let lastName = per.value(forKey: "lastName") ?? ""
                let fromDate = per.value(forKey: "fromDate") ?? 0
                let toDate = per.value(forKey: "toDate") ?? 0
                cabin.recordID = recID
                cabin.firstName = firstName as! String
                cabin.lastName = lastName as! String
                cabin.fromDate = fromDate as! Int64
                cabin.toDate = toDate as! Int64
                
                cabins.append(cabin)
                cabins.sort(by: {$0.firstName < $1.firstName})
            }
            return cabins
        } catch {
            throw error
        }
    }
    
    func deleteOneCabin(_ recID: CKRecord.ID) async throws {
        do {
            try await database.deleteRecord(withID: recID)
        } catch {
            throw error
        }
    }

    func modifyCabin(_ cabin: Cabin) async throws {
        
        guard let recID = cabin.recordID else { return }
        
        do {
            let cabinRecord = CKRecord(recordType: RecordType.Cabin)
            cabinRecord["firstName"] = cabin.firstName
            cabinRecord["lastName"] = cabin.lastName
            cabinRecord["fromDate"] = cabin.fromDate
            cabinRecord["address"] = cabin.toDate
            do {
                let _ = try await database.modifyRecords(saving: [cabinRecord], deleting: [recID])
            } catch {
                throw error
            }
        } catch {
            throw error
        }
    }
   
    func getCabinRecordID(_ cabin: Cabin) async throws -> CKRecord.ID? {
        let predicate = NSPredicate(format: "firstName = %@ AND lastName = %@", cabin.firstName, cabin.lastName)
        let query = CKQuery(recordType: RecordType.Cabin, predicate: predicate)
        do {
            let result = try await database.records(matching: query)
            for res in result.0 {
                let id = res.0.recordName
                return CKRecord.ID(recordName: id)
            }
        } catch {
            throw error
        }
        return nil
    }
    
    func deleteAllCabins(_ recID: CKRecord.ID) async throws {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: RecordType.Cabin, predicate: predicate)
        do {
            let result = try await database.records(matching: query)
            for res in result.0 {
                let id = res.0.recordName
                let recID = CKRecord.ID(recordName: id)
                try await database.deleteRecord(withID: recID)
            }
        } catch {
            throw error
        }
    }

}
