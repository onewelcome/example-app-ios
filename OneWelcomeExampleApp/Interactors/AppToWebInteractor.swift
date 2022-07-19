//  Copyright © 2022 OneWelcome. All rights reserved.

protocol AppToWebInteractorProtocol {
    func appToWebSingleSignOn(completion:@escaping ((URL?, AppError?) -> ()))
}

class AppToWebInteractor: AppToWebInteractorProtocol {
    private let targetUrl = "https://demo-cim.onegini.com/personal/dashboard"
    private var userClient: UserClient {
        return SharedUserClient.instance
    }

    func appToWebSingleSignOn(completion:@escaping ((URL?, AppError?) -> ())) {
        guard let url = URL(string: targetUrl) else {
            completion(nil, nil)
            return
        }

        userClient.appToWebSingleSignOn(with: url) { url, token, error in
            if let error = error {
                let appError = ErrorMapper().mapError(error)
                completion(nil, appError)
            } else {
                completion(url, nil)
            }
        }
    }

}
