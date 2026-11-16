//
//  AppDatabase.swift
//  sqliteswift1
//
//  Created by Noppasin Tanomsakoran on 9/11/2569 BE.
//

import Foundation
import SQLite

enum AppDatabase {
    static func open(readonly: Bool = false) throws -> Connection {
        let files = FileMananger.default
        let support = try files.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let database = support.appendingPathComponent("account_GRDB.sqlite")
        if !files.fileExists(atPath: database.path) {
            guard let seed = Bundle.main.url(forResource: "account_GRDB", withExtension: "sqlite") else { throw CocoaError(.fileNoSuchFile)
            }
            try files.copyItem(at: seed, to:database)
        }
        return try Connection(database.path, readonly: readonly)
    }
}
