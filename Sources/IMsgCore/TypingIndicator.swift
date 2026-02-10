import Foundation

public struct TypingIndicator: Sendable {
  public static func startTyping(chatIdentifier: String) throws {
    try setTyping(chatIdentifier: chatIdentifier, isTyping: true)
  }

  public static func stopTyping(chatIdentifier: String) throws {
    try setTyping(chatIdentifier: chatIdentifier, isTyping: false)
  }

  public static func typeForDuration(chatIdentifier: String, duration: TimeInterval) async throws {
    try startTyping(chatIdentifier: chatIdentifier)
    defer { try? stopTyping(chatIdentifier: chatIdentifier) }
    try await Task.sleep(nanoseconds: UInt64(duration * 1_000_000_000))
  }

  private static func setTyping(chatIdentifier: String, isTyping: Bool) throws {
    try IMCoreBridge.ensureFrameworkLoaded()
    try IMCoreBridge.ensureDaemonConnection()
    let chat = try IMCoreBridge.lookupChat(identifier: chatIdentifier)
    try IMCoreBridge.setTyping(isTyping, in: chat)
  }
}
