//
//  ViewController.swift
//  100-Pokedex
//
//  Created by Brian Leip on 10/14/16.
//  Copyright © 2016 Triskelion Studios. All rights reserved.
//

import UIKit
import AVFoundation // for music

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!

    var pokemon = [Pokemon]()
    var filteredPokemon = [Pokemon]()
    var musicPlayer: AVAudioPlayer!
    var inSearchMode = false
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collection.dataSource = self
        collection.delegate = self
        searchBar.delegate = self
        
        searchBar.returnKeyType = UIReturnKeyType.done  // changes the button from "Search" to "Done"
        
        parsePokemonCSV()
        initAudio()
    
    }
    
    func initAudio() {
        
        let path = Bundle.main.path(forResource: "music", ofType: "mp3")!
        
        do {
            
            musicPlayer = try AVAudioPlayer(contentsOf: URL(string: path)!) // pulls music from music.mp3
            musicPlayer.prepareToPlay()     // gets it ready to play
            musicPlayer.numberOfLoops = -1  // loops continuously
            musicPlayer.play()
            
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
    func parsePokemonCSV() {
        
        let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")
        
        do {
            let csv = try CSV(contentsOfURL: path!)
            let rows = csv.rows
            //print(rows)
            
            for row in rows {
                let pokeID = Int(row["id"]!)!   // "id" is the key within the dictionary, returns value
                let name = row["identifier"]!   // "identifier" is key within dictionary, returns value
                
                let poke = Pokemon(name: name, pokedexId: pokeID)
                pokemon.append(poke)
            }
            
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // per JonnyB - Dequeues the cell and sets it up
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokeCell", for: indexPath) as? PokeCell {
            
            let poke: Pokemon!
            if inSearchMode {
                
                poke = filteredPokemon[indexPath.row]
                cell.configureCell(poke)
            } else {
                
                poke = pokemon[indexPath.row]
                cell.configureCell(poke)
            }
            
            return cell
        } else {
            
            return UICollectionViewCell()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // per JonnyB - this will be used later to execute code whenever we tap the cell
        
        view.endEditing(true)   // this will hide the keyboard if it is showing
        
        var poke: Pokemon!
        
        if inSearchMode {
            poke = filteredPokemon[indexPath.row]
        } else {
            
            poke = pokemon[indexPath.row]
        }
        
        performSegue(withIdentifier: "PokemonDetailVC", sender: poke)   // go to details screen for that pokemon
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // per JonnyB - this sets the number of total items in the collectoin section
        if(inSearchMode) {
            return filteredPokemon.count
        } else {
            return pokemon.count
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // per JonnyB - this is the number of sections in the collection view (just 1)
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // per JonnyB - this defines the size of the cells
        
        return CGSize(width: 105, height: 105)
    }
    
    @IBAction func musicBtnPressed(_ sender: UIButton) {
        
        if musicPlayer.isPlaying {
            // if the musicPlayer is playing then pause it
            musicPlayer.pause()
            sender.alpha = 0.2  // lowers alpha on the button when paused.  Sender refers to the button
        } else {
            // if the musicPlayer is not playing then play it
            musicPlayer.play()
            sender.alpha = 1.0  // increases alpha on the button when unpaused.  Sender refers to button
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // this will hide the keyboard after the user presses "Search"
        view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == nil || searchBar.text == "" {
            inSearchMode = false
            collection.reloadData() // refreshes the collectionView
            view.endEditing(true)   // hides keyboard again
        } else {
            inSearchMode = true
            
            let lower = searchBar.text!.lowercased()
            
            filteredPokemon = pokemon.filter({$0.name.range(of: lower) != nil})
            // $0 is any and all objects within the pokemon array
            // this searches to see if what is typed in search bar (lower) shows up within any of the pokemon names
            collection.reloadData() // refreshes the collectionView
        }
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // this func prepares the segue to PokemonDetail VC when user presses on a Pokemon
        if segue.identifier == "PokemonDetailVC" {
            if let detailsVC = segue.destination as? PokemonDetailVC {
                if let poke = sender as? Pokemon {  // poke is the sender and it is of type Pokemon
                    detailsVC.pokemon = poke    // sends the pokemon variable to the detailsVC
                }
            }
        }
    }
    

}

