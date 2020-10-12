import XCTest
@testable import Algorithms

final class BinarySearchTests: XCTestCase {
    let sut = (0..<1000)
    
    func testBinarySearch_canFindElement() {
        let index = sut.binarySearch(for: 501)!
        
        XCTAssertEqual(sut[index], 501)
    }
    
    func testBinarySearch_cannotFindElement() {
        let index = sut.binarySearch(for: 1001)
        
        XCTAssertNil(index)
    }
    
    func testBinarySearch_worksLikeIndexOf() {
        let value = 31
        let firstIndex = sut.firstIndex(of: value)
        let binarySeachIndex = sut.binarySearch(for: value)
        
        XCTAssertEqual(firstIndex, binarySeachIndex)
    }
    
    func testBinarySearchIndex_freeFunction() {
        let index = binarySearch(for: 30,
                                 in: [30,50,100,200])
        XCTAssertNotNil(index)
        XCTAssertEqual(index, 0)
    }
    
    func testBinarySearch_startIndex() {
        let index = startIndex(of: 3,
                               in: [1,2,3,3,3,4,5,5])
        XCTAssertNotNil(index)
        XCTAssertEqual(index, 2)
    }
    
    func testBinarySearch_endIndex() {
        let index = endIndex(of: 3,
                             in: [1,2,3,3,3,4,5,5])
        XCTAssertNotNil(index)
        XCTAssertEqual(index, 5)
    }
    
    func testBinarySearchFindIndeces_freeFunction() {
        let indices = findIndices(of: 3,
                                  in: [1,2,3,3,3,4,5,5])
        XCTAssertNotNil(indices)
        XCTAssertEqual(indices, 2..<5)
    }
}
