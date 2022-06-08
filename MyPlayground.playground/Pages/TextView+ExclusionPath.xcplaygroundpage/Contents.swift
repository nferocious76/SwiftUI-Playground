//: [Previous](@previous)

import Foundation
import SwiftUI
import UIKit
import PlaygroundSupport

var greeting = "Lorem Ipsum is simply dummy text of the printing and typesetting industry.\n\nLorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."

var initialText: String {
  String(greeting[...greeting.startIndex])
}

var bodyText: String {
  String(greeting[greeting.index(after: greeting.startIndex)...])
}

struct TextView: UIViewRepresentable {
  typealias UIViewType = UITextView

  @Binding private var text: String

  private let font: UIFont?
  private let textColor: UIColor?
  private let textAlignment: NSTextAlignment
  private let exclusionPaths: [UIBezierPath]

  private let isEditable: Bool
  private let isSelectable: Bool
  private let autocorrectionType: UITextAutocorrectionType
  private let autocapitalizationType: UITextAutocapitalizationType

  init(text: Binding<String>,
       font: UIFont? = .systemFont(ofSize: 10),
       textColor: UIColor? = .black,
       textAlignment: NSTextAlignment = .left,
       exclusionPaths: [UIBezierPath],

       isEditable: Bool = false,
       isSelectable: Bool = false,
       autocorrectionType: UITextAutocorrectionType = .default,
       autocapitalizationType: UITextAutocapitalizationType = .sentences) {

    _text = text
    self.font = font
    self.textColor = textColor
    self.textAlignment = textAlignment
    self.exclusionPaths = exclusionPaths

    self.isEditable = isEditable
    self.isSelectable = isSelectable

    self.autocorrectionType = autocorrectionType
    self.autocapitalizationType = autocapitalizationType
  }

  init(text: String,
       font: UIFont? = .systemFont(ofSize: 10),
       textColor: UIColor? = .black,
       textAlignment: NSTextAlignment = .left,
       exclusionPaths: [UIBezierPath],

       isEditable: Bool = false,
       isSelectable: Bool = false,
       autocorrectionType: UITextAutocorrectionType = .default,
       autocapitalizationType: UITextAutocapitalizationType = .sentences) {

    _text = .constant(text)
    self.font = font
    self.textColor = textColor
    self.textAlignment = textAlignment
    self.exclusionPaths = exclusionPaths

    self.isEditable = isEditable
    self.isSelectable = isSelectable

    self.autocorrectionType = autocorrectionType
    self.autocapitalizationType = autocapitalizationType
  }

  func makeUIView(context: Context) -> UITextView {
    let textView = UITextView()
    textView.backgroundColor = .clear

    textView.text = text
    textView.font = font
    textView.textColor = textColor
    textView.textAlignment = textAlignment
    textView.isSelectable = isSelectable
    textView.isEditable = isEditable
    textView.textContainer.exclusionPaths = exclusionPaths

    textView.autocorrectionType = autocorrectionType
    textView.autocapitalizationType = autocapitalizationType

    return textView
  }

  func updateUIView(_ uiView: UITextView, context: Context) {
    uiView.text = text
    uiView.font = font
  }
}

func createView() -> some View {
  VStack(spacing: 24) {
    let font = UIFont.systemFont(ofSize: 15, weight: .bold)
    let path = UIBezierPath(rect: CGRect(x: 50, y: 50, width: 50, height: 50))
    TextView(text: greeting,
             textAlignment: .justified,
             exclusionPaths: [path])
    .background(.gray)

    ZStack {
      let path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: 50, height: 50))
      TextView(text: bodyText,
               font: font,
               exclusionPaths: [path])
      .background(.orange)
      .overlay {
        GeometryReader { geometry in
          HStack {
            Text(initialText)
              .font(Font.system(size: 90, weight: .bold, design: .rounded))
              .foregroundColor(.green)
              //.background(.blue)
              .frame(width: 50, height: 50, alignment: .top)
          }
          .frame(width: geometry.size.width, height: geometry.size.height, alignment: .topLeading)
        }
      }
    }
    .frame(alignment: .topLeading)
  }
  .frame(width: 300, height: 600, alignment: .center)
  .background(.black)
}

PlaygroundPage.current.liveView = UIHostingController(rootView: createView())

//: [Next](@next)
