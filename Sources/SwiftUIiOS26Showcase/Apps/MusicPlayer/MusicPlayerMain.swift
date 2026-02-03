// MusicPlayerMain.swift
// SwiftUI-iOS26-Showcase
//
// A complete Music Player app demonstration using iOS 26 features
// Showcases Liquid Glass design, animations, and modern SwiftUI patterns

import SwiftUI

// MARK: - Music Data Models

/// Music track model
struct Track: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let artist: String
    let album: String
    let duration: TimeInterval
    let artwork: Color
    let isExplicit: Bool
    
    var formattedDuration: String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    static let sample: [Track] = [
        Track(title: "Midnight Dreams", artist: "Luna Eclipse", album: "Starlight Sessions", duration: 234, artwork: .purple, isExplicit: false),
        Track(title: "Electric Soul", artist: "Neon Pulse", album: "Digital Horizons", duration: 198, artwork: .blue, isExplicit: true),
        Track(title: "Ocean Waves", artist: "Coastal Sounds", album: "Serenity", duration: 312, artwork: .cyan, isExplicit: false),
        Track(title: "City Lights", artist: "Urban Flow", album: "Metro Beats", duration: 245, artwork: .orange, isExplicit: true),
        Track(title: "Mountain High", artist: "Alpine Echo", album: "Summit", duration: 278, artwork: .green, isExplicit: false),
        Track(title: "Desert Sun", artist: "Sahara Winds", album: "Golden Dunes", duration: 203, artwork: .yellow, isExplicit: false),
        Track(title: "Rainy Night", artist: "Storm Collective", album: "Thunder", duration: 267, artwork: .gray, isExplicit: true),
        Track(title: "Summer Breeze", artist: "Beach Vibes", album: "Tropical", duration: 189, artwork: .pink, isExplicit: false),
        Track(title: "Winter Frost", artist: "Arctic Dreams", album: "Frozen", duration: 321, artwork: .mint, isExplicit: false),
        Track(title: "Autumn Leaves", artist: "Forest Walk", album: "Seasons", duration: 256, artwork: .brown, isExplicit: false)
    ]
}

/// Playlist model
struct Playlist: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let tracks: [Track]
    let color: Color
    let icon: String
    
    var totalDuration: TimeInterval {
        tracks.reduce(0) { $0 + $1.duration }
    }
    
    var formattedDuration: String {
        let hours = Int(totalDuration) / 3600
        let minutes = (Int(totalDuration) % 3600) / 60
        if hours > 0 {
            return "\(hours) hr \(minutes) min"
        }
        return "\(minutes) min"
    }
    
    static let sample: [Playlist] = [
        Playlist(name: "Favorites", description: "Your most loved tracks", tracks: Array(Track.sample.prefix(5)), color: .pink, icon: "heart.fill"),
        Playlist(name: "Chill Vibes", description: "Relax and unwind", tracks: Array(Track.sample.suffix(4)), color: .purple, icon: "moon.stars.fill"),
        Playlist(name: "Workout", description: "High energy beats", tracks: Array(Track.sample.prefix(3)), color: .orange, icon: "flame.fill"),
        Playlist(name: "Focus", description: "Concentration music", tracks: Array(Track.sample.suffix(3)), color: .blue, icon: "brain.head.profile")
    ]
}

/// Repeat mode
enum RepeatMode: CaseIterable {
    case off, all, one
    
    var icon: String {
        switch self {
        case .off: return "repeat"
        case .all: return "repeat"
        case .one: return "repeat.1"
        }
    }
    
    var isActive: Bool {
        self != .off
    }
    
    func next() -> RepeatMode {
        switch self {
        case .off: return .all
        case .all: return .one
        case .one: return .off
        }
    }
}

// MARK: - Music Player View Model

@Observable
final class MusicPlayerViewModel {
    var currentTrack: Track?
    var queue: [Track] = Track.sample
    var playlists: [Playlist] = Playlist.sample
    var isPlaying: Bool = false
    var currentTime: TimeInterval = 0
    var volume: Double = 0.7
    var isShuffled: Bool = false
    var repeatMode: RepeatMode = .off
    var showNowPlaying: Bool = false
    var showQueue: Bool = false
    
    var progress: Double {
        guard let track = currentTrack else { return 0 }
        return currentTime / track.duration
    }
    
