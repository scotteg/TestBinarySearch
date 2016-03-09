//
//  ViewController.swift
//  TestBinarySearch
//
//  Created by Scott Gardner on 3/9/16.
//  Copyright © 2016 Scott Gardner. All rights reserved.
//

import UIKit

let maxInt = 9_999_999 //UInt32.max

extension Array {
  
  func isValidForSearch() -> Bool {
    guard isEmpty == false && count < 2_000_000_000 else { return false }
    return true
  }
  
}

class ViewController: UIViewController {
  
  @IBOutlet weak var textView: UITextView!
  
  enum SearchError: ErrorType {
    case InvalidArray
  }
  
  var randomArrayOfInts: [Int]!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    appendToTextViewText("Configuring array of random Ints of size \(maxInt)...")
    populateRandomArrayOfInts()
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    let randomInt = Int(arc4random_uniform(UInt32(maxInt)))
    appendToTextViewText("Searching for \(randomInt) in array...")
    
    do {
      try linearSearchFor(randomInt, inArray: randomArrayOfInts)
      try binarySearchFor(randomInt, inArray: randomArrayOfInts)
      try recursiveBinarySearchFor(randomInt, inArray: randomArrayOfInts)
    } catch {
      print(error)
    }
  }
  
  func populateRandomArrayOfInts() {
    var array = [Int]()
    
    for _ in 0..<maxInt {
      array.append(Int(arc4random_uniform(UInt32(maxInt))))
    }
    
    randomArrayOfInts = array
  }
  
  func appendToTextViewText(text: String, terminator: String = "\n\n") {
    textView.text = textView.text + text + terminator
  }
  
  func linearSearchFor<T: Comparable>(item: T, inArray array: [T]) throws -> Bool {
    guard array.isValidForSearch() else {
      throw SearchError.InvalidArray
    }
    
    let start = NSDate().timeIntervalSince1970
    let function = __FUNCTION__
    defer {
      let end = NSDate().timeIntervalSince1970
      appendToTextViewText("\(function) took \(end - start) seconds.")
    }
    
    let sortedArray = array.sort()
    
    for i in sortedArray {
      if i == item {
        return true
      }
    }
    
    return false
  }
  
  func binarySearchFor<T: Comparable>(item: T, inArray array: [T]) throws -> Bool {
    guard array.isValidForSearch() else {
      throw SearchError.InvalidArray
    }
    
    let start = NSDate().timeIntervalSince1970
    let function = __FUNCTION__
    defer {
      let end = NSDate().timeIntervalSince1970
      appendToTextViewText("\(function) took \(end - start) seconds.")
    }
    
    let sortedArray = array.sort()
    var left = 0
    var right = sortedArray.count - 1
    
    while left <= right {
      let middle = (left + right) / 2
      let value = sortedArray[middle]
      
      if value == item {
        return true
      }
      
      if value < item {
        left = middle + 1
      }
      
      if value > item {
        right = middle - 1
      }
    }
    
    return false
  }
  
  func recursiveBinarySearchFor<T: Comparable>(item: T, inArray array: [T], left: Int = 0, right: Int = -1) throws -> Bool {
    guard array.isValidForSearch() else {
      throw SearchError.InvalidArray
    }
    
    let start = NSDate().timeIntervalSince1970
    let function = __FUNCTION__
    defer {
      let end = NSDate().timeIntervalSince1970
      appendToTextViewText("\(function) took \(end - start) seconds.")
    }
    
    let sortedArray = array.sort()
    
    if left < right {
      let middle = (left + right) / 2
      
      if item < sortedArray[middle] {
        return try recursiveBinarySearchFor(item, inArray: sortedArray, left: left, right: middle)
      }
      
      if item > array[middle] {
        return try recursiveBinarySearchFor(item, inArray: sortedArray, left: middle + 1, right: right)
      }
      
      return true
    }
    
    return sortedArray[left] == item
  }
  
}
