//
//  ViewController.swift
//  Guess the melody
//
//  Created by StanislavPM on 15/02/2019.
//  Copyright © 2019 StanislavPM. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    // MARK: - Outlets -
    
    @IBOutlet weak var playPause: UIButton!
    @IBOutlet weak var artworkImageView: UIImageView!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var trackLabel: UILabel!
    @IBOutlet weak var checkAnswerButton: UIButton!
    @IBOutlet weak var topicLabel: UILabel!
    @IBOutlet weak var trackNumberLabel: UILabel!
    
    // MARK: - Configure vars -
    
    let topics = ["Sia", "Offspring", "Hello"]
    let url = URL(string: "https://itunes.apple.com/search")!
    var queries = [
        "term": "hello",
        "contry": "RU",
        "media": "music",
        "lang": "ru_RU",
        "explicit": "No",
        "limit": "10"
    ]
    
    // MARK: - Vars -
    
    var tracks: [TrackInfo]? {
        didSet {
            DispatchQueue.main.async {
                self.playPause.isEnabled = true
                self.topicLabel.text = self.topics[self.topicIndex]
            }
            
            playMusic()
        }
    }
    var trackIndex = 0 {
        didSet { playMusic() }
    }
    var currentTrack: TrackInfo? {
        didSet { updateUIForNextTrack() }
    }
    
    var topicIndex = 0 {
        didSet {
            let currentTopic = topics[topicIndex]
            
            self.topicLabel.text = currentTopic
            requestTracks(on: currentTopic)
        }
    }
    
    var artworkImage: UIImage?
    var audioPlayer: AVPlayer?
    
    // MARK: - Methods -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    func setup() {
        audioPlayer = AVPlayer()
        audioPlayer?.volume = 0.5
        topicIndex = 0
        playPause.isEnabled = false
    }
    
    func updateUIForNextTrack() {
        updateArtwork()
        
        DispatchQueue.main.async {
            self.trackNumberLabel.text = "Трек \(self.trackIndex + 1) из \(self.tracks!.count)"
            self.artworkImageView.image = UIImage(named: "QustionMario")
            self.artistLabel.text = "?"
            self.trackLabel.text = "?"
        }
    }
    
    func updateArtwork() {
        guard let currentTrack = self.currentTrack else { return }
        
        URLSession.shared.dataTask(with: currentTrack.artwork) { (data, _, _) in
            guard let data = data else { return }
            self.artworkImage = UIImage(data: data)
        }.resume()
    }
    
    func requestTracks(on topic: String) {
        queries["term"] = topic
        let url = self.url.withQueries(queries)!
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else {
                print("Error in \(#function) in \(#line): can`t read the data")
                return
            }
            
            let jsonDecoder = JSONDecoder()
            
            guard let iTunesInfo = try? jsonDecoder.decode(ItunesInfo.self, from: data) else { return }
            self.tracks = iTunesInfo.results
    
            }.resume()
    }
    
    
    func playMusic() {
        guard let tracks = tracks else { return }
        
        currentTrack = tracks[trackIndex]
        playTrackBy(url: currentTrack!.preview)
    }
    
    func playTrackBy(url: URL) {
        guard let audioPlayer = audioPlayer else { return }
        
        let trackItem = AVPlayerItem(url: url)
        audioPlayer.replaceCurrentItem(with: trackItem)
    
        audioPlayer.play()
    }
    
    // MARK: - Actions -
    
    @IBAction func playPause(sender: UIButton) {
        guard let player = audioPlayer else { return }
        
        player.rate == 1.0 ? player.pause() : player.play() // rate = 1 - played, rate = 0 - pause
    }
    
    @IBAction func checkTheAnswer(_ sender: UIButton) {
        guard let currentTrack = currentTrack else {return}
        
        self.artworkImageView.image = self.artworkImage
        
        artistLabel.text = currentTrack.artist
        trackLabel.text = currentTrack.track
    }
    
    @IBAction func nextTrack(_ sender: UIButton) {
        if trackIndex < tracks!.count - 1 { // смена трека
            trackIndex += 1
        } else if topicIndex < topics.count - 1 { // смена темы
            topicIndex += 1
            trackIndex = 0
        }
    }
}

