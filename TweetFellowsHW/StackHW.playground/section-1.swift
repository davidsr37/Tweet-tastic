// Playground - noun: a place where people can play

import UIKit


class StackExample {
  var things = [Int]()
  
  func push (thing : Int) {
    self.things.append(thing)
  }
  
  func pop() -> Int? {
    if !self.things.isEmpty {
      let thing = self.things.last
      self.things.removeLast()
      return thing!
    } else {
      return nil
    }
  }
  
  func peekaboo() ->Int? {
    return self.things.last
  }
  
}
