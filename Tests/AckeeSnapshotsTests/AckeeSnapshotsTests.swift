import Testing
@testable import AckeeSnapshots
import SwiftUI
import UIKit

// MARK: - Configure snapshot test settings

let snapshotTest = SnapshotTest(
    devices: [.iPhone13ProMax, .iPadMini],
    record: false,
    displayScale: 1,
    contentSizes: [.large, .accessibilityExtraExtraExtraLarge],
    colorSchemes: [.light, .dark]
)

// MARK: - Tests

@MainActor
struct AckeeSnapshotsTests {
    @Test("SwiftUI with multiple devices")
    func swiftUI_devices() {
        snapshotTest.devices(DemoSwiftUIView(), scrollViewMultiplier: 2)
    }

    @Test("SwiftUI component")
    func swiftUI_component() {
        snapshotTest.component(DemoSwiftUIView())
    }

    @Test("UIKit view component")
    func uiview_component() {
        let view = DemoView(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
        snapshotTest.component(view, testDynamicSize: false)
    }

    @Test("UIKit view on specific device")
    func uiview_device() {
        snapshotTest.device(DemoView(), device: .iPhoneXsMax)
    }

    @Test("UIKit view controller with multiple devices")
    func uiviewController_devices() {
        snapshotTest.devices(DemoViewController(), scrollViewMultiplier: 2)
    }
}

// MARK: - Helpers

// MARK: - Basic SwiftUI View for Testing

private struct DemoSwiftUIView: View {
    public init() {}
    public var body: some View {
        Text("Hello, SwiftUI!")
            .padding()
            .background(Color.yellow)
            .cornerRadius(8)
    }
}

// MARK: - Basic UIView for Testing

private class DemoView: UIView {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemGray2
        let label = UILabel()
        label.text = "Hello, UIView!"
        label.font = .preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Basic UIViewController for Testing

private class DemoViewController: UIViewController {
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray2

        let label = UILabel()
        label.text = "Hello, UIViewController!"
        label.textColor = .white
        label.font = .preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
