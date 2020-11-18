import XCTest
import Combine
import CombineSchedulers
@testable import CaseStudies

class CaseStudiesTests: XCTestCase {
  let testSubject = PassthroughSubject<[String], Never>()
  let testScheduler = DispatchQueue.testScheduler
  var viewModel: SeachAsYouTypeViewModel!
  
  override func setUpWithError() throws {
    viewModel = SeachAsYouTypeViewModel(dependencies: .init(
      search: { (query) -> AnyPublisher<[String], Never> in
        return self.testSubject.eraseToAnyPublisher()
      },
      mainQueue: testScheduler.eraseToAnyScheduler()
    ))
  }
  
  override func tearDownWithError() throws {
    viewModel = nil
    
  }
  
  func testTextFieldModifiedShouldTriggerSearch() throws {
    viewModel.query = "911"
    let expectedResponse = ["Porshe"]
    testScheduler.advance(by: .milliseconds(300))
    testSubject.send(expectedResponse)
    testScheduler.advance()
    
    XCTAssertEqual(viewModel.results, expectedResponse)
  }
  
  func testTextFieldModifiedShouldStartAfterThreeCharacters() throws {
    viewModel.query = "A"
    testScheduler.advance(by: .milliseconds(300))
    testSubject.send([""])
    testScheduler.advance()
    
    XCTAssertEqual(viewModel.results, [])
    XCTAssertFalse(viewModel.isSearching)
    
    viewModel.query = "AB"
    testScheduler.advance(by: .milliseconds(300))
    testSubject.send([""])
    testScheduler.advance()
    
    XCTAssertEqual(viewModel.results, [])
    XCTAssertFalse(viewModel.isSearching)
    
    let expectedResponse = ["Hello subject"]
    viewModel.query = "ABC"
    testScheduler.advance(by: .milliseconds(300))
    XCTAssertTrue(viewModel.isSearching)
    
    testSubject.send(expectedResponse)
    testScheduler.advance()
    
    XCTAssertEqual(viewModel.results, expectedResponse)
    XCTAssertFalse(viewModel.isSearching)
  }
  
  func testRemoveDuplicates() {
    let expectedResult = ["iPhone 5s"]
    viewModel.query = "iPhone iPhone"
    testScheduler.advance(by: .milliseconds(300))
    XCTAssertTrue(viewModel.isSearching)
    
    testSubject.send(expectedResult)
    testScheduler.advance()
    
    XCTAssertEqual(viewModel.results, expectedResult)
    
    viewModel.query = "iPhone iPhone"
    
    XCTAssertFalse(viewModel.isSearching)
  }
  
  func testIntegration() {
    viewModel.query = "Hello query"
    
    testScheduler.advance(by: .milliseconds(299))
    
    XCTAssertFalse(viewModel.isSearching)
    
    viewModel.query = "Hello"
    
    testScheduler.advance(by: .milliseconds(1))
    
    XCTAssertFalse(viewModel.isSearching)
    
    testScheduler.advance(by: .milliseconds(299))
    
    XCTAssertTrue(viewModel.isSearching)
  }
}
