import Foundation

/// Autonomous flight controller with mission planning
public actor AutonomousController {
    private let connection: DroneConnection
    private var currentMission: Mission?
    private var isExecuting = false
    
    public init(connection: DroneConnection) {
        self.connection = connection
    }
    
    public func executeMission(_ mission: Mission) async throws {
        guard !isExecuting else {
            throw DroneError.commandFailed("Mission already executing")
        }
        
        isExecuting = true
        currentMission = mission
        
        print("🚁 Starting mission: \(mission.name)")
        
        for (index, waypoint) in mission.waypoints.enumerated() {
            print("📍 Waypoint \(index + 1)/\(mission.waypoints.count)")
            try await executeWaypoint(waypoint)
        }
        
        print("✅ Mission complete!")
        isExecuting = false
    }
    
    private func executeWaypoint(_ waypoint: Waypoint) async throws {
        switch waypoint.action {
        case .takeoff:
            _ = try await connection.sendCommand(.takeoff)
            try await Task.sleep(for: .seconds(3))
            
        case .land:
            _ = try await connection.sendCommand(.land)
            try await Task.sleep(for: .seconds(3))
            
        case .moveTo(let x, let y, let z, let speed):
            print("   Moving to (\(x), \(y), \(z)) at \(speed)cm/s")
            try await Task.sleep(for: .seconds(2))
            
        case .hover(let duration):
            print("   Hovering for \(duration)s")
            try await Task.sleep(for: .seconds(duration))
            
        case .rotate(let degrees):
            let command: DroneCommand = degrees > 0 ? .rotateClockwise : .rotateCounterClockwise
            _ = try await connection.sendCommand(command)
            try await Task.sleep(for: .seconds(1))
            
        case .capturePhoto:
            print("   📸 Capturing photo")
            try await Task.sleep(for: .milliseconds(500))
            
        case .startVideo:
            print("   🎥 Starting video")
            
        case .stopVideo:
            print("   ⏹️ Stopping video")
        }
    }
    
    public func emergencyStop() async throws {
        isExecuting = false
        currentMission = nil
        _ = try await connection.sendCommand(.emergency)
        print("🚨 Emergency stop!")
    }
}

public struct Mission: Sendable {
    public let name: String
    public let waypoints: [Waypoint]
    
    public init(name: String, waypoints: [Waypoint]) {
        self.name = name
        self.waypoints = waypoints
    }
}

public struct Waypoint: Sendable {
    public let action: WaypointAction
    
    public init(action: WaypointAction) {
        self.action = action
    }
}

public enum WaypointAction: Sendable {
    case takeoff
    case land
    case moveTo(x: Int, y: Int, z: Int, speed: Int)
    case hover(duration: Double)
    case rotate(degrees: Int)
    case capturePhoto
    case startVideo
    case stopVideo
}
