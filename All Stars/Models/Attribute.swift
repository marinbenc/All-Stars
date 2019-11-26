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

final class Attribute {
  var id: Int64?
  var identityId: Int64
  var name: String
  var value: Int
  
  init(id: Int64? = nil, identityId: Int64, name: String, value: Int) {
    self.id = id
    self.identityId = identityId
    self.name = name
    self.value = value
  }
}

extension Attribute {
  static let batterAttributeNames = [
    "Contact",
    "Gap Power",
    "Home Run Power",
    "Eye",
    "Avoid K's",
    "Speed",
    "Stealing",
    "Baserunning"
  ]
  
  static let pitcherAttributeNames = [
    "Stuff",
    "Movement",
    "Control",
    "Stamina",
    "Hold Runners"
  ]
  
  static func randomAttributes(forIdentity identity: Identity) -> [Attribute] {
    let attributeNames = identity.position.isPitcher ? pitcherAttributeNames : batterAttributeNames
    return attributeNames.map {
      Attribute(identityId: identity.id!, name: $0, value: Int.random(in: 1...100))
    }
  }
  
  func randomizeValue() {
    value = Int.random(in: 1...100)
  }
}

// MARK: Codable
extension Attribute: Codable {}

// MARK: GRDB
extension Attribute: TableRecord, FetchableRecord, PersistableRecord {
  func didInsert(with rowID: Int64, for column: String?) {
    id = rowID
  }
}
