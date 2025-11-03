import XCTest
@testable import SwiftDJIDrone

final class DroneTests: XCTestCase {
    func testConnection() async throws {
        let connection = DroneConnection()
        
        try await connection.connect()
        let state = try await connection.getState()
        
        XCTAssertGreaterThan(state.battery, 0)
        XCTAssertGreaterThanOrEqual(state.gpsSignal, 0)
        
        await connection.disconnect()
    }
    
    func testSendCommand() async throws {
        let connection = DroneConnection()
        try await connection.connect()
        
        let response = try await connection.sendCommand(.takeoff)
        
        XCTAssertTrue(response.success)
        
        await connection.disconnect()
    }
    
    func testAutonomousMission() async throws {
        let connection = DroneConnection()
        try await connection.connect()
        
        let controller = AutonomousController(connection: connection)
        
        let mission = Mission(
            name: "Test Mission",
            waypoints: [
                Waypoint(action: .takeoff),
                Waypoint(action: .hover(duration: 1)),
                Waypoint(action: .land),
            ]
        )
        
        try await controller.executeMission(mission)
        
        await connection.disconnect()
    }
    
    func testVisionController() async throws {
        let vision = VisionController()
        
        let frame = VideoFrame(
            timestamp: Date(),
            width: 1920,
            height: 1080,
            data: Data()
        )
        
        let objects = await vision.detectObjects(in: frame)
        
        XCTAssertNotNil(objects)
    }
    
    func testSafetyController() async throws {
        let safety = SafetyController()
        
        let state = DroneState(
            battery: 10,
            altitude: 50,
            speed: 10,
            temperature: 25,
            isFlying: true,
            gpsSignal: 5
        )
        
        let shouldAbort = await safety.shouldAbortMission(state)
        
        XCTAssertTrue(shouldAbort)
    }
}