    var remainingTime: String {
        guard let track = currentTrack else { return "0:00" }
        let remaining = track.duration - currentTime
        let minutes = Int(remaining) / 60
        let seconds = Int(remaining) % 60
        return String(format: "-%d:%02d", minutes, seconds)
    }
    
    var currentTimeFormatted: String {
        let minutes = Int(currentTime) / 60
        let seconds = Int(currentTime) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    init() {
        currentTrack = Track.sample[0]
    }
    
    func togglePlayPause() {
        isPlaying.toggle()
    }
    
    func nextTrack() {
        guard let current = currentTrack,
              let index = queue.firstIndex(of: current) else { return }
        
        let nextIndex = (index + 1) % queue.count
        currentTrack = queue[nextIndex]
        currentTime = 0
    }
    
    func previousTrack() {
        if currentTime > 3 {
            currentTime = 0
            return
        }
        
        guard let current = currentTrack,
              let index = queue.firstIndex(of: current) else { return }
        
        let prevIndex = (index - 1 + queue.count) % queue.count
        currentTrack = queue[prevIndex]
        currentTime = 0
    }
    
    func seekTo(_ progress: Double) {
        guard let track = currentTrack else { return }
        currentTime = progress * track.duration
    }
    
    func toggleShuffle() {
        isShuffled.toggle()
        if isShuffled {
            queue.shuffle()
        } else {
            queue = Track.sample
        }
    }
    
    func toggleRepeat() {
        repeatMode = repeatMode.next()
    }
    
    func playTrack(_ track: Track) {
        currentTrack = track
        currentTime = 0
        isPlaying = true
        showNowPlaying = true
    }
}

// MARK: - Main Music Player View

public struct MusicPlayerMain: View {
    @State private var viewModel = MusicPlayerViewModel()
    @State private var selectedTab = 0
    
    public init() {}
    
