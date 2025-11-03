# 🚁 Swift DJI Drone Controller

Open-source Swift package for autonomous DJI drone flight control.

## ✨ Features

### Core Functionality
- **Drone Connection** - UDP/TCP communication with DJI drones
- **Command Execution** - Send flight commands
- **State Monitoring** - Real-time telemetry
- **Autonomous Missions** - Waypoint-based flight plans

### Advanced Features
- **Computer Vision** - Object detection and tracking
- **Safety Controller** - Automatic safety checks
- **Mission Planning** - Complex flight paths
- **Actor-based** - Thread-safe Swift 6.0

## 🚀 Quick Start

### Installation

```swift
dependencies: [
    .package(url: "https://github.com/durellwilson/swift-dji-drone.git", from: "1.0.0")
]
```

### Basic Usage

```swift
import SwiftDJIDrone

// Connect to drone
let connection = DroneConnection(host: "192.168.10.1", port: 8889)
try await connection.connect()

// Check state
let state = try await connection.getState()
print("Battery: \(state.battery)%")

// Send command
let response = try await connection.sendCommand(.takeoff)
```

### Autonomous Mission

```swift
let controller = AutonomousController(connection: connection)

let mission = Mission(
    name: "Survey Mission",
    waypoints: [
        Waypoint(action: .takeoff),
        Waypoint(action: .moveTo(x: 100, y: 0, z: 50, speed: 50)),
        Waypoint(action: .capturePhoto),
        Waypoint(action: .land),
    ]
)

try await controller.executeMission(mission)
```

### Computer Vision

```swift
let vision = VisionController()

let objects = await vision.detectObjects(in: frame)
for object in objects {
    print("\(object.label): \(object.confidence)")
}
```

### Safety Monitoring

```swift
let safety = SafetyController()

// Start monitoring
Task {
    await safety.startMonitoring(connection: connection)
}

// Check if safe to continue
if await safety.shouldAbortMission(state) {
    try await controller.emergencyStop()
}
```

## 🎯 Use Cases

### Autonomous Inspection
```swift
let mission = Mission(
    name: "Building Inspection",
    waypoints: [
        Waypoint(action: .takeoff),
        Waypoint(action: .moveTo(x: 0, y: 0, z: 100, speed: 30)),
        Waypoint(action: .startVideo),
        Waypoint(action: .moveTo(x: 200, y: 0, z: 100, speed: 20)),
        Waypoint(action: .moveTo(x: 200, y: 200, z: 100, speed: 20)),
        Waypoint(action: .stopVideo),
        Waypoint(action: .land),
    ]
)
```

### Object Tracking
```swift
let vision = VisionController()

while tracking {
    let objects = await vision.detectObjects(in: currentFrame)
    
    if let target = objects.first(where: { $0.label == "person" }) {
        let tracking = await vision.trackObject(target)
        
        // Adjust drone position to follow
        try await connection.sendCommand(.moveTo(
            x: Int(tracking.position.x),
            y: Int(tracking.position.y),
            z: Int(tracking.position.z)
        ))
    }
}
```

### Aerial Photography
```swift
let mission = Mission(
    name: "Aerial Photography",
    waypoints: [
        Waypoint(action: .takeoff),
        Waypoint(action: .moveTo(x: 0, y: 0, z: 150, speed: 30)),
        Waypoint(action: .rotate(degrees: 360)),
        Waypoint(action: .capturePhoto),
        Waypoint(action: .moveTo(x: 100, y: 100, z: 150, speed: 30)),
        Waypoint(action: .capturePhoto),
        Waypoint(action: .land),
    ]
)
```

## 🏗️ Architecture

### Actor-Based Concurrency
```swift
public actor DroneConnection {
    // Thread-safe drone communication
}

public actor AutonomousController {
    // Thread-safe mission execution
}

public actor VisionController {
    // Thread-safe computer vision
}
```

### Type-Safe Commands
```swift
public enum DroneCommand: String {
    case takeoff
    case land
    case forward
    case back
    // ...
}
```

### Sendable Types
All types conform to `Sendable` for Swift 6 strict concurrency.

## 🧪 Testing

```bash
swift test
```

Tests include:
- Connection management
- Command execution
- Autonomous missions
- Computer vision
- Safety checks

## 📡 DJI SDK Integration

### Tello Protocol
Compatible with DJI Tello drones using UDP protocol:
- Command port: 8889
- State port: 8890
- Video port: 11111

### DJI Mobile SDK
Can be extended to work with DJI Mobile SDK:
```swift
// Bridge to DJI Mobile SDK
extension DroneConnection {
    func connectDJISDK() async throws {
        // Initialize DJI SDK
        // Register app
        // Connect to aircraft
    }
}
```

## 🔧 CLI Tool

```bash
# Build CLI
swift build -c release

# Run autonomous mission
.build/release/drone-cli

# Output:
# 🚁 Swift DJI Drone Controller
# ✅ Connected to drone
# 📊 Battery: 85%
# 🚁 Starting mission: Survey Mission
# 📍 Waypoint 1/10
# ✅ Mission complete!
```

## 🌟 Advanced Features

### Obstacle Avoidance
```swift
let obstacles = await vision.detectObstacles(in: frame)

for obstacle in obstacles {
    if obstacle.distance < 2.0 {
        // Stop and reroute
        try await controller.emergencyStop()
    }
}
```

### GPS Waypoint Navigation
```swift
struct GPSWaypoint {
    let latitude: Double
    let longitude: Double
    let altitude: Double
}

extension AutonomousController {
    func navigateToGPS(_ waypoint: GPSWaypoint) async throws {
        // Convert GPS to relative coordinates
        // Navigate to position
    }
}
```

### Real-Time Video Streaming
```swift
actor VideoStream {
    func startStream() async throws {
        // Connect to video port 11111
        // Decode H.264 stream
        // Process frames
    }
}
```

## 📊 Telemetry

```swift
public struct DroneState: Sendable {
    public let battery: Int          // 0-100%
    public let altitude: Double      // meters
    public let speed: Double         // m/s
    public let temperature: Int      // celsius
    public let isFlying: Bool
    public let gpsSignal: Int        // 0-5 satellites
}
```

## 🔐 Safety Features

- **Battery monitoring** - Auto-land at 15%
- **GPS signal check** - Abort if < 2 satellites
- **Temperature monitoring** - Alert at 60°C
- **Emergency stop** - Immediate motor cutoff
- **Geofencing** - Stay within boundaries
- **Collision avoidance** - Detect obstacles

## 🎓 Examples

See `Examples/` directory for:
- Basic flight control
- Autonomous missions
- Computer vision tracking
- Safety monitoring
- Video streaming

## 📱 Platform Support

- ✅ iOS 18+
- ✅ macOS 15+
- ✅ Swift 6.0
- ✅ Actor concurrency

## 🤝 Contributing

1. Fork repository
2. Create feature branch
3. Add tests
4. Submit PR

## 📄 License

MIT License - Open source for Detroit community

## 🔗 Resources

- [DJI Tello SDK](https://dl-cdn.ryzerobotics.com/downloads/Tello/Tello%20SDK%202.0%20User%20Guide.pdf)
- [DJI Mobile SDK](https://developer.dji.com/mobile-sdk/)
- [Swift Concurrency](https://docs.swift.org/swift-book/LanguageGuide/Concurrency.html)

---

**Built with ❤️ for autonomous drone flight in Swift**
