import Foundation

/// Safety controller for autonomous flight
public actor SafetyController {
    private var safetyChecks: [SafetyCheck] = []
    private var isMonitoring = false
    
    public init() {
        setupDefaultChecks()
    }
    
    private func setupDefaultChecks() {
        safetyChecks = [
            SafetyCheck(name: "Battery", threshold: 20, critical: true),
            SafetyCheck(name: "GPS Signal", threshold: 3, critical: true),
            SafetyCheck(name: "Altitude", threshold: 120, critical: false),
            SafetyCheck(name: "Temperature", threshold: 60, critical: false),
        ]
    }
    
    public func startMonitoring(connection: DroneConnection) async {
        isMonitoring = true
        
        while isMonitoring {
            let state = try? await connection.getState()
            
            if let state = state {
                await checkSafety(state)
            }
            
            try? await Task.sleep(for: .seconds(1))
        }
    }
    
    public func stopMonitoring() {
        isMonitoring = false
    }
    
    private func checkSafety(_ state: DroneState) async {
        // Battery check
        if state.battery < 20 {
            print("⚠️ Low battery: \(state.battery)%")
        }
        
        // GPS check
        if state.gpsSignal < 3 {
            print("⚠️ Weak GPS signal: \(state.gpsSignal)")
        }
        
        // Temperature check
        if state.temperature > 60 {
            print("⚠️ High temperature: \(state.temperature)°C")
        }
    }
    
    public func shouldAbortMission(_ state: DroneState) -> Bool {
        state.battery < 15 || state.gpsSignal < 2
    }
}

public struct SafetyCheck {
    let name: String
    let threshold: Int
    let critical: Bool
}
