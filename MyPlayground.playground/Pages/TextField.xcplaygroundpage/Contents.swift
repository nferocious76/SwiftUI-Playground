import Combine
import SwiftUI

/**
 * Customizing TextField with TextFieldStyle
 */

// MARK: - Custom TextFieldStyle
struct ClearTextFieldStyle: TextFieldStyle {
  func _body(configuration: TextField<_Label>) -> some View {
    HStack {
      configuration

      let mirror = Mirror(reflecting: configuration)
      let textBinding = mirror.descendant("_text") as! Binding<String>

      Button {
        textBinding.wrappedValue = ""
      } label: {
        Image(systemName: "clear")
      }
      .padding(10)
      .border(.gray, width: 1)
      .disabled(textBinding.wrappedValue.isEmpty)
    }
    .padding(10)
    .border(.green, width: 1)
  }
}

// MARK: - Preview
import PlaygroundSupport

/**
 * Applying field focus and custom styling
 */

struct TestView: View {
  enum Field: Hashable {
    case field1
    case field2
  }

  @State var input: String = ""
  @FocusState var focusedField: Field?

  var body: some View {
    Text("Hello, playground")
    TextField("Clear input field...", text: $input, onCommit: {
      focusedField = .field2
    })
    .textFieldStyle(ClearTextFieldStyle())
    .focused($focusedField, equals: .field1)

    // Focus state
    TextField("Focus input field...", text: $input)
      .focused($focusedField, equals: .field2)
  }
}

PlaygroundPage.current.liveView = UIHostingController(rootView: TestView())

//: [Next](@next)
