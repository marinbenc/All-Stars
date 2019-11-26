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

class CardListController: UIViewController {
  @IBOutlet private var collectionView: UICollectionView!
  @IBOutlet private var tableView: UITableView!
  
  private var cards: [Card] {
    didSet {
      tableView.reloadData()
    }
  }
  private var selectedCard: Card? {
    didSet {
      collectionView.reloadData()
    }
  }
  
  weak var queue: DatabaseQueue?
  
  required init?(coder: NSCoder) {
    cards = []
    super.init(coder: coder)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setUpViews()
    readCards()
    selectedCard = cards.first
  }
  
  @IBSegueAction
  func showTeamList(_ coder: NSCoder) -> TeamListController? {
    return TeamListController(coder: coder, queue: queue) { [weak self] teamMember in
      self?.createCard(for: teamMember)
      self?.presentedViewController?.dismiss(animated: true, completion: nil)
    }
  }
  
  @IBAction
  func cancelNewCard(_ segue: UIStoryboardSegue) {}
}

// MARK: GRDB C.R.U.D
extension CardListController {
  private func createCard(for teamMember: TeamMember) {
    do {
      let id = try queue?.write { db in
        try Card.create(forTeamMember: teamMember, db: db)
      }
      readCards()
      guard let row = cards.firstIndex(where: { $0.identity.id == id }) else { return }
      selectCardAndScroll(toRow: row)
    } catch {
      print(error)
    }
  }
  
  private func readCards() {
    do {
      try queue?.read { db in
        cards = try Card.all(db)
      }
    } catch {
      print(error)
    }
  }
  
  private func updateCard(_ card: Card) {
    do {
      try queue?.write { db in
        try card.update(db)
      }
      collectionView.reloadData()
    } catch {
      print(error)
    }
  }
  
  private func deleteCard(_ card: Card) {
    do {
      try queue?.write { db in
        try card.delete(db)
      }
      readCards()
      selectCardAndScroll(toRow: 0)
    } catch {
      print(error)
    }
  }
}

// MARK: UICollectionView Data Source
extension CardListController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return selectedCard == nil ? 0 : 2
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let card = selectedCard ?? cards[0]
    switch indexPath.item {
    case 0:
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "card.face.cell", for: indexPath) as! CardFaceCell
      cell.configure(for: card)
      return cell
    default:
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "card.info.cell", for: indexPath) as! CardBackCell
      cell.configure(for: card)
      cell.deleteTapHandler = { [weak self] id in
        guard let card = self?.cards.first(where: { $0.identity.id == id }) else { return }
        self?.deleteCard(card)
      }
      cell.updateTapHandler = { [weak self] id in
        guard let card = self?.cards.first(where: { $0.identity.id == id }) else { return }
        self?.updateCard(card)
      }
      return cell
    }
  }
}

// MARK: UITableView Data Source
extension CardListController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return cards.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let card = cards[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: "card.list.cell", for: indexPath) as! CardListCell
    cell.configure(for: card)
    return cell
  }
}

// MARK: UITableView Delegate
extension CardListController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    selectedCard = cards[indexPath.row]
    tableView.deselectRow(at: indexPath, animated: true)
  }
}

// MARK: Private methods
extension CardListController {
  private func selectCardAndScroll(toRow row: Int) {
    guard row < cards.count else { selectedCard = nil; return }
    selectedCard = cards[row]
    let indexPath = IndexPath(row: row, section: 0)
    tableView.scrollToRow(at: indexPath, at: .top, animated: true)
  }
  
  private func setUpViews() {
    collectionView.allowsSelection = false
    collectionView.collectionViewLayout = UICollectionViewCompositionalLayout.allStarsCardLayout
    collectionView.register(CardFaceCell.self, forCellWithReuseIdentifier: "card.face.cell")
    collectionView.register(CardBackCell.self, forCellWithReuseIdentifier: "card.info.cell")
    tableView.register(CardListCell.self, forCellReuseIdentifier: "card.list.cell")
  }
}
