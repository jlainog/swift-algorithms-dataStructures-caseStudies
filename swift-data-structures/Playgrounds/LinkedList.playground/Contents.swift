import XCTest

public struct LinkedList<Value> {
    public final class Node<Value> {
        public let value: Value
        public var next: Node?
        
        public init(value: Value, next: Node? = nil) {
            self.value = value
            self.next = next
        }
    }
    
    public var head: Node<Value>?
    public var tail: Node<Value>?
    public var count: Int = 0
    public var isEmpty: Bool { true }
    
    public mutating func push(_ value: Value) {
    }
    
    @discardableResult
    public mutating func pop() -> Value? {
        nil
    }
    
    public mutating func append(_ value: Value) {
    }
    
    @discardableResult
    public mutating func removeLast() -> Value? {
        nil
    }
    
    public mutating func insert(_ value: Value, after node: Node<Value>) -> Node<Value> {
        .init(value: value)
    }
    
    @discardableResult
    public mutating func remove(after node: Node<Value>) -> Value? {
        nil
    }
    
    @discardableResult
    private mutating func copyNodes(with referencedNode: Node<Value>? = nil) -> Node<Value>? {
        nil
    }
}

extension LinkedList.Node: CustomStringConvertible {
    public var description: String {
        guard let next = next else {
            return "\(value) -> nil"
        }
        return "\(value) -> " + String(describing: next)
    }
}

/*
extension LinkedList: ExpressibleByArrayLiteral {
    public typealias ArrayLiteralElement = Value
    
    public init(arrayLiteral elements: LinkedList.ArrayLiteralElement...) {
        self.init()
        elements.forEach { append($0) }
    }
}
*/

extension LinkedList {
    public func toArray() -> [Value] {
        []
    }
}

final class UnitTests: XCTestCase {
    func testPush() {
        // Given
        var list = LinkedList<Int>()
        
        // When
        list.push(3)
        list.push(2)
        list.push(1)
        
        // Then
        XCTAssertEqual(list.toArray(), [1,2,3])
    }
    
    func testPop() {
        // Given
        var list = LinkedList<Int>()
        list.push(3)
        list.push(2)
        list.push(1)
        
        // When
        let value = list.pop()
        
        // Then
        XCTAssertEqual(value, 1)
        XCTAssertEqual(list.toArray(), [2, 3])
    }
    
    func testPopUntilEmpty() {
        // Given
        var list = LinkedList<Int>()
        list.push(3)
        list.push(2)
        list.push(1)
        
        // When
        _ = list.pop()
        _ = list.pop()
        let value = list.pop()
        
        // Then
        XCTAssertEqual(value, 3)
        XCTAssertNil(list.head)
        XCTAssertNil(list.tail)
    }
    
    func testAppend() {
        // Given
        var list = LinkedList<Int>()
        
        // Then
        XCTAssertEqual(list.toArray(), [])
        
        // When
        list.append(1)
        list.append(2)
        list.append(3)
        
        // Then
        XCTAssertEqual(list.toArray(), [1,2,3])
    }
    
    func testRemoveLast() {
        // Given
        var list = LinkedList<Int>()
        list.append(1)
        list.append(2)
        list.append(3)
        
        // When
        let value = list.removeLast()
        
        // Then
        XCTAssertEqual(value, 3)
        XCTAssertEqual(list.toArray(), [1,2])
    }
    
    func testRemoveLastUntilEmpty() {
        // Given
        var list = LinkedList<Int>()
        list.append(1)
        list.append(2)
        list.append(3)
        
        // When
        _ = list.removeLast()
        _ = list.removeLast()
        let value = list.removeLast()
        
        // Then
        XCTAssertEqual(value, 1)
        XCTAssertNil(list.head)
        XCTAssertNil(list.tail)
    }
    
    func testRemoveAfter() {
        // Given
        var list = LinkedList<Int>()
        list.append(1)
        list.append(2)
        list.append(3)
        
        // When
        guard let node0 = list.head else {
            XCTFail("Node at Index 0 should exist")
            return
        }
        let value = list.remove(after: node0)
        
        // Then
        XCTAssertEqual(value, 2)
        XCTAssertEqual(list.head?.value, 1)
        XCTAssert(list.head?.next === list.tail)
        XCTAssertEqual(list.tail?.value, 3)
    }
    
