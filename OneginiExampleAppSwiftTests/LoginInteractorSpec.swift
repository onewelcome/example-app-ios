//  Copyright © 2018 Onegini. All rights reserved.

import Quick
import Nimble
@testable import OneginiSDKiOS
@testable import OneginiExampleAppSwift

class LoginInteractorSpec: QuickSpec {
    override func spec() {
        describe("LoginInteractor") {
            var loginInteractor : LoginInteractor!
            var loginPresenterStub : LoginPresenterStub!
            var userClientStub : ONGUserClientStub!
            beforeEach {
                userClientStub = ONGUserClientStub()
                loginPresenterStub = LoginPresenterStub()
                loginInteractor = LoginInteractor(userClient: ONGUserClientStub(), errorMapper: ErrorMapper(), loginEntity: LoginEntity())
                loginInteractor.delegate = loginPresenterStub
            }
            describe("userProfiles") {
                it("should return profile returned by ONGUserClient") {
                    let users = Array(arrayLiteral: UserProfileStub("profile1"), UserProfileStub("profile2"))
                    expect(loginInteractor.userProfiles()).to(equal(users))
                }
            }
            describe("authenticateUser", {
                it("should ask for PIN") {
                    loginInteractor.login(profile: UserProfileStub("profile1"))
                    expect(loginPresenterStub.presentPinViewCalled).toEventually(equal(true))
                    expect(loginPresenterStub.presentPinViewLoginEntity).toEventuallyNot(beNil())
                }
                context("when responded with valid PIN") {
                    beforeEach {
                        loginInteractor.login(profile: UserProfileStub("profile1"))
                        let sender = loginPresenterStub.presentPinViewLoginEntity?.pinChallenge?.sender as! PinChallengeSenderProtocol
                        sender.respond(withPin: userClientStub.validPin, challengeProtocol: (loginPresenterStub.presentPinViewLoginEntity?.pinChallenge)!)
                    }
                    it("should authenticate user") {
                        expect(loginPresenterStub.presentDashboardViewCalled).toEventually(equal(true))
                    }
                }
                context("when responded with valid PIN") {
                    beforeEach {
                        loginInteractor.login(profile: UserProfileStub("profile1"))
                        let sender = loginPresenterStub.presentPinViewLoginEntity?.pinChallenge?.sender as! PinChallengeSenderProtocol
                        sender.respond(withPin: userClientStub.invalidPin, challengeProtocol: (loginPresenterStub.presentPinViewLoginEntity?.pinChallenge)!)
                    }
                    it("should authenticate user") {
                        expect(loginPresenterStub.loginActionFailedCalled).toEventually(equal(true))
                    }
                }
            })
        }
    }
}
