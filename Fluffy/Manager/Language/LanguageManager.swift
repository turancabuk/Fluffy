import Foundation
import SwiftUI

class LanguageManager: ObservableObject {
    
    static let shared = LanguageManager()
    
    @Published private(set) var locale: Locale
    @AppStorage("app_language") var currentLanguage: String = "en" {
        willSet {
            locale = Locale(identifier: newValue)
        }
        didSet {
            NotificationCenter.default.post(name: Notification.Name("LANGUAGE_CHANGED"), object: nil)
        }
    }
    
    private init() {
        // Başlangıç locale'ini ayarla
        self.locale = Locale(identifier: "en")
        
        // Sistem dilini kontrol et
        if let systemLanguage = Locale.current.language.languageCode?.identifier {
            if ["tr", "de"].contains(systemLanguage) && UserDefaults.standard.string(forKey: "app_language") == nil {
                self.currentLanguage = systemLanguage
            }
        }
    }
    
    // Dil seçenekleri için enum
    enum Language: String, CaseIterable {
        case english = "en"
        case turkish = "tr"
        case german = "de"
        
        var displayName: LocalizedStringKey {
            switch self {
            case .english: return "English"
            case .turkish: return "Türkçe"
            case .german: return "Deutsch"
            }
        }
    }
} 
