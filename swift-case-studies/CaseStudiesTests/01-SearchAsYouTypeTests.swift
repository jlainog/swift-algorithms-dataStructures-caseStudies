import XCTest
import Combine
import CombineSchedulers
@testable import CaseStudies

final class SearchAsYouTypeTests: XCTestCase {
    
    let testScheduler = DispatchQueue.testScheduler
    let testSubject = PassthroughSubject<[String], URLError>()
    var sut: SearchAsYouTypeViewModel!
    
    override func setUp() {
        sut = SearchAsYouTypeViewModel(
            dependencies: .init(
                searchClient: SearchClient(search: { _ in self.testSubject.eraseToAnyPublisher() } ),
                scheduler: testScheduler.eraseToAnyScheduler()
            )
        )
    }

    func testSearchTriggered() {
        sut.query = "fi"
        testScheduler.advance(by: .milliseconds(300))
        XCTAssertEqual(sut.results, [])
        XCTAssertFalse(sut.isRequestInFlight)
        
        sut.query = "fir"
        testScheduler.advance(by: .milliseconds(300))
        XCTAssertEqual(sut.results, [])
        XCTAssertTrue(sut.isRequestInFlight)
        
        testSubject.send(["fir"])
        testScheduler.advance()
        XCTAssertEqual(sut.results, ["fir"])
        XCTAssertFalse(sut.isRequestInFlight)
        
        sut.query = "f"
        testScheduler.advance(by: .milliseconds(300))
        XCTAssertEqual(sut.results, ["fir"])
        XCTAssertFalse(sut.isRequestInFlight)
    }
    
    func testRemoveDuplicates() {
        sut.query = "first"
        testScheduler.advance(by: .milliseconds(300))
        XCTAssertEqual(sut.results, [])
        XCTAssertTrue(sut.isRequestInFlight)

        testSubject.send(["first", ""])
        testScheduler.advance()
        XCTAssertEqual(sut.results, ["first", ""])
        XCTAssertFalse(sut.isRequestInFlight)
        
        sut.query = "first"
        testScheduler.advance(by: .milliseconds(300))
        XCTAssertEqual(sut.results, ["first", ""])
        XCTAssertFalse(sut.isRequestInFlight)
    }

    func testCancelInFlight() {
        sut = SearchAsYouTypeViewModel(
            dependencies: .init(
                searchClient: SearchClient(
                    search: {
                        AnyPublisher<[String], URLError>
                            .just([$0])
                            .delay(for: .milliseconds(500), scheduler: self.testScheduler)
                            .eraseToAnyPublisher()
                    }
                ),
                scheduler: testScheduler.eraseToAnyScheduler()
            )
        )
        
        sut.query = "first"
        testScheduler.advance(by: .milliseconds(300))
        XCTAssertEqual(sut.results, [])
        XCTAssertTrue(sut.isRequestInFlight)
        
        sut.query = "second"
        testScheduler.advance(by: .milliseconds(300))
        XCTAssertEqual(sut.results, [])
        XCTAssertTrue(sut.isRequestInFlight)
        
        testScheduler.advance(by: .milliseconds(500))
        XCTAssertEqual(sut.results, ["second"])
        XCTAssertFalse(sut.isRequestInFlight)
    }
}
