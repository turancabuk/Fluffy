//
//  LanguageManager.swift
//  Fluffy
//
//  Created by Turan Çabuk on 17.12.2024.
//

import Foundation
import SwiftUI

class LanguageManager: ObservableObject {
    static let shared = LanguageManager()
    
    @Published private(set) var locale: Locale
    @AppStorage("app_language") private var storedLanguage: String = ""
    
    var currentLanguage: String {
        get { storedLanguage }
        set {
            storedLanguage = newValue
            locale = Locale(identifier: newValue)
            NotificationCenter.default.post(name: Notification.Name("LANGUAGE_CHANGED"), object: nil)
        }
    }
    
    private init() {
        // Önce locale'i varsayılan değerle başlat
        self.locale = Locale(identifier: "en")
        
        // Sistem dilini al
        let systemLanguage = Locale.current.language.languageCode?.identifier ?? "en"
        let supportedLanguages = ["en", "tr", "de", "ru", "es", "it"]
        
        // Başlangıç dilini belirle
        if storedLanguage.isEmpty {
            // Eğer daha önce bir dil seçilmemişse, sistem dilini kontrol et
            let initialLanguage = supportedLanguages.contains(systemLanguage) ? systemLanguage : "en"
            storedLanguage = initialLanguage
            locale = Locale(identifier: initialLanguage)
        } else {
            // Daha önce seçilmiş dili kullan
            locale = Locale(identifier: storedLanguage)
        }
    }
    
    // Dil seçenekleri için enum
    enum Language: String, CaseIterable {
        case english = "en"
        case turkish = "tr"
        case german = "de"
        case russian = "ru"
        case spnish = "es"
        case italian = "it"
        
        var displayName: LocalizedStringKey {
            switch self {
            case .english: return "English"
            case .turkish: return "Türkçe"
            case .german: return "Deutsch"
            case .russian: return "Русский"
            case .spnish: return "Español"
            case .italian : return "Italiano"
            }
        }
    }
} 
