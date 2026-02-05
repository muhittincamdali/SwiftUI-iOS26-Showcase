// MARK: - Chart3DDemo.swift
// iOS 26 3D Charts with Swift Charts
// Created by Muhittin Camdali

import SwiftUI
import Charts

// MARK: - Chart3D Showcase

@available(iOS 26.0, macOS 26.0, *)
public struct Chart3DShowcase: View {
    @State private var selectedChartType: Chart3DType = .surface
    @State private var rotationX: Double = 15
    @State private var rotationY: Double = 45
    @State private var showGrid = true
    @State private var showLabels = true
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Chart Type Picker
                    Picker("Chart Type", selection: $selectedChartType) {
                        ForEach(Chart3DType.allCases) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                    
                    // 3D Chart
                    chartView
                        .frame(height: 400)
                        .padding()
                    
                    // Controls
                    controlsSection
                    
                    // Code Example
                    codeExampleSection
                }
            }
            .navigationTitle("3D Charts")
        }
    }
    
    @ViewBuilder
    private var chartView: some View {
        switch selectedChartType {
        case .surface:
            SurfacePlotDemo(rotationX: rotationX, rotationY: rotationY, showGrid: showGrid)
        case .scatter:
            Scatter3DDemo(rotationX: rotationX, rotationY: rotationY)
        case .bar:
            Bar3DDemo(rotationX: rotationX, rotationY: rotationY)
        }
    }
    
    private var controlsSection: some View {
        VStack(spacing: 16) {
            Text("Controls")
                .font(.headline)
            
            VStack(spacing: 12) {
                HStack {
                    Text("Rotation X")
                        .frame(width: 80, alignment: .leading)
                    Slider(value: $rotationX, in: -90...90)
                    Text("\(Int(rotationX))°")
                        .frame(width: 40)
                }
                
                HStack {
                    Text("Rotation Y")
                        .frame(width: 80, alignment: .leading)
                    Slider(value: $rotationY, in: 0...360)
                    Text("\(Int(rotationY))°")
                        .frame(width: 40)
                }
                
                Toggle("Show Grid", isOn: $showGrid)
                Toggle("Show Labels", isOn: $showLabels)
            }
            .padding()
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .padding(.horizontal)
    }
    
    private var codeExampleSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Code Example")
                .font(.headline)
            
            Text("""
            // iOS 26 3D Surface Plot
            Chart3D {
                SurfacePlot(data: surfaceData) { point in
                    SurfaceMark(
                        x: .value("X", point.x),
                        y: .value("Y", point.y),
                        z: .value("Z", point.z)
                    )
                    .foregroundStyle(by: .value("Height", point.z))
                }
            }
            .chart3DRotation(x: .degrees(15), y: .degrees(45))
            .chart3DScale(1.2)
            .chartLegend(.visible)
            """)
            .font(.system(.caption, design: .monospaced))
            .padding()
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .padding(.horizontal)
    }
}

// MARK: - Chart3D Types

enum Chart3DType: String, CaseIterable, Identifiable {
    case surface = "Surface"
    case scatter = "Scatter"
    case bar = "3D Bar"
    
    var id: String { rawValue }
}

// MARK: - Surface Plot Demo

@available(iOS 26.0, *)
struct SurfacePlotDemo: View {
    let rotationX: Double
    let rotationY: Double
    let showGrid: Bool
    
