import Foundation
import SwiftDJIDrone

@main
struct DroneCLI {
    static func main() async throws {
        print("🚁 Swift DJI Drone Controller")
        print("================================\n")
        
        let connection = DroneConnection()
        let controller = AutonomousController(connection: connection)
        let safety = SafetyController()
        
        // Connect to drone
        try await connection.connect()
        
        // Check state
        let state = try await connection.getState()
        print("📊 Drone State:")
        print("   Battery: \(state.battery)%")
        print("   GPS: \(state.gpsSignal) satellites")
        print("   Temperature: \(state.temperature)°C\n")
        
        // Create autonomous mission
        let mission = Mission(
            name: "Survey Mission",
            waypoints: [
                Waypoint(action: .takeoff),
                Waypoint(action: .hover(duration: 2)),
                Waypoint(action: .moveTo(x: 100, y: 0, z: 50, speed: 50)),
                Waypoint(action: .capturePhoto),
                Waypoint(action: .moveTo(x: 100, y: 100, z: 50, speed: 50)),
                Waypoint(action: .capturePhoto),
                Waypoint(action: .moveTo(x: 0, y: 100, z: 50, speed: 50)),
                Waypoint(action: .capturePhoto),
                Waypoint(action: .moveTo(x: 0, y: 0, z: 50, speed: 50)),
                Waypoint(action: .land),
            ]
        )
        
        // Execute mission
        try await controller.executeMission(mission)
        
        // Disconnect
        await connection.disconnect()
        
        print("\n✅ Mission complete!")
    }
}
