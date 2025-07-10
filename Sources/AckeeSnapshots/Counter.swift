import Foundation
import XCTest

// Used for per-test assert snapshot counting
final class Counter {
    private var counts: [String: Int] = [:]
    private let lock = NSLock()

    func next(for key: String) -> Int {
        lock.lock()
        defer { lock.unlock() }
        counts[key, default: 0] += 1
        return counts[key]!
    }

    func reset() {
        lock.lock()
        defer { lock.unlock() }
        counts.removeAll()
    }
}

/// Reset timer between tests
class CleanCounterBetweenTestCases: NSObject, XCTestObservation {
    private static var registered = false

    static func registerIfNeeded() {
        guard !registered else { return }
        defer { registered = true }
        Task {@MainActor in
            XCTestObservationCenter.shared.addTestObserver(CleanCounterBetweenTestCases())
        }
    }

    func testCaseDidFinish(_ testCase: XCTestCase) {
        snapshotCounter.reset()
    }
}

// Singleton instance of the counter, like in Swift-snapshot-testing
let snapshotCounter = Counter()