    var body: some View {
        ZStack {
            // 3D Surface visualization
            GeometryReader { geometry in
                Canvas { context, size in
                    let centerX = size.width / 2
                    let centerY = size.height / 2
                    let scale: CGFloat = min(size.width, size.height) / 3
                    
                    // Draw grid
                    if showGrid {
                        drawGrid(context: context, center: CGPoint(x: centerX, y: centerY), scale: scale)
                    }
                    
                    // Draw surface
                    drawSurface(context: context, center: CGPoint(x: centerX, y: centerY), scale: scale)
                }
            }
            
            // Labels
            VStack {
                Spacer()
                HStack {
                    Text("X axis")
                        .font(.caption)
                        .foregroundStyle(.red)
                    Spacer()
                    Text("Y axis")
                        .font(.caption)
                        .foregroundStyle(.green)
                }
                .padding()
            }
        }
        .background(
            LinearGradient(
                colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private func drawGrid(context: GraphicsContext, center: CGPoint, scale: CGFloat) {
        var path = Path()
        
        // Draw grid lines
        for i in stride(from: -1.0, through: 1.0, by: 0.25) {
            let y1 = center.y + CGFloat(i) * scale * 0.5
            path.move(to: CGPoint(x: center.x - scale, y: y1))
            path.addLine(to: CGPoint(x: center.x + scale, y: y1))
            
            let x1 = center.x + CGFloat(i) * scale
            path.move(to: CGPoint(x: x1, y: center.y - scale * 0.5))
            path.addLine(to: CGPoint(x: x1, y: center.y + scale * 0.5))
        }
        
        context.stroke(path, with: .color(.gray.opacity(0.3)), lineWidth: 0.5)
    }
    
    private func drawSurface(context: GraphicsContext, center: CGPoint, scale: CGFloat) {
        // Create gradient surface
        let resolution = 20
        
        for i in 0..<resolution {
            for j in 0..<resolution {
                let x = Double(i - resolution/2) / Double(resolution/2)
                let y = Double(j - resolution/2) / Double(resolution/2)
                
                // Mathematical function for surface
                let z = sin(x * .pi * 2) * cos(y * .pi * 2) * 0.5
                
                // Apply rotation
                let rotatedX = x * cos(rotationY * .pi / 180) - y * sin(rotationY * .pi / 180)
                let rotatedY = x * sin(rotationY * .pi / 180) + y * cos(rotationY * .pi / 180)
                let rotatedZ = z * cos(rotationX * .pi / 180)
                
                // Project to 2D
                let screenX = center.x + CGFloat(rotatedX) * scale
                let screenY = center.y - CGFloat(rotatedZ) * scale * 2 + CGFloat(rotatedY) * scale * 0.3
                
                // Color based on height
                let hue = (z + 0.5) * 0.7
                let color = Color(hue: hue, saturation: 0.8, brightness: 0.9)
                
                let rect = CGRect(x: screenX - 3, y: screenY - 3, width: 6, height: 6)
                context.fill(Ellipse().path(in: rect), with: .color(color))
            }
        }
    }
}

// MARK: - Scatter 3D Demo

@available(iOS 26.0, *)
struct Scatter3DDemo: View {
    let rotationX: Double
    let rotationY: Double
    
    @State private var dataPoints: [Point3D] = generateScatterData()
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                Canvas { context, size in
                    let centerX = size.width / 2
                    let centerY = size.height / 2
                    let scale: CGFloat = min(size.width, size.height) / 4
                    
                    // Draw axes
                    drawAxes(context: context, center: CGPoint(x: centerX, y: centerY), scale: scale)
                    
                    // Draw points
                    for point in dataPoints {
                        let projected = projectPoint(point, center: CGPoint(x: centerX, y: centerY), scale: scale)
                        let rect = CGRect(x: projected.x - 4, y: projected.y - 4, width: 8, height: 8)
                        context.fill(Ellipse().path(in: rect), with: .color(point.color))
                    }
                }
            }
        }
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private func drawAxes(context: GraphicsContext, center: CGPoint, scale: CGFloat) {
        var path = Path()
        
        // X axis (red)
        path.move(to: center)
        path.addLine(to: CGPoint(x: center.x + scale, y: center.y))
        context.stroke(path, with: .color(.red), lineWidth: 2)
        
        // Y axis (green)
        path = Path()
        path.move(to: center)
        path.addLine(to: CGPoint(x: center.x, y: center.y - scale))
        context.stroke(path, with: .color(.green), lineWidth: 2)
        
        // Z axis (blue)
        path = Path()
        path.move(to: center)
        path.addLine(to: CGPoint(x: center.x - scale * 0.5, y: center.y + scale * 0.5))
        context.stroke(path, with: .color(.blue), lineWidth: 2)
    }
    
    private func projectPoint(_ point: Point3D, center: CGPoint, scale: CGFloat) -> CGPoint {
        let x = point.x * cos(rotationY * .pi / 180) - point.z * sin(rotationY * .pi / 180)
        let z = point.x * sin(rotationY * .pi / 180) + point.z * cos(rotationY * .pi / 180)
        let y = point.y * cos(rotationX * .pi / 180) - z * sin(rotationX * .pi / 180)
        
        return CGPoint(
            x: center.x + CGFloat(x) * scale,
            y: center.y - CGFloat(y) * scale
        )
    }
    
    private static func generateScatterData() -> [Point3D] {
        var points: [Point3D] = []
        let colors: [Color] = [.red, .blue, .green, .orange, .purple]
        
        for _ in 0..<50 {
            points.append(Point3D(
                x: Double.random(in: -1...1),
                y: Double.random(in: -1...1),
                z: Double.random(in: -1...1),
                color: colors.randomElement()!
            ))
        }
        
        return points
    }
}

// MARK: - Bar 3D Demo

@available(iOS 26.0, *)
struct Bar3DDemo: View {
    let rotationX: Double
    let rotationY: Double
    
