//: [Previous](@previous)

import SwiftUI

/**
 * Custom shape for use in borders, overlays, and masking with BezierPath / Path
 */

struct ShapeView: Shape {
  let path: Path

  init(path: Path) {
    self.path = path
  }

  init(withCoordinates coordinates: [CGPoint], shouldClosePath: Bool = true) {
    var borderPath = Path()
    for (idx, coordinate) in coordinates.enumerated() {
        if idx > 0 {
            borderPath.addLine(to: coordinate)
        } else {
            borderPath.move(to: coordinate)
        }
    }

    if shouldClosePath {
        borderPath.closeSubpath()
    }
    self.path = borderPath
  }

  func path(in rect: CGRect) -> Path {
    return path
  }
}

// MARK: - Usage
import PlaygroundSupport

func buildViewStack() -> some View {
  VStack { }
  .frame(width: 200, height: 200, alignment: .center)
  .background {
    let p1 = CGPoint(x: 100, y: 20)
    let p2 = CGPoint(x: 20, y: 180)
    let p3 = CGPoint(x: 180, y: 180)
    ShapeView(withCoordinates: [p1, p2, p3])
      .foregroundColor(.green)

    let t1 = CGPoint(x: 40, y: 80)
    let t2 = CGPoint(x: 160, y: 80)
    let t3 = CGPoint(x: 100, y: 160)
    ShapeView(withCoordinates: [t1, t2, t3])
      .foregroundColor(.orange)
  }
}

PlaygroundPage.current.liveView = UIHostingController(rootView: buildViewStack())

//: [Next](@next)