    public var body: some View {
        ZStack {
            backgroundGradient
            
            VStack(spacing: 0) {
                // Tab selector
                HStack(spacing: 0) {
                    MusicTabButton(title: "Library", icon: "music.note.list", index: 0, selected: $selectedTab)
                    MusicTabButton(title: "Playlists", icon: "list.bullet", index: 1, selected: $selectedTab)
                    MusicTabButton(title: "Search", icon: "magnifyingglass", index: 2, selected: $selectedTab)
                }
                .padding(4)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.ultraThinMaterial)
                )
                .padding(.horizontal)
                .padding(.top)
                
                // Content
                TabView(selection: $selectedTab) {
                    LibraryView(viewModel: viewModel)
                        .tag(0)
                    
                    PlaylistsView(viewModel: viewModel)
                        .tag(1)
                    
                    SearchView(viewModel: viewModel)
                        .tag(2)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                
                // Mini player
                if viewModel.currentTrack != nil && !viewModel.showNowPlaying {
                    MiniPlayerBar(viewModel: viewModel)
                        .transition(.move(edge: .bottom))
                }
            }
        }
        .sheet(isPresented: $viewModel.showNowPlaying) {
            NowPlayingView(viewModel: viewModel)
        }
        .sheet(isPresented: $viewModel.showQueue) {
            QueueView(viewModel: viewModel)
        }
        .navigationTitle("Music")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var backgroundGradient: some View {
        LinearGradient(
            colors: [
                Color(red: 0.1, green: 0.1, blue: 0.15),
                Color(red: 0.15, green: 0.1, blue: 0.2)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }
}

// MARK: - Library View

struct LibraryView: View {
    let viewModel: MusicPlayerViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Recently played section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Recently Played")
                        .font(.title2.bold())
                        .foregroundStyle(.white)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(viewModel.queue.prefix(5)) { track in
                                RecentTrackCard(track: track) {
                                    viewModel.playTrack(track)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal)
                
                // All songs section
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("All Songs")
                            .font(.title2.bold())
                            .foregroundStyle(.white)
                        
                        Spacer()
                        
                        Button {
                            viewModel.toggleShuffle()
                            if let first = viewModel.queue.first {
                                viewModel.playTrack(first)
                            }
                        } label: {
                            HStack(spacing: 6) {
                                Image(systemName: "shuffle")
                                Text("Shuffle")
                            }
                            .font(.subheadline.bold())
                            .foregroundStyle(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                Capsule()
                                    .fill(Color.blue.opacity(0.4))
                            )
                        }
                    }
                    .padding(.horizontal)
                    
                    VStack(spacing: 0) {
                        ForEach(viewModel.queue) { track in
                            TrackRow(
                                track: track,
                                isPlaying: viewModel.currentTrack == track && viewModel.isPlaying
                            ) {
                                viewModel.playTrack(track)
                            }
                            
                            if track.id != viewModel.queue.last?.id {
                                Divider()
                                    .background(Color.white.opacity(0.1))
                                    .padding(.leading, 76)
                            }
                        }
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.ultraThinMaterial)
                    )
                    .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
    }
}

// MARK: - Playlists View

struct PlaylistsView: View {
    let viewModel: MusicPlayerViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Create playlist button
                Button {
                    // Create playlist action
                } label: {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                        Text("Create Playlist")
                            .font(.headline)
                    }
                    .foregroundStyle(.blue)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.ultraThinMaterial)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .strokeBorder(Color.blue.opacity(0.3), style: StrokeStyle(lineWidth: 2, dash: [8]))
                            )
                    )
                }
                .padding(.horizontal)
                
                // Playlists grid
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    ForEach(viewModel.playlists) { playlist in
                        PlaylistCard(playlist: playlist) {
                            if let first = playlist.tracks.first {
                                viewModel.playTrack(first)
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
    }
}

// MARK: - Search View

struct SearchView: View {
    let viewModel: MusicPlayerViewModel
    @State private var searchText = ""
    
    var filteredTracks: [Track] {
        if searchText.isEmpty {
            return []
        }
        return viewModel.queue.filter {
            $0.title.localizedCaseInsensitiveContains(searchText) ||
            $0.artist.localizedCaseInsensitiveContains(searchText) ||
            $0.album.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var body: some View {
        VStack(spacing: 16) {
            // Search bar
            HStack(spacing: 12) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.white.opacity(0.5))
                
                TextField("Search songs, artists, albums...", text: $searchText)
                    .foregroundStyle(.white)
                    .textFieldStyle(.plain)
                
                if !searchText.isEmpty {
                    Button {
                        searchText = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.white.opacity(0.5))
                    }
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(.ultraThinMaterial)
            )
            .padding(.horizontal)
            
            // Results
            if searchText.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 48))
                        .foregroundStyle(.white.opacity(0.3))
                    
                    Text("Search for music")
                        .font(.headline)
                        .foregroundStyle(.white.opacity(0.6))
                }
                .frame(maxHeight: .infinity)
            } else if filteredTracks.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "music.note")
                        .font(.system(size: 48))
                        .foregroundStyle(.white.opacity(0.3))
                    
                    Text("No results found")
                        .font(.headline)
                        .foregroundStyle(.white.opacity(0.6))
                }
                .frame(maxHeight: .infinity)
            } else {
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(filteredTracks) { track in
                            TrackRow(
                                track: track,
                                isPlaying: viewModel.currentTrack == track && viewModel.isPlaying
                            ) {
                                viewModel.playTrack(track)
                            }
                            
                            if track.id != filteredTracks.last?.id {
                                Divider()
                                    .background(Color.white.opacity(0.1))
                                    .padding(.leading, 76)
                            }
                        }
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.ultraThinMaterial)
                    )
                    .padding(.horizontal)
                }
            }
        }
        .padding(.vertical)
    }
}

// MARK: - Now Playing View