    let data: [BarData3D] = [
        BarData3D(label: "Q1", value: 0.8, color: .blue),
        BarData3D(label: "Q2", value: 0.6, color: .green),
        BarData3D(label: "Q3", value: 0.9, color: .orange),
        BarData3D(label: "Q4", value: 0.7, color: .purple),
    ]
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                Canvas { context, size in
                    let centerX = size.width / 2
                    let centerY = size.height * 0.7
                    let barWidth: CGFloat = 40
                    let spacing: CGFloat = 60
                    let maxHeight: CGFloat = size.height * 0.5
                    
                    // Draw bars
                    for (index, bar) in data.enumerated() {
                        let xOffset = CGFloat(index - data.count / 2) * spacing + spacing / 2
                        let barHeight = CGFloat(bar.value) * maxHeight
                        
                        // Draw 3D bar
                        draw3DBar(
                            context: context,
                            x: centerX + xOffset,
                            y: centerY,
                            width: barWidth,
                            height: barHeight,
                            color: bar.color
                        )
                    }
                    
                    // Draw labels
                    for (index, bar) in data.enumerated() {
                        let xOffset = CGFloat(index - data.count / 2) * spacing + spacing / 2
                        let labelPoint = CGPoint(x: centerX + xOffset, y: centerY + 20)
                        context.draw(
                            Text(bar.label).font(.caption),
                            at: labelPoint
                        )
                    }
                }
            }
        }
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private func draw3DBar(context: GraphicsContext, x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, color: Color) {
        let depth: CGFloat = 15
        
        // Front face
        var frontPath = Path()
        frontPath.addRect(CGRect(x: x - width/2, y: y - height, width: width, height: height))
        context.fill(frontPath, with: .color(color))
        
        // Top face
        var topPath = Path()
        topPath.move(to: CGPoint(x: x - width/2, y: y - height))
        topPath.addLine(to: CGPoint(x: x - width/2 + depth, y: y - height - depth))
        topPath.addLine(to: CGPoint(x: x + width/2 + depth, y: y - height - depth))
        topPath.addLine(to: CGPoint(x: x + width/2, y: y - height))
        topPath.closeSubpath()
        context.fill(topPath, with: .color(color.opacity(0.7)))
        
        // Right face
        var rightPath = Path()
        rightPath.move(to: CGPoint(x: x + width/2, y: y - height))
        rightPath.addLine(to: CGPoint(x: x + width/2 + depth, y: y - height - depth))
        rightPath.addLine(to: CGPoint(x: x + width/2 + depth, y: y - depth))
        rightPath.addLine(to: CGPoint(x: x + width/2, y: y))
        rightPath.closeSubpath()
        context.fill(rightPath, with: .color(color.opacity(0.5)))
    }
}

// MARK: - Data Models

struct Point3D {
    let x: Double
    let y: Double
    let z: Double
    let color: Color
}

struct BarData3D {
    let label: String
    let value: Double
    let color: Color
}

// MARK: - Chart3D API (iOS 26)

@available(iOS 26.0, *)
public struct Chart3D<Content: View>: View {
    let content: Content
    
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    public var body: some View {
        content
    }
}

@available(iOS 26.0, *)
extension Chart3D {
    public func chart3DRotation(x: Angle = .zero, y: Angle = .zero, z: Angle = .zero) -> some View {
        self
    }
    
    public func chart3DScale(_ scale: CGFloat) -> some View {
        self
    }
}

#Preview {
    if #available(iOS 26.0, *) {
        Chart3DShowcase()
    }
}
