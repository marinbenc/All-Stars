/// Copyright (c) 2019 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import Foundation
import GRDB

extension DatabaseMigrator {
  static var allStarsSchema: DatabaseMigrator {
    var migrator = DatabaseMigrator()
    // MARK: Schema
    // Team Member
    migrator.registerMigration("create_team_member") { db in
      try db.create(table: "teamMember") { table in
        table.column("id", .integer).primaryKey()
        table.column("name", .text).notNull()
        table.column("sortKey", .text).notNull()
      }
    }
    // Identity
    migrator.registerMigration("create_identity") { db in
      try db.create(table: "identity") { table in
        table.autoIncrementedPrimaryKey("id", onConflict: .replace)
        table.column("teamMemberId", .integer).references("teamMember", onDelete: .cascade).indexed().notNull()
        table.column("category", .integer).notNull()
        table.column("position", .integer).notNull()
      }
    }
    // Attribute
    migrator.registerMigration("create_attribute") { db in
      try db.create(table: "attribute") { table in
        table.autoIncrementedPrimaryKey("id", onConflict: .replace)
        table.column("identityId", .integer).references("identity", onDelete: .cascade).indexed().notNull()
        table.column("name", .text).notNull()
        table.column("value", .integer).notNull()
      }
    }
    // Pitch
    migrator.registerMigration("create_pitch") { db in
      try db.create(table: "pitch") { table in
        table.autoIncrementedPrimaryKey("id", onConflict: .replace)
        table.column("identityId", .integer).references("identity", onDelete: .cascade).indexed().notNull()
        table.column("name", .text).notNull()
        table.column("value", .integer).notNull()
      }
    }
    // MARK: Fixtures
    // Team Members
    migrator.registerMigration("team_member_fixtures") { db in
      guard let URL = Bundle.main.url(forResource: "Team", withExtension: "json") else { return }
      let data = try Data(contentsOf: URL)
      let team = try JSONDecoder().decode([TeamMember].self, from: data)
      try team.forEach { try $0.insert(db) }
    }
    // Identities
    migrator.registerMigration("card_fixtures") { db in
      // Ray Wenderlich = 179
      let identity = Identity(teamMemberId: 179, category: .allTimeLegend, position: .startingPitcher)
      try identity.insert(db)
      let values = [74, 84, 69, 93, 99]
      let attributes = Attribute.pitcherAttributeNames.enumerated().map { (index, name) in
        return Attribute(identityId: identity.id!, name: name, value: values[index])
      }
      try attributes.forEach { try $0.insert(db) }
    }
    return migrator
  }
}
