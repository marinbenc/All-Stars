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

class AttributeView: UIView {
  private let valueBackgroundView: UIView
  private let valueLabel: UILabel
  private let barContainer: UIView
  private let barView: UIView
  
  var value: Int {
    didSet {
      valueDidChange()
    }
  }
  
  override init(frame: CGRect) {
    value = 0
    valueBackgroundView = UIView()
    valueLabel = UILabel()
    barContainer = UIView()
    barView = UILabel()
    super.init(frame: frame)
    setUpViews()
    setUpConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: Private methods
extension AttributeView {
  private func valueDidChange() {
    valueLabel.text = "\(value)"
    
    let color = UIColor.color(forValue: value)
    valueBackgroundView.backgroundColor = color
    barView.backgroundColor = color
    
    let percentageFilled: Float = Float(value) / 100
    barView.snp.remakeConstraints { make in
      make.leading.equalToSuperview()
      make.top.equalToSuperview()
      make.bottom.equalToSuperview()
      make.width.equalToSuperview().multipliedBy(percentageFilled)
    }
  }
  
  private func setUpConstraints() {
    valueBackgroundView.addSubview(valueLabel)
    addSubview(valueBackgroundView)
    barContainer.addSubview(barView)
    addSubview(barContainer)
    
    valueBackgroundView.snp.makeConstraints { make in
      make.leading.equalToSuperview()
      make.top.equalToSuperview()
      make.bottom.equalToSuperview()
      make.width.equalTo(valueBackgroundView.snp.height).multipliedBy(1.6)
    }
    valueLabel.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    barContainer.snp.makeConstraints { make in
      make.leading.equalTo(valueBackgroundView.snp.trailing)
      make.top.equalToSuperview()
      make.trailing.equalToSuperview()
      make.bottom.equalToSuperview()
    }
    valueDidChange()
  }
  
  private func setUpViews() {
    backgroundColor = .systemFill
    
    valueLabel.adjustsFontSizeToFitWidth = true
    valueLabel.backgroundColor = UIColor(white: 0.0, alpha: 0.6)
    valueLabel.font = UIFont.preferredFont(forTextStyle: .caption2).bold()
    valueLabel.textAlignment = .center
    valueLabel.textColor = .white
  }
}