struct NowPlayingView: View {
    @Bindable var viewModel: MusicPlayerViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 24) {
            // Header
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.down")
                        .font(.title2)
                        .foregroundStyle(.white)
                }
                
                Spacer()
                
                Text("Now Playing")
                    .font(.headline)
                    .foregroundStyle(.white)
                
                Spacer()
                
                Button {
                    viewModel.showQueue = true
                } label: {
                    Image(systemName: "list.bullet")
                        .font(.title2)
                        .foregroundStyle(.white)
                }
            }
            .padding(.top)
            .padding(.horizontal)
            
            Spacer()
            
            // Artwork
            if let track = viewModel.currentTrack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(track.artwork.gradient)
                    .aspectRatio(1, contentMode: .fit)
                    .padding(.horizontal, 40)
                    .shadow(color: track.artwork.opacity(0.5), radius: 30)
                    .overlay(
                        Image(systemName: "music.note")
                            .font(.system(size: 80))
                            .foregroundStyle(.white.opacity(0.3))
                    )
            }
            
            Spacer()
            
            // Track info
            if let track = viewModel.currentTrack {
                VStack(spacing: 8) {
                    HStack {
                        Text(track.title)
                            .font(.title2.bold())
                            .foregroundStyle(.white)
                        
                        if track.isExplicit {
                            Text("E")
                                .font(.caption2.bold())
                                .foregroundStyle(.white.opacity(0.7))
                                .padding(4)
                                .background(
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(Color.white.opacity(0.2))
                                )
                        }
                    }
                    
                    Text(track.artist)
                        .font(.title3)
                        .foregroundStyle(.white.opacity(0.7))
                }
            }
            
            // Progress
            VStack(spacing: 8) {
                Slider(value: Binding(
                    get: { viewModel.progress },
                    set: { viewModel.seekTo($0) }
                ))
                .tint(.white)
                
                HStack {
                    Text(viewModel.currentTimeFormatted)
                    Spacer()
                    Text(viewModel.remainingTime)
                }
                .font(.caption)
                .foregroundStyle(.white.opacity(0.6))
            }
            .padding(.horizontal)
            
            // Controls
            HStack(spacing: 40) {
                Button {
                    viewModel.toggleShuffle()
                } label: {
                    Image(systemName: "shuffle")
                        .font(.title3)
                        .foregroundStyle(viewModel.isShuffled ? .green : .white.opacity(0.6))
                }
                
                Button {
                    viewModel.previousTrack()
                } label: {
                    Image(systemName: "backward.fill")
                        .font(.title)
                        .foregroundStyle(.white)
                }
                
                Button {
                    viewModel.togglePlayPause()
                } label: {
                    Image(systemName: viewModel.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                        .font(.system(size: 72))
                        .foregroundStyle(.white)
                }
                
                Button {
                    viewModel.nextTrack()
                } label: {
                    Image(systemName: "forward.fill")
                        .font(.title)
                        .foregroundStyle(.white)
                }
                
                Button {
                    viewModel.toggleRepeat()
                } label: {
                    Image(systemName: viewModel.repeatMode.icon)
                        .font(.title3)
                        .foregroundStyle(viewModel.repeatMode.isActive ? .green : .white.opacity(0.6))
                }
            }
            
            // Volume
            HStack(spacing: 12) {
                Image(systemName: "speaker.fill")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.5))
                
                Slider(value: $viewModel.volume)
                    .tint(.white)
                
                Image(systemName: "speaker.wave.3.fill")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.5))
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .background(
            LinearGradient(
                colors: [
                    (viewModel.currentTrack?.artwork ?? .blue).opacity(0.8),
                    Color(red: 0.1, green: 0.1, blue: 0.15)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
    }
}

// MARK: - Queue View

struct QueueView: View {
    @Bindable var viewModel: MusicPlayerViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                if let current = viewModel.currentTrack {
                    Section("Now Playing") {
                        TrackRow(track: current, isPlaying: viewModel.isPlaying) {}
                    }
                }
                
                Section("Up Next") {
                    ForEach(viewModel.queue.filter { $0 != viewModel.currentTrack }) { track in
                        TrackRow(track: track, isPlaying: false) {
                            viewModel.playTrack(track)
                        }
                    }
                }
            }
            .navigationTitle("Queue")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Mini Player Bar

struct MiniPlayerBar: View {
    @Bindable var viewModel: MusicPlayerViewModel
    
    var body: some View {
        Button {
            viewModel.showNowPlaying = true
        } label: {
            HStack(spacing: 12) {
                // Artwork
                if let track = viewModel.currentTrack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(track.artwork)
                        .frame(width: 48, height: 48)
                        .overlay(
                            Image(systemName: "music.note")
                                .foregroundStyle(.white.opacity(0.5))
                        )
                }
                
                // Info
                if let track = viewModel.currentTrack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(track.title)
                            .font(.subheadline.bold())
                            .foregroundStyle(.white)
                        
                        Text(track.artist)
                            .font(.caption)
                            .foregroundStyle(.white.opacity(0.6))
                    }
                }
                
                Spacer()
                
                // Controls
                Button {
                    viewModel.togglePlayPause()
                } label: {
                    Image(systemName: viewModel.isPlaying ? "pause.fill" : "play.fill")
                        .font(.title2)
                        .foregroundStyle(.white)
                }
                
                Button {
                    viewModel.nextTrack()
                } label: {
                    Image(systemName: "forward.fill")
                        .font(.title3)
                        .foregroundStyle(.white)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .strokeBorder(Color.white.opacity(0.1), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(.plain)
        .padding(.horizontal)
        .padding(.bottom, 8)
    }
}

// MARK: - Supporting Views

struct MusicTabButton: View {
    let title: String
    let icon: String
    let index: Int
    @Binding var selected: Int
    
    var body: some View {
        Button {
            withAnimation(.spring(response: 0.3)) {
                selected = index
            }
        } label: {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.title3)
                
                Text(title)
                    .font(.caption2)
            }
            .foregroundStyle(selected == index ? .white : .white.opacity(0.5))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(selected == index ? Color.blue.opacity(0.4) : Color.clear)
            )
        }
    }
}

