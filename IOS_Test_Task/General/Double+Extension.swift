//
//  Double+Extension.swift
//  IOS_Test_Task
//
//  Created by Oleg Zakladnyi on 02.10.2024.
//

extension Double {
    
    func formatNumber() -> String {
        if self >= 1_000_000_000 {
           let formatted = String(format: "%.1f", self / 1_000_000_000).replacingOccurrences(of: ".0", with: "")
           return "\(formatted)B"
       } else if self >= 1_000_000 {
            let formatted = String(format: "%.1f", self / 1_000_000).replacingOccurrences(of: ".0", with: "")
            return "\(formatted)M"
        } else if self >= 1_000 {
            let formatted = String(format: "%.1f", self / 1_000).replacingOccurrences(of: ".0", with: "")
            return "\(formatted)k"
        } else {
            return "\(Int(self))"
        }
    }
}
