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

class CardFaceCell: UICollectionViewCell {
  private let placeholderLabel: UILabel
  private let nameLabel: UILabel
  
  override init(frame: CGRect) {
    placeholderLabel = UILabel()
    nameLabel = UILabel()
    super.init(frame: frame)
    setUpViews()
    setUpConstraints()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configure(for card: Card) {
    nameLabel.text = card.player.name
  }
}

// MARK: Private methods
extension CardFaceCell {
  private func setUpConstraints() {
    contentView.addSubview(placeholderLabel)
    contentView.addSubview(nameLabel)
    placeholderLabel.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }
    nameLabel.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(8)
      make.trailing.equalToSuperview().inset(8)
      make.bottom.equalToSuperview().inset(8)
    }
  }
  
  private func setUpViews() {
    backgroundColor = .systemGray3
    
    placeholderLabel.font = UIFont.preferredFont(forTextStyle: .headline)
    placeholderLabel.text = "Card Front"
    placeholderLabel.textColor = .systemGray2
    
    nameLabel.font = UIFont.preferredFont(forTextStyle: .title1).bold()
    nameLabel.numberOfLines = 0
    nameLabel.textColor = .systemGray
  }
}
