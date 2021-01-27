//
//  SumTextFormatter.swift
//  AnyFormatKit
//
//  Created by Oleksandr Orlov on 10.11.2017.
//  Copyright © 2017 Oleksandr Orlov. All rights reserved.
//

import Foundation

open class SumTextFormatter: TextFormatter, TextUnformatter, TextNumberUnformatter {
    
    // MARK: - Dependencies
    
    public let numberFormatter: NumberFormatter
    
    // MARK: - Properties
    
    open var maximumIntegerCharacters: Int = 14 {
        didSet { numberFormatter.maximumIntegerDigits = maximumIntegerCharacters }
    }
    open var maximumDecimalCharacters: Int {
        return numberFormatter.maximumFractionDigits
    }
    open var suffix: String? {
        guard !numberFormatter.positiveSuffix.isEmpty else { return nil }
        return numberFormatter.positiveSuffix
    }
    open var prefix: String? {
        guard !numberFormatter.positivePrefix.isEmpty else { return nil }
        return numberFormatter.positivePrefix
    }
    open var groupingSeparator: String {
        return numberFormatter.groupingSeparator
    }
    open var decimalSeparator: String {
        return numberFormatter.decimalSeparator
    }
    open var groupingSize: Int {
        return numberFormatter.groupingSize
    }
    private let unformattedDecimalSeparator = "."
    private let negativePrefix = "-"
    
    // MARK: - Life cycle
    
    public init(numberFormatter: NumberFormatter) {
        self.numberFormatter = numberFormatter
    }
    
    public convenience init(textPattern: String, patternSymbol: Character = "#") {
        let formatParser = SumFormatParser()
        let result = formatParser.parse(format: textPattern, patternSymbol: patternSymbol)
        let numberFormatter = NumberFormatter()
        numberFormatter.positivePrefix = result.prefix
        numberFormatter.positiveSuffix = result.suffix
        numberFormatter.groupingSeparator = result.groupingSeparator
        numberFormatter.decimalSeparator = result.decimalSeparator
        numberFormatter.groupingSize = result.groupingSize
        numberFormatter.maximumFractionDigits = result.maximumFractionDigits
        numberFormatter.minimumIntegerDigits = 1
        numberFormatter.allowsFloats = true
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.roundingMode = .down
        numberFormatter.negativePrefix = result.prefix + "-"
        self.init(numberFormatter: numberFormatter)
    }
    
    // MARK: - TextFormatter
    
    open func format(_ unformatted: String?) -> String? {
        guard let unformatted = unformatted else { return nil }
        guard !unformatted.isEmpty else { return suffix ?? "" }
        guard unformatted != negativePrefix else { return negativePrefix }
        
        var correctedUnformatted = correctUnformatted(unformatted, decimalSeparator: unformattedDecimalSeparator)
        correctedUnformatted = correctUnformatted(correctedUnformatted, maximumIntegerDigits: maximumIntegerCharacters, decimalSeparator: unformattedDecimalSeparator, negativePrefix: negativePrefix)
        
        let number = NSDecimalNumber(string: correctedUnformatted)
        
        return numberFormatter.string(from: number)
    }
    
    // MARK: - TextUnformatter
    
    open func unformat(_ formatted: String?) -> String? {
        guard let formattedString = formatted else { return nil }
        let unformattedString = removeAllFormatSymbols(text: formattedString)
        return unformattedString
    }
    
    // MARK: - TextNumberUnformatter
    
    open func unformatNumber(_ formattedText: String?) -> NSNumber? {
        guard let formattedText = formattedText else { return nil }
        return numberFormatter.number(from: formattedText)
    }
    
    // MARK: - Correct unformatted
    
    private func correctUnformatted(_ unformatted: String, decimalSeparator: String) -> String {
        return unformatted.replacingOccurrences(of: ",", with: decimalSeparator)
    }
    
    private func correctUnformatted(_ unformatted: String, maximumIntegerDigits: Int, decimalSeparator: String, negativePrefix: String) -> String {
        let decimalPart = unformatted.sliceBefore(substring: decimalSeparator)
        let floatingPart = unformatted.sliceAfter(substring: decimalSeparator)
        let correctedDecimalPart = correctUnformattedDecimalPart(decimalPart, maximumIntegerDigits: maximumIntegerDigits, negativePrefix: negativePrefix)
        if unformatted.contains(decimalSeparator) {
            return correctedDecimalPart + decimalSeparator + floatingPart
        } else {
            return correctedDecimalPart
        }
    }
    
    private func correctUnformattedDecimalPart(_ decimalPart: String, maximumIntegerDigits: Int, negativePrefix: String) -> String {
        if !negativePrefix.isEmpty && decimalPart.contains(negativePrefix) {
            return decimalPart.leftSlice(limit: maximumIntegerDigits + negativePrefix.count)
        } else {
            return decimalPart.leftSlice(limit: maximumIntegerDigits)
        }
    }
    
    // MARK: - Remove all format symbols
    
    func removeAllFormatSymbols(text: String) -> String {
        var resultText = text
        if let prefix = prefix, !prefix.isEmpty {
            for prefixSymbol in prefix {
                resultText = resultText.removePrefix(String(prefixSymbol))
            }
        }
        if let suffix = suffix, !suffix.isEmpty {
            resultText = resultText.replacingOccurrences(of: suffix, with: "")
        }
        resultText = resultText.replacingOccurrences(of: groupingSeparator, with: "")
        return resultText
    }
}
