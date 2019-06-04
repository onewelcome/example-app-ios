//  Copyright © 2019 Onegini. All rights reserved.

protocol AppToWebInteractorProtocol {
    func singleSignOn(completion:@escaping ((URL?, AppError?) -> ()))
}

class AppToWebInteractor: AppToWebInteractorProtocol {
    
    let targetUrl = "https://demo-cim.onegini.com/personal/dashboard"
    
    func singleSignOn(completion:@escaping ((URL?, AppError?) -> ())) {
        guard let url = URL(string: targetUrl) else {
            completion(nil, nil)
            return
        }
        ONGUserClient.sharedInstance().singleSignOn(withTargetUrl: url) { url, error in
            if let error = error {
                let appError = ErrorMapper().mapError(error)
                completion(nil, appError)
            } else {
                completion(url, nil)
            }
        }
    }

}
