import CSSH2
import XCTest

class MyTest: XCTestCase {
    func testExample() {
        XCTAssert(libssh2_init(0) == 0);
        libssh2_exit();
    }
}
