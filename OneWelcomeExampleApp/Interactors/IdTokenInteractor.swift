// Copyright © 2024 OneWelcome. All rights reserved.

import UIKit

protocol IdTokenInteractorProtocol: AnyObject {
    func fetchIdToken() -> String
}

class IdTokenInteractor: IdTokenInteractorProtocol {
    weak var idTokenPresenter: IdTokenInteractorToPresenterProtocol?

    func fetchIdToken() -> String {
        let userClient = SharedUserClient.instance
        if let idToken = userClient.idToken {
            do {
                let jwtPayload = try decode(jwtToken: idToken)
                let data = try JSONSerialization.data(withJSONObject: jwtPayload, options: .prettyPrinted)
                guard let jsonString = String(data: data, encoding: .utf8) else {
                    return("Inavlid data")                    
                }
                return jsonString
            } catch {
                return "Some error occured: \(error)"
            }
        } else {
            return "No Id Token set."
        }
    }
}

private extension IdTokenInteractor {
    func decode(jwtToken jwt: String) throws -> [String: Any] {

        enum DecodeErrors: Error {
            case badToken
            case other
        }

        func base64Decode(_ base64: String) throws -> Data {
            let base64 = base64
                .replacingOccurrences(of: "-", with: "+")
                .replacingOccurrences(of: "_", with: "/")
            let padded = base64.padding(toLength: ((base64.count + 3) / 4) * 4, withPad: "=", startingAt: 0)
            guard let decoded = Data(base64Encoded: padded) else {
                throw DecodeErrors.badToken
            }
            return decoded
        }

        func decodeJWTPart(_ value: String) throws -> [String: Any] {
            let bodyData = try base64Decode(value)
            let json = try JSONSerialization.jsonObject(with: bodyData, options: [])
            guard let payload = json as? [String: Any] else {
                throw DecodeErrors.other
            }
            return payload
        }

        let segments = jwt.components(separatedBy: ".")
        return try decodeJWTPart(segments[1])
    }
}
