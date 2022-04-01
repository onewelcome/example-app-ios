//  Copyright © 2019 Onegini. All rights reserved.

protocol AppToWebInteractorProtocol {
    func appToWebSingleSignOn(completion:@escaping ((URL?, AppError?) -> ()))
}

class AppToWebInteractor: AppToWebInteractorProtocol {
    let targetUrl = "https://demo-cim.onegini.com/personal/dashboard"
    private let userClient: UserClient = sharedUserClient() //TODO: pass in init

    func appToWebSingleSignOn(completion:@escaping ((URL?, AppError?) -> ())) {
        guard let url = URL(string: targetUrl) else {
            completion(nil, nil)
            return
        }
        userClient.appToWebSingleSignOn(targetUrl: url) { url, token, error in
            if let error = error {
                let appError = ErrorMapper().mapError(error)
                completion(nil, appError)
            } else {
                completion(url, nil)
            }
        }
    }

}
