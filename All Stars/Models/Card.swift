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

final class Card {
  var player: TeamMember
  var identity: Identity
  var attributes: [Attribute]
  
  init(player: TeamMember, identity: Identity, attributes: [Attribute]) {
    self.player = player
    self.identity = identity
    self.attributes = attributes
  }
}

// MARK: Codable
extension Card: Decodable {}

// MARK: GRDB
extension Card: FetchableRecord {
  static func all(_ db: Database) throws -> [Card] {
    return try Identity
      .including(required: Identity.player)
      .including(all: Identity.attributes)
      .order([Column("position"), Column("id")])
      .asRequest(of: Card.self)
      .fetchAll(db)
  }
  
  static func create(forTeamMember teamMember: TeamMember, db: Database) throws -> Int64 {
    let identity = Identity(teamMemberId: teamMember.id, category: Category.random, position: Position.random)
    try identity.insert(db)
    try Attribute.randomAttributes(forIdentity: identity).forEach { try $0.insert(db) }
    return identity.id!
  }
  
  func delete(_ db: Database) throws {
    let _ = try identity.delete(db)
  }
  
  func update(_ db: Database) throws {
    try attributes.forEach {
      $0.randomizeValue()
      try $0.save(db)
    }
  }
}
