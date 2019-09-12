//
// This source file is part of the EIMe project.
// Copyright © 2018 Monk. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showOkAlert(title: String, message: String = "") {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
