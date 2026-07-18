import XCTest

final class PlacesLauncherUITests: XCTestCase {
    private var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testOpensRetroSuggestionsAndReturnsHome() {
        let suggestions = app.buttons["Explore unusual places"]
        XCTAssertTrue(suggestions.waitForExistence(timeout: 5))
        suggestions.tap()

        XCTAssertTrue(app.staticTexts["SELECT A LEVEL"].waitForExistence(timeout: 3))
        XCTAssertTrue(
            app.buttons.matching(
                NSPredicate(format: "label CONTAINS %@", "SURPRISE ME")
            ).firstMatch.exists
        )
        XCTAssertTrue(app.buttons["BACK"].exists)
        keepScreenshot(named: "Suggestions")

        app.buttons["BACK"].tap()
        XCTAssertTrue(app.staticTexts["Places"].waitForExistence(timeout: 3))
    }

    func testOpensCustomMapPicker() {
        let chooseOnMap = app.buttons["Choose on Map"]
        XCTAssertTrue(chooseOnMap.waitForExistence(timeout: 5))
        chooseOnMap.tap()

        XCTAssertTrue(app.textFields["Search for a place"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.buttons["Open in Wikipedia"].exists)
        XCTAssertTrue(app.buttons["Cancel"].exists)
        keepScreenshot(named: "CustomMap")
    }

    private func keepScreenshot(named name: String) {
        let attachment = XCTAttachment(screenshot: XCUIScreen.main.screenshot())
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
