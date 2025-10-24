import Foundation
import XCTest

// Used for per-test assert snapshot counting
final class Counter {
    private var counts: [String: Int] = [:]
    private let lock = NSLock()

    func next(for key: String) -> Int {
        lock.lock()
        defer { lock.unlock() }
        counts[key, default: -1] += 1
        return counts[key]!
    }

    func reset() {
        lock.lock()
        defer { lock.unlock() }
        counts.removeAll()
    }
}

@MainActor
final class CleanCounterBetweenTestCases: NSObject { }

extension CleanCounterBetweenTestCases: XCTestObservation {
    // Reset timer between tests
    nonisolated func testCaseDidFinish(_ testCase: XCTestCase) {
        Task { @MainActor in
            snapshotCounter.reset()
        }
    }
}

extension CleanCounterBetweenTestCases {
    nonisolated static func registerIfNeeded() {
        _ = registrationToken
    }
    
    nonisolated private static let registrationToken: Void = {
        Task { @MainActor in
            XCTestObservationCenter.shared.addTestObserver(CleanCounterBetweenTestCases())
        }
    }()
}

// Singleton instance of the counter, like in Swift-snapshot-testing
@MainActor
let snapshotCounter = Counter()