    func testRemoveAfterNodeBeforeTail() {
        // Given
        var list = LinkedList<Int>()
        list.append(1)
        let node1 = list.insert(2, after: list.head!)
        list.insert(3, after: node1)
        
        // When
        let value = list.remove(after: node1)
        
        // Then
        XCTAssertEqual(value, 3)
        XCTAssertEqual(list.head?.value, 1)
        XCTAssertEqual(list.tail?.value, 2)
    }
    
    func testLinkedListCopyOnWriteAppend() {
        // Given
        var list = LinkedList<Int>()
        list.append(1)
        list.append(2)
        
        // When
        var otherList = list
        otherList.append(3)
        
        // Then
        XCTAssertTrue(isKnownUniquelyReferenced(&list.head))
        XCTAssertNotEqual(list.toArray(), otherList.toArray())
    }
    
    func testLinkedListCopyOnWriteInsert() {
        // Given
        var list = LinkedList<Int>()
        list.append(1)
        list.append(3)
        
        // When
        var otherList = list
        otherList.insert(2, after: otherList.head!)
        
        // Then
        XCTAssertTrue(isKnownUniquelyReferenced(&list.head))
        XCTAssertNotEqual(list.toArray(), otherList.toArray())
    }
    
    /*
    func testCollectionConformance() {
        // Given
        var list = LinkedList<Int>()
        
        for i in 0...9 {
            list.append(i)
        }
        
        // When
        let firstValue = list.first
        let initialValue = list[list.startIndex]
        let sumAllValues = list.reduce(0, +)
        let lastValue = list.sorted(by: >).first
        
        // Then
        XCTAssertEqual(firstValue, 0)
        XCTAssertEqual(initialValue, 0)
        XCTAssertEqual(lastValue, 9)
        XCTAssertEqual(sumAllValues, 45)
    }
     */
}

UnitTests.defaultTestSuite.run()

//: Challenges
extension LinkedList {
    func reversed() -> LinkedList<Value> {
        .init()
    }
    
    func middle() -> Node<Value>? {
        nil
    }
}

extension LinkedList where Value: Comparable {
    //Assume both list passed are sorted
    static func mergeSortedList(lhs: LinkedList<Value>,
                                rhs: LinkedList<Value>) -> LinkedList<Value> {
        .init()
    }
    
    mutating func remove(value: Value) {
    }
}

final class ChallengesTests: XCTestCase {

    // Create a function that prints out the elements of a linked list in reverse order
    func testReverseList() {
        // Given
        var list = LinkedList<Int>()
        (1...3).forEach { list.append($0) }
        
        // When
        let reversed = list.reversed()
        
        // Then
        XCTAssertEqual(reversed.toArray(),
                       [3, 2, 1])
    }

    // Create a function that returns the middle node of a linked list
    func testFindMiddle() {
        // Given
        var list = LinkedList<Int>()
        (1...3).forEach { list.append($0) }
        
        // When
        let middleNode = list.middle()
        
        // Then
        XCTAssertEqual(middleNode?.value, 2)
    }
    
    // Create a function that takes two sorted linked lists and merges them into a single sorted linked list
    func testMergeSorted() {
        // Given
        var list1 = LinkedList<Int>()
        [1,4,5].forEach { list1.append($0) }
        var list2 = LinkedList<Int>()
        [2,3].forEach { list2.append($0) }
        
        // When
        let list = LinkedList<Int>.mergeSortedList(lhs: list1, rhs: list2)
        
        // Then
        XCTAssertEqual(list.head?.value, 1)
        XCTAssertEqual(list.tail?.value, 5)
        XCTAssertEqual(list.toArray(), [1,2,3,4,5])
    }
    
    // Create a function that removes all occurrences of a specific element from a linked list
    func testRemoveOccurrences() {
        // Given
        var list = LinkedList<Int>()
        [5,5,1,5,2,5,3,5,4,5].forEach { list.append($0) }
        
        // When
        list.remove(value: 5)
        
        // Then
        XCTAssertEqual(list.head?.value, 1)
        XCTAssertEqual(list.tail?.value, 4)
        XCTAssertEqual(list.toArray(), [1, 2, 3, 4])
    }
}

ChallengesTests.defaultTestSuite.run()
