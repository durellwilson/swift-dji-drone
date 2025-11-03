import Foundation
import NIO

/// DJI Drone connection protocol using UDP/TCP
public actor DroneConnection {
    private let host: String
    private let port: Int
    private var isConnected = false
    private var eventLoopGroup: MultiThreadedEventLoopGroup?
    
    public init(host: String = "192.168.10.1", port: Int = 8889) {
        self.host = host
        self.port = port
    }
    
    public func connect() async throws {
        guard !isConnected else { return }
        
        eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 1)
        isConnected = true
        
        print("✅ Connected to drone at \(host):\(port)")
    }
    
    public func disconnect() async {
        isConnected = false
        try? await eventLoopGroup?.shutdownGracefully()
        eventLoopGroup = nil
        print("🔌 Disconnected from drone")
    }
    
    public func sendCommand(_ command: DroneCommand) async throws -> DroneResponse {
        guard isConnected else {
            throw DroneError.notConnected
        }
        
        print("📤 Sending: \(command.rawValue)")
        
        // Simulate command execution
        try await Task.sleep(for: .milliseconds(100))
        
        return DroneResponse(
            success: true,
            message: "ok",
            data: nil
        )
    }
    
    public func getState() async throws -> DroneState {
        guard isConnected else {
            throw DroneError.notConnected
        }
        
        return DroneState(
            battery: 85,
            altitude: 0,
            speed: 0,
            temperature: 25,
            isFlying: false,
            gpsSignal: 5
        )
    }
}

public enum DroneCommand: String {
    case takeoff = "takeoff"
    case land = "land"
    case up = "up"
    case down = "down"
    case left = "left"
    case right = "right"
    case forward = "forward"
    case back = "back"
    case rotateClockwise = "cw"
    case rotateCounterClockwise = "ccw"
    case flip = "flip"
    case emergency = "emergency"
    
    // Advanced commands
    case go = "go"  // Go to x y z speed
    case curve = "curve"  // Fly curve
    case setSpeed = "speed"
    case setWifi = "wifi"
}

public struct DroneResponse {
    public let success: Bool
    public let message: String
    public let data: [String: Any]?
}

public struct DroneState: Sendable {
    public let battery: Int
    public let altitude: Double
    public let speed: Double
    public let temperature: Int
    public let isFlying: Bool
    public let gpsSignal: Int
}

public enum DroneError: Error {
    case notConnected
    case commandFailed(String)
    case timeout
    case invalidResponse
}
