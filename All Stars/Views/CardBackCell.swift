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
import SnapKit

class CardBackCell: UICollectionViewCell {
  typealias TapHandler = (Int64) -> Void
  
  private let placeholderLabel: UILabel
  private let buttonSize: CGSize
  private weak var card: Card? {
    didSet {
      tableView.reloadData()
    }
  }
  private let deleteButton: UIButton
  private let updateButton: UIButton
  private let tableView: UITableView
  
  var deleteTapHandler: TapHandler?
  var updateTapHandler: TapHandler?
  
  override init(frame: CGRect) {
    placeholderLabel = UILabel()
    buttonSize = CGSize(width: 44, height: 44)
    deleteButton = UIButton(frame: CGRect.zero)
    updateButton = UIButton(frame: CGRect.zero)
    tableView = UITableView()
    super.init(frame: frame)
    setUpViews()
    setUpConstraints()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configure(for card: Card) {
    self.card = card
  }
}

// MARK: Private methods
extension CardBackCell {
  private func configureActionButton(_ button: UIButton) {
    button.layer.cornerRadius = buttonSize.height * 0.5
    button.layer.shadowOffset = CGSize(width: 0, height: 2)
    button.layer.shadowRadius = 2
    button.layer.shadowOpacity = 0.25
    button.imageView?.tintColor = .white
  }
  
  @objc private func handleDeleteButtonTap() {
    guard let id = card?.identity.id, let handler = deleteTapHandler else { return }
    handler(id)
  }
  
  @objc private func handleUpdateButtonTap() {
    guard let id = card?.identity.id, let handler = updateTapHandler else { return }
    handler(id)
  }
  
  private func setUpConstraints() {
    contentView.addSubview(placeholderLabel)
    contentView.addSubview(tableView)
    contentView.addSubview(updateButton)
    contentView.addSubview(deleteButton)
    
    placeholderLabel.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }
    tableView.snp.makeConstraints { make in
      make.leading.equalTo(updateButton)
      make.top.equalToSuperview().offset(8)
      make.trailing.equalTo(deleteButton)
      make.bottom.equalTo(updateButton)
    }
    updateButton.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(8)
      make.bottom.equalToSuperview().inset(8)
      make.size.equalTo(buttonSize)
    }
    deleteButton.snp.makeConstraints { make in
      make.trailing.equalToSuperview().inset(8)
      make.bottom.equalTo(updateButton)
      make.size.equalTo(updateButton)
    }
  }
  
  private func setUpViews() {
    backgroundColor = .systemGray2
    
    placeholderLabel.font = UIFont.preferredFont(forTextStyle: .headline)
    placeholderLabel.text = "Card Back"
    placeholderLabel.textColor = .systemGray
    
    tableView.allowsSelection = false
    tableView.backgroundColor = .clear
    tableView.contentInset.bottom = (buttonSize.height + 8)
    tableView.dataSource = self
    tableView.separatorStyle = .none
    tableView.register(AttributeCell.self, forCellReuseIdentifier: "attribute.cell")
    tableView.showsVerticalScrollIndicator = false
    tableView.showsHorizontalScrollIndicator = false
    tableView.tableFooterView = UIView()
    
    deleteButton.addTarget(self, action: #selector(handleDeleteButtonTap), for: .touchUpInside)
    deleteButton.backgroundColor = .systemRed
    deleteButton.setImage(UIImage(systemName: "trash"), for: .normal)
    configureActionButton(deleteButton)
    
    updateButton.addTarget(self, action: #selector(handleUpdateButtonTap), for: .touchUpInside)
    updateButton.backgroundColor = .systemBlue
    updateButton.setImage(UIImage(systemName: "arrow.2.circlepath"), for: .normal)
    configureActionButton(updateButton)
  }
}

// MARK: UITableView Data Source
extension CardBackCell: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return card?.attributes.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let attribute = card?.attributes[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: "attribute.cell", for: indexPath) as! AttributeCell
    cell.configure(for: attribute)
    return cell
  }
}
