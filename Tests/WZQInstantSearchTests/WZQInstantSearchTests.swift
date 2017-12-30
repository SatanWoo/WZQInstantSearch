import XCTest
@testable import WZQInstantSearch

class WZQInstantSearchTests: XCTestCase {
    func testExample1() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        let texts = ["Moon is fast!", "Slash is fast also!", "Spark is fast too!", "Is Wade fast?"]
        
        let wzq = WZQInstantSearch(text: texts)
        let ret = wzq.search(query: "Fast S")
        
        XCTAssertEqual(ret[0], "Spark is fast too!")
    }
    
    func testExample2() {
        let texts = ["An ApPle a day keeps doctor away", "I'm handsome", "We're Hiring"]
        
        let wzq = WZQInstantSearch(text: texts)
        let ret = wzq.search(query: "app")
        
        XCTAssertEqual(ret[0], "An ApPle a day keeps doctor away")
    }

    func testExample3() {
        let texts = ["An ApPle a day keeps doctor away", "I'm handsome", "We're Hiring"]
        
        let wzq = WZQInstantSearch(text: texts)
        let ret = wzq.search(query: "aapp")
        
        // Nothing Found
        XCTAssertEqual(ret.count, 0)
    }

    static var allTests = [
        ("testExample1", testExample1),
        ("testExample2", testExample2),
        ("testExample3", testExample3),
    ]
}
