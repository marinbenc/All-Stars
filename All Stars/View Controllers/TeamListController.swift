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

import UIKit
import GRDB

class TeamListController: UIViewController {
  typealias SelectionHandler = (TeamMember) -> Void
  
  @IBOutlet private var tableView: UITableView!
  
  private weak var queue: DatabaseQueue?
  private var sectionTitles: [String]
  private var teamMemberGroups: [[TeamMember]]
  
  private let selectionHandler: SelectionHandler
  
  init?(coder: NSCoder, queue: DatabaseQueue?, selectionHandler: @escaping SelectionHandler) {
    self.queue = queue
    self.selectionHandler = selectionHandler
    self.sectionTitles = []
    self.teamMemberGroups = []
    super.init(coder: coder)
    readTeamMembers()
  }
  
  required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
}

// MARK: GRDB C.R.U.D
extension TeamListController {
  private func readTeamMembers() {
    do {
      try queue?.read { db in
        let team = try TeamMember.all(db)
        group(team: team)
      }
    } catch {
      print(error)
    }
  }
}

// MARK: UITableView Data Source
extension TeamListController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return sectionTitles.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return teamMemberGroups[section].count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let teamMember = teamMemberGroups[indexPath.section][indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: "team.list.cell", for: indexPath)
    cell.textLabel?.text = teamMember.name
    return cell
  }
  
  func sectionIndexTitles(for tableView: UITableView) -> [String]? {
    return sectionTitles
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return sectionTitles[section]
  }
}

// MARK: UITableView Delegate
extension TeamListController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let teamMember = teamMemberGroups[indexPath.section][indexPath.row]
    selectionHandler(teamMember)
  }
}

// MARK: Private Methods
extension TeamListController {
  private func group(team: [TeamMember]) {
    let teamGroupedByInitial = Dictionary.init(grouping: team, by: { $0.sortKey })
    sectionTitles = Array(teamGroupedByInitial.keys).sorted(by: { $0 < $1 })
    teamMemberGroups = sectionTitles.compactMap { teamGroupedByInitial[$0] }
  }
}
