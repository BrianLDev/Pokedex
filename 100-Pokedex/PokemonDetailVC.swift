//
//  PokemonDetailVC.swift
//  100-Pokedex
//
//  Created by Brian Leip on 10/21/16.
//  Copyright © 2016 Triskelion Studios. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {
    
    var pokemon: Pokemon!

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var pokedexIdLbl: UILabel!
    @IBOutlet weak var heightLbl: UILabel!
    @IBOutlet weak var attackLbl: UILabel!
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var defenseLbl: UILabel!
    @IBOutlet weak var currentEvoImg: UIImageView!
    @IBOutlet weak var nextEvoImg: UIImageView!
    @IBOutlet weak var evoLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // update any pokemon info that doesn't need to be downloaded
        nameLbl.text = pokemon.name.capitalized
        let img = UIImage(named: String(pokemon.pokedexId) )
        mainImg.image = img
        currentEvoImg.image = img
        pokedexIdLbl.text = String(pokemon.pokedexId)

        
        pokemon.downloadPokemonDetail() {
            // whatever we write here will only be called after the network call is complete since it is using the asynchronous @escaping DownloadComplete
            print("we made it!")
            self.updateUI()
        }
    }
    
    func updateUI() {
        // updates the data downloaded from the interwebs
        descriptionLbl.text = pokemon.description
        typeLbl.text = pokemon.type
        pokedexIdLbl.text = String(pokemon.pokedexId)
        attackLbl.text = pokemon.attack
        defenseLbl.text = pokemon.defense
        heightLbl.text = pokemon.height
        weightLbl.text = pokemon.weight
        evoLbl.text = pokemon.nextEvolutionText
        if pokemon.nextEvolutionID == "" {
            nextEvoImg.isHidden = true
        } else {
            let newImage = UIImage(named: pokemon.nextEvolutionID)
            nextEvoImg.image = newImage
        }
    }

    @IBAction func backBtnPressed(_ sender: AnyObject) {
        // goes back to main screen
        dismiss(animated: true, completion: nil)
    }


}
