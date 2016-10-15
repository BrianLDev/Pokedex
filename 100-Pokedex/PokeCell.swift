//
//  PokeCell.swift
//  100-Pokedex
//
//  Created by Brian Leip on 10/14/16.
//  Copyright © 2016 Triskelion Studios. All rights reserved.
//

import UIKit

class PokeCell: UICollectionViewCell {
    
    @IBOutlet weak var thumbImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
    var pokemon: Pokemon!
    
    required init?(coder aDecoder: NSCoder){
        // this init is required for the program to compile
        super.init(coder: aDecoder)
        
        layer.cornerRadius = 5.0    // creates rounded corners
    }
    
    func configureCell(pokemon: Pokemon) {
        
        self.pokemon = pokemon
        
        nameLbl.text = self.pokemon.name.capitalized
        thumbImg.image = UIImage(named: "\(self.pokemon.pokedexId)")
        
    }
    

    

    
}
