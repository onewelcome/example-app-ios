//  Copyright © 2024 OneWelcome. All rights reserved.

import Foundation

class IdTokenViewController: UIViewController {
    @IBOutlet weak private var textView: UITextView!
    
    @IBAction private func done() {
        dismiss(animated: true)
    }
    
    func updateIdToken(with token: String) {
        textView.text = token
    }
}
