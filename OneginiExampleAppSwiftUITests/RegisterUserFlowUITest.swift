//
// Copyright (c) 2020 Onegini. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import Quick
import Nimble

class RegisterUserFlowUITest: QuickSpec {
    
    let pinLength = 5
    let longTimeout = TimeInterval(15)
    let shortTimeout = TimeInterval(2)
    let email = "username@test.com"
    let password = "password"
    
    /**
        If there are any users registered, app will load with select profile screen and will select first user by default.
        After user gets disconnected, when we go back to welcome screen, it wil show select profile screen and
        select first user if there are any registered. If not, it will open up sign up screen (without "Select profile" text visible
     */
    func disconnectSelectedUser(app: XCUIApplication) {
        let selectProfileLabel = app.staticTexts["selectProfile"]
        let signUpButton = app.buttons["Sign Up"]
        // we quickly check if there is a sign up button and if not, we wait longer for the select profile label
        if (!signUpButton.waitForExistence(timeout: shortTimeout) && selectProfileLabel.waitForExistence(timeout: longTimeout)) {
             app.buttons["loginButton"].tap()
            let createPinCodeLabel = app.staticTexts["Please enter your PIN code"]
            if (createPinCodeLabel.waitForExistence(timeout: shortTimeout)) {
                app.buttons["zeroButton"].tap(withNumberOfTaps: pinLength, numberOfTouches: pinLength)
                let profileButton = app.buttons["profileButton"]
                if (profileButton.waitForExistence(timeout: shortTimeout)) {
                    profileButton.tap()
                    let disconnectProfileButton = app.buttons["disconnectProfileButton"]
                    if (disconnectProfileButton.waitForExistence(timeout: shortTimeout)) {
                        disconnectProfileButton.tap()
                        let disconnectButton = app.alerts.buttons["Disconnect"]
                        if (disconnectButton.waitForExistence(timeout: shortTimeout)) {
                            disconnectButton.tap()
                            disconnectSelectedUser(app: app)
                        }
                    }
                }
            }
        }
    }
    
    func inputEmailAndPasswordAndTapLoginButton(emailTextField: XCUIElement, passwordSecureTextField: XCUIElement, loginButton:XCUIElement) {
        emailTextField.tap()
        emailTextField.typeText(email)
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText(password + "\n")
        loginButton.tap()
    }
    
    func inputPIN(app: XCUIApplication) {
        app.buttons["zeroButton"].tap(withNumberOfTaps: self.pinLength, numberOfTouches: self.pinLength)
    }
    
    override func spec() {
        describe("register user") {
            let app = XCUIApplication()
            beforeSuite {
                Springboard.deleteApp(appName: "OneginiExampleAppSwift")
            }
            beforeEach {
                app.launch()
                self.disconnectSelectedUser(app: app)
            }
            afterEach {
                app.terminate()
            }
            context("when no user is not registered") {
                let signUpButton = app.buttons["Sign Up"]
                it("should show welcome view on sign up page") {
                    let signUpButtonExists = signUpButton.waitForExistence(timeout: self.longTimeout)
                    expect(signUpButtonExists).to(beTrue())
                }
                context("when user taps Sign Up button") {
                    let emailTextField = app.webViews.element.textFields.element
                    let passwordSecureTextField = app.webViews.element.secureTextFields.element
                    let loginButton = app.webViews.element.buttons["Inloggen"]
                    it("should load web view with registration") {
                        signUpButton.tap()
                        _ = loginButton.waitForExistence(timeout: self.longTimeout)
                        expect(emailTextField.exists).to(beTrue())
                        expect(passwordSecureTextField.exists).to(beTrue())
                        expect(loginButton.exists).to(beTrue())
                    }
                    context("when user inputs email and password") {
                        context("when email and password are valid") {
                            let createPinCodeLabel = app.staticTexts["Please create your PIN code"]
                            beforeEach {
                                signUpButton.tap()
                                _ = loginButton.waitForExistence(timeout: self.longTimeout)
                            }
                            it("should load create PIN view") {
                                self.inputEmailAndPasswordAndTapLoginButton(emailTextField: emailTextField, passwordSecureTextField: passwordSecureTextField, loginButton: loginButton)
                                let createPinCodeLabelExists = createPinCodeLabel.waitForExistence(timeout: self.longTimeout)
                                expect(createPinCodeLabelExists).to(beTrue())
                            }
                            context("when user inputs new PIN") {
                                let confirmPinCodeLabel = app.staticTexts["Please confirm your PIN code"]
                                beforeEach {
                                    self.inputEmailAndPasswordAndTapLoginButton(emailTextField: emailTextField, passwordSecureTextField: passwordSecureTextField, loginButton: loginButton)
                                    _ = createPinCodeLabel.waitForExistence(timeout: self.longTimeout)
                                }
                                it("should load confirm PIN view") {
                                    self.inputPIN(app: app)
                                    let confirmPinCodeLabelExists = confirmPinCodeLabel.waitForExistence(timeout: self.shortTimeout)
                                    expect(confirmPinCodeLabelExists).to(beTrue())
                                }
                                context("when user confirms PIN") {
                                    let dashboardTitleLabel = app.staticTexts["Dashboard"]
                                    beforeEach {
                                        self.inputPIN(app: app)
                                        _ = confirmPinCodeLabel.waitForExistence(timeout: self.shortTimeout)
                                    }
                                    it("should load dashboard view") {
                                        self.inputPIN(app: app)
                                        let dashboardTitleLabelExists = dashboardTitleLabel.waitForExistence(timeout: self.shortTimeout)
                                        expect(dashboardTitleLabelExists).to(beTrue())
                                    }
                                }
                            }
                        }
                        context("when email is not valid") {
                            let invalidEmailLabel = app.staticTexts["Dit e-mailadres is niet geldig"]
                            beforeEach {
                                signUpButton.tap()
                                _ = loginButton.waitForExistence(timeout: self.longTimeout)
                            }
                            it("should show error about invalid email") {
                                emailTextField.tap()
                                emailTextField.typeText("notanemail")
                                passwordSecureTextField.tap()
                                let invalidEmailLabelExists = invalidEmailLabel.waitForExistence(timeout: self.shortTimeout)
                                expect(invalidEmailLabelExists).to(beTrue())
                            }
                        }
                    }
                }
            }
        }
    }
}