struct RecentTrackCard: View {
    let track: Track
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 8) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(track.artwork.gradient)
                    .aspectRatio(1, contentMode: .fit)
                    .frame(width: 120)
                    .overlay(
                        Image(systemName: "music.note")
                            .font(.largeTitle)
                            .foregroundStyle(.white.opacity(0.3))
                    )
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(track.title)
                        .font(.subheadline.bold())
                        .foregroundStyle(.white)
                        .lineLimit(1)
                    
                    Text(track.artist)
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.6))
                        .lineLimit(1)
                }
            }
            .frame(width: 120)
        }
        .buttonStyle(.plain)
    }
}

struct TrackRow: View {
    let track: Track
    let isPlaying: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                // Artwork
                RoundedRectangle(cornerRadius: 8)
                    .fill(track.artwork)
                    .frame(width: 52, height: 52)
                    .overlay(
                        Group {
                            if isPlaying {
                                NowPlayingIndicator()
                            } else {
                                Image(systemName: "music.note")
                                    .foregroundStyle(.white.opacity(0.4))
                            }
                        }
                    )
                
                // Info
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(track.title)
                            .font(.subheadline.bold())
                            .foregroundStyle(isPlaying ? .blue : .white)
                        
                        if track.isExplicit {
                            Text("E")
                                .font(.system(size: 9).bold())
                                .foregroundStyle(.white.opacity(0.6))
                                .padding(.horizontal, 4)
                                .padding(.vertical, 2)
                                .background(
                                    RoundedRectangle(cornerRadius: 3)
                                        .fill(Color.white.opacity(0.15))
                                )
                        }
                    }
                    
                    Text(track.artist)
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.6))
                }
                
                Spacer()
                
                Text(track.formattedDuration)
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.5))
                
                Image(systemName: "ellipsis")
                    .foregroundStyle(.white.opacity(0.5))
            }
            .padding()
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

struct NowPlayingIndicator: View {
    @State private var isAnimating = false
    
    var body: some View {
        HStack(spacing: 2) {
            ForEach(0..<3, id: \.self) { index in
                RoundedRectangle(cornerRadius: 1)
                    .fill(.white)
                    .frame(width: 3, height: isAnimating ? CGFloat.random(in: 8...16) : 4)
                    .animation(
                        .easeInOut(duration: 0.4)
                        .repeatForever()
                        .delay(Double(index) * 0.1),
                        value: isAnimating
                    )
            }
        }
        .onAppear {
            isAnimating = true
        }
    }
}

struct PlaylistCard: View {
    let playlist: Playlist
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 8) {
                // Cover
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(playlist.color.gradient)
                    
                    Image(systemName: playlist.icon)
                        .font(.system(size: 40))
                        .foregroundStyle(.white.opacity(0.3))
                }
                .aspectRatio(1, contentMode: .fit)
                
                // Info
                VStack(alignment: .leading, spacing: 4) {
                    Text(playlist.name)
                        .font(.headline)
                        .foregroundStyle(.white)
                    
                    Text("\(playlist.tracks.count) songs • \(playlist.formattedDuration)")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.6))
                }
            }
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview

#Preview("Music Player") {
    NavigationStack {
        MusicPlayerMain()
    }
}
