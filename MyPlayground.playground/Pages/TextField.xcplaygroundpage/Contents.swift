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

struct TestView: View {
  @State var input: String = ""
  var body: some View {
    Text("Hello, playground")
    TextField("Clear input field...", text: $input)
      .textFieldStyle(ClearTextFieldStyle())
  }
}

PlaygroundPage.current.liveView = UIHostingController(rootView: TestView())

//: [Next](@next)
