import XCTest
import Combine
import CombineSchedulers
@testable import CaseStudies

class CaseStudiesTests: XCTestCase {

  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }

  func testTextFieldModifiedShouldTriggerSearch() throws {
    let testSubject = PassthroughSubject<[String], Never>()
    let testScheduler = DispatchQueue.testScheduler

    var viewModel = SeachAsYouTypeViewModel(dependencies: .init(
      search: { (query) -> AnyPublisher<[String], Never> in
        testSubject.send([query])
        return testSubject.eraseToAnyPublisher()
      },
      mainQueue: testScheduler.eraseToAnyScheduler()
    ))
    viewModel.query = "911"
    testScheduler.advance()

    XCTAssertEqual(viewModel.results, ["911"])
  }
}
