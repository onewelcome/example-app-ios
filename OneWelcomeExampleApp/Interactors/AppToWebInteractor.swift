//  Copyright © 2022 OneWelcome. All rights reserved.

protocol AppToWebInteractorProtocol {
    func appToWebSingleSignOn(completion: @escaping ((URL?, AppError?) -> Void))
}

class AppToWebInteractor: AppToWebInteractorProtocol {
    private let targetUrl = "https://login-mobile.in.test.onewelcome.net/personal/dashboard/"
    private var userClient: UserClient {
        return SharedUserClient.instance
    }

    func appToWebSingleSignOn(completion: @escaping ((URL?, AppError?) -> Void)) {
        guard let url = URL(string: targetUrl) else {
            completion(nil, nil)
            return
        }

        userClient.appToWebSingleSignOn(with: url) { url, _, error in
            if let error = error {
                let appError = ErrorMapper().mapError(error)
                completion(nil, appError)
            } else {
                completion(url, nil)
            }
        }
    }

}
