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

class CardListCell: UITableViewCell {
  private let positionBackgroundView: UIView
  private let positionLabel: UILabel
  private let playerNameLabel: UILabel
  private let categoryLabel: UILabel
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    positionBackgroundView = UIView()
    positionLabel = UILabel()
    playerNameLabel = UILabel()
    categoryLabel = UILabel()
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setUpViews()
    setUpConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configure(for card: Card) {
    positionLabel.text = card.identity.position.abbreviation
    playerNameLabel.text = card.player.name
    categoryLabel.text = card.identity.category.displayName
  }
}

// MARK: Private methods
extension CardListCell {
  private func setUpConstraints() {
    positionBackgroundView.addSubview(positionLabel)
    contentView.addSubview(positionBackgroundView)
    contentView.addSubview(playerNameLabel)
    contentView.addSubview(categoryLabel)
    
    positionLabel.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }
    positionBackgroundView.snp.makeConstraints { make in
      let size = CGSize(width: 32, height: 32)
      make.leading.equalToSuperview().offset(8)
      make.centerY.equalToSuperview()
      make.size.equalTo(size)
    }
    playerNameLabel.snp.makeConstraints { make in
      make.leading.equalTo(positionBackgroundView.snp.trailing).offset(8)
      make.top.equalToSuperview().offset(8)
      make.trailing.equalToSuperview()
    }
    categoryLabel.snp.makeConstraints { make in
      make.leading.equalTo(playerNameLabel)
      make.top.equalTo(playerNameLabel.snp.bottom).offset(4)
      make.trailing.equalToSuperview()
      make.bottom.equalToSuperview().inset(8)
    }
  }
  
  private func setUpViews() {
    positionBackgroundView.backgroundColor = .systemBlue
    positionBackgroundView.layer.cornerRadius = 16
    positionBackgroundView.layer.masksToBounds = true
    
    positionLabel.font = UIFont.preferredFont(forTextStyle: .headline)
    positionLabel.textColor = .white
    
    playerNameLabel.font = UIFont.preferredFont(forTextStyle: .headline)
    playerNameLabel.textColor = .label
    playerNameLabel.numberOfLines = 0
    
    categoryLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
    categoryLabel.textColor = .secondaryLabel
  }
}
