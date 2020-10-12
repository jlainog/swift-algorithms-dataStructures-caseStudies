import XCTest
import DataStructures

final class LinkedListTests: XCTestCase {
    
    func testPush() {
        // Given
        var list = LinkedList<Int>()
        
        // When
        list.push(3)
        list.push(2)
        list.push(1)
        
        // Then
        XCTAssertEqual(list.head?.value, 1)
        XCTAssertEqual(list.tail?.value, 3)
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
        XCTAssertEqual(list.head?.value, 2)
        XCTAssertEqual(list.tail?.value, 3)
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
        XCTAssertEqual(list.head?.value, 1)
        XCTAssertEqual(list.tail?.value, 3)
        XCTAssertEqual(list.toArray(), [1,2,3])
    }
    
    func testDescription() {
        // Given
        var list = LinkedList<Int>()
        
        // Then
        XCTAssertEqual(list.description, "Empty List")
        
        // When
        list.append(1)
        list.append(2)
        list.append(3)
        
        // Then
        XCTAssertEqual(list.description, "1 -> 2 -> 3 -> nil")
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
        XCTAssertEqual(list.head?.value, 1)
        XCTAssertEqual(list.tail?.value, 2)
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
    
    func testNodeAt() {
        // Given
        let list: LinkedList<Int> = [1,2,3]
        
        // When
        guard let node0 = list.node(at: 0) else {
            XCTFail("Node at Index 0 should exist")
            return
        }
        
        // Then
        XCTAssert(list.head === node0)
        XCTAssertEqual(list.head?.value, 1)
        XCTAssertEqual(node0.value, 1)
    }
    
    func testInsert() {
        // Given
        var list: LinkedList<Int> = [1,2,4]
        
        // When
        guard let node1 = list.node(at: 1) else {
            XCTFail("Node at Index 1 should exist")
            return
        }
        let insertedNode = list.insert(3, after: node1)
        
        // Then
        XCTAssertEqual(insertedNode.value, 3)
        XCTAssertEqual(list.head?.value, 1)
        XCTAssertEqual(list.tail?.value, 4)
    }
    
    func testInsertAfterTail() {
        // Given
        var list: LinkedList<Int> = [1,2,3]
        
        // When
        guard let node2 = list.node(at: 2) else {
            XCTFail("Node at Index 2 should exist")
            return
        }
        let insertedNode = list.insert(4, after: node2)
        
        // Then
        XCTAssert(insertedNode === list.tail)
        XCTAssertEqual(insertedNode.value, 4)
        XCTAssertEqual(list.head?.value, 1)
        XCTAssertEqual(list.tail?.value, 4)
    }
    
    func testInsertAfterHead() {
        // Given
        var list: LinkedList<Int> = [1,3,4]
        
        // When
        guard let node0 = list.node(at: 0) else {
            XCTFail("Node at Index 0 should exist")
            return
        }
        let insertedNode = list.insert(2, after: node0)
        
        // Then
        XCTAssertEqual(insertedNode.value, 2)
        XCTAssertEqual(insertedNode.next?.value, 3)
        XCTAssertEqual(list.head?.value, 1)
        XCTAssertEqual(list.head?.next?.value, 2)
        XCTAssertEqual(list.tail?.value, 4)
    }
    
    func testInsertAfter() {
        // Given
        var list: LinkedList<Int> = [1,1,1,1,1,3,4]
        
        // When
        guard let node0 = list.node(at: 4) else {
            XCTFail("Node at Index 0 should exist")
            return
        }
        let insertedNode = list.insert(2, after: node0)
        
        // Then
        XCTAssertEqual(insertedNode.value, 2)
        XCTAssertEqual(insertedNode.next?.value, 3)
        XCTAssertEqual(list.head?.value, 1)
        XCTAssertEqual(list.head?.next?.value, 1)
        XCTAssertEqual(list.tail?.value, 4)
    }
    
    func testRemoveAfterUntilEmpty() {
        // Given
        var list: LinkedList<Int> = [1,2,3,4,5]
        
        // When
        while list.head !== list.tail {
            list.remove(after: list.head!)
        }
        list.pop()
        
        // Then
        XCTAssertNil(list.head)
        XCTAssertNil(list.tail)
    }
    
    func testIndexEquality() {
        // Given
        let node = LinkedList<Int>.Node(value: 0)
        let index = LinkedList<Int>.Index(node: node)
        
        // When
        let otherIndex = LinkedList<Int>.Index(node: node)
        
        // Then
        XCTAssertEqual(index, otherIndex)
    }
    
    func testIndexComparableSameNode() {
        // Given
        let node = LinkedList<Int>.Node(value: 0)
        let index = LinkedList<Int>.Index(node: node)
        
        // When
        let otherIndex = LinkedList<Int>.Index(node: node)
        
        // Then
        XCTAssert((index < otherIndex) == false)
    }
    
    func testIndexComparableNodeNotInList() {
        // Given
        let node = LinkedList<Int>.Node(value: 0)
        let index = LinkedList<Int>.Index(node: node)
        
        // When
        let otherNode = LinkedList<Int>.Node(value: 1)
        let otherIndex = LinkedList<Int>.Index(node: otherNode)
        
        // Then
        XCTAssert((index < otherIndex) == false)
    }
    
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
    
    func testFindMiddle() {
        // Given
        var list = LinkedList<Int>()
        (1...3).forEach { list.append($0) }
        
        // When
        let middleNode = list.middle()
        
        // Then
        XCTAssertEqual(middleNode?.value, 2)
    }
    
    func testRemoveOccurrences() {
        // Given
        var list = LinkedList<Int>()
        [5,5,1,5,2,5,3,5,4,5].forEach { list.append($0) }
        
        // When
        list.remove(occurencesOf: 5)
        
        // Then
        XCTAssertEqual(list.head?.value, 1)
        XCTAssertEqual(list.tail?.value, 4)
        XCTAssertEqual(list.toArray(), [1, 2, 3, 4])
    }
}
