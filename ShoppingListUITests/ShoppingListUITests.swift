import XCTest

final class ShoppingListUITests: XCTestCase {
    @MainActor
    func testShoppingFlowAndScreenshots() {
        continueAfterFailure = false

        let app = XCUIApplication()
        app.launchArguments = ["-AppleLanguages", "(ru)", "-AppleLocale", "ru_RU"]
        app.launch()

        addPurchase(in: app, name: "  Молоко   ", captureForm: true)
        XCTAssertTrue(app.staticTexts["Молоко"].waitForExistence(timeout: 5))
        addPurchase(in: app, name: "Хлеб")
        addPurchase(in: app, name: "Батарейки", category: "Дом")

        let purchasedButton = app.buttons["togglePurchase-Батарейки"]
        XCTAssertTrue(purchasedButton.waitForExistence(timeout: 5))
        purchasedButton.tap()
        XCTAssertTrue(app.staticTexts["Осталось купить: 2"].waitForExistence(timeout: 5))
        capture("main", in: app)

        app.buttons["sortMenu"].tap()
        capture("sorting", in: app)
        app.buttons["По количеству"].tap()

        app.staticTexts["Молоко"].tap()
        XCTAssertTrue(app.navigationBars["Покупка"].waitForExistence(timeout: 5))
        capture("detail", in: app)

        let nameField = app.textFields["purchaseName"]
        XCTAssertEqual(nameField.value as? String, "Молоко")
        nameField.tap()
        nameField.typeText(String(repeating: XCUIKeyboardKey.delete.rawValue, count: 6) + "Кефир")
        app.buttons["savePurchase"].tap()
        XCTAssertTrue(app.staticTexts["Кефир"].waitForExistence(timeout: 5))

        app.terminate()
        app.launch()
        XCTAssertTrue(app.staticTexts["Кефир"].waitForExistence(timeout: 10))
        XCTAssertTrue(app.staticTexts["Осталось купить: 2"].exists)

        app.segmentedControls.buttons["Куплено"].tap()
        XCTAssertTrue(app.staticTexts["Батарейки"].waitForExistence(timeout: 5))
        XCTAssertFalse(app.staticTexts["Кефир"].exists)
        capture("filter", in: app)

        app.staticTexts["Батарейки"].swipeLeft()
        let deleteButton = app.buttons["Удалить"].exists
            ? app.buttons["Удалить"]
            : app.buttons["Delete"]
        XCTAssertTrue(deleteButton.waitForExistence(timeout: 5))
        deleteButton.tap()

        app.segmentedControls.buttons["Все"].tap()
        XCTAssertTrue(app.staticTexts["Кефир"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["Хлеб"].exists)
        XCTAssertFalse(app.staticTexts["Батарейки"].exists)
    }

    @MainActor
    private func addPurchase(
        in app: XCUIApplication,
        name: String,
        category: String? = nil,
        captureForm: Bool = false
    ) {
        XCTAssertTrue(app.buttons["Добавить"].waitForExistence(timeout: 10))
        app.buttons["Добавить"].tap()
        XCTAssertTrue(app.textFields["purchaseName"].waitForExistence(timeout: 5))
        XCTAssertFalse(app.buttons["savePurchase"].isEnabled)

        if captureForm {
            capture("add", in: app)
        }

        if let category {
            let picker = app.descendants(matching: .any)["purchaseCategory"].firstMatch
            XCTAssertTrue(picker.exists)
            picker.tap()
            XCTAssertTrue(app.staticTexts[category].waitForExistence(timeout: 5))
            capture("categories", in: app)
            app.staticTexts[category].tap()
            XCTAssertTrue(app.textFields["purchaseName"].waitForExistence(timeout: 5))
        }

        let field = app.textFields["purchaseName"]
        field.tap()
        field.typeText(name)
        XCTAssertTrue(app.buttons["savePurchase"].isEnabled)
        app.buttons["savePurchase"].tap()
        XCTAssertTrue(app.navigationBars["Покупки"].waitForExistence(timeout: 5))
    }

    @MainActor
    private func capture(_ name: String, in app: XCUIApplication) {
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
