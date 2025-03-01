//
//  LogManager.swift
//  Runner
//
//  Created by Mehmet Kadayıfçı on 19.02.2025.
//

import Foundation

/// Centralized logging manager for the application
class LogManager {
    // Shared instance for Singleton pattern
    static let shared = LogManager()
    
    // Debug logging flag - set to true to enable detailed logging
    private var isDebugLoggingEnabled: Bool = true
    
    // Private initializer for Singleton
    private init() {}
    
    /// Enable or disable debug logging
    func setDebugLogging(enabled: Bool) {
        isDebugLoggingEnabled = enabled
        print("[LogManager] Debug logging \(enabled ? "enabled" : "disabled")")
    }
    
    /// Log a debug message if debug logging is enabled
    /// - Parameters:
    ///   - message: The message to log
    ///   - component: The component that is logging the message
    func debug(_ message: String, component: String = "App") {
        if isDebugLoggingEnabled {
            print("[\(component)] \(message)")
        }
    }
    
    /// Log an info message (always shown)
    /// - Parameters:
    ///   - message: The message to log
    ///   - component: The component that is logging the message
    func info(_ message: String, component: String = "App") {
        print("[\(component)] \(message)")
    }
    
    /// Log an error message (always shown)
    /// - Parameters:
    ///   - message: The message to log
    ///   - component: The component that is logging the message
    func error(_ message: String, component: String = "App") {
        print("[ERROR][\(component)] \(message)")
    }
    
    /// Check if debug logging is enabled
    var isLoggingEnabled: Bool {
        return isDebugLoggingEnabled
    }
} 