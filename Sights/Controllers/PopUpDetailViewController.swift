//
//  PopUpDetailViewController.swift
//  Sights
//
//  Created by HARSHIT on 23/02/20.
//  Copyright © 2020 HARSHIT. All rights reserved.
//

import UIKit
import Cosmos


class PopUpDetailViewController: UIViewController {
    
    var nameString : String = "name"
    var starsDouble : Double = 5.0
    var locString : String = "location"
    var hoursString : String = "hours"
    var descString : String = " desc"
    var imagePOIString : String = "url"
    var wanttovisit : Bool = false
    var visited : Bool = false
    var notinterested : Bool = false

    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var Stars: CosmosView!
    @IBOutlet weak var StarsNumber: UILabel!
    @IBOutlet weak var Location: UILabel!
    @IBOutlet weak var Hours: UILabel!
    @IBOutlet weak var Desc: UITextView!
    @IBOutlet weak var ImagePOI: UIImageView!
    
    
    @IBOutlet weak var notInterested: UIButton!
    @IBOutlet weak var wantToVisit: UIButton!
    @IBOutlet weak var Visited: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        Name.text = nameString
        Stars.rating = starsDouble
        StarsNumber.text = "(\(starsDouble))"
        Location.text = locString
        Hours.text = hoursString
        Desc.text = descString
        
        if(notinterested==true){
            notInterested.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
        }
        if(wanttovisit==true){
            wantToVisit.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        }
        if(visited==true){
            Visited.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        }
        if let url = URL(string: imagePOIString)
        {
            do
            {
                let data = try Data(contentsOf: url)
                let img = UIImage(data: data)
                ImagePOI.image = img
            }
            catch
            {
                print(error.localizedDescription)
            }
        }
    }
    
    func setContent(name : String, loc: String, stars: Double, hours : String, desc: String, img: String, want: Bool, visit: Bool, not: Bool){
        nameString = name
        starsDouble = stars
        locString = loc
        hoursString = hours
        descString = desc
        imagePOIString = img
        wanttovisit = want
        visited = visit
        notinterested = not
    }
    
    @IBAction func clk_Close()
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func clk_NotInterested(button:UIButton)
    {
        notinterested = !notinterested
        if(notinterested==true){
            notInterested.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
            //db
        }else{
            notInterested.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        }
        //button.isSelected = !button.isSelected
    }
    
    @IBAction func clk_WantToVisit(button:UIButton)
    {
        wanttovisit = !wanttovisit
        if(wanttovisit==true){
            wantToVisit.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        }else{
            wantToVisit.setImage(UIImage(systemName: "bookmark"), for: .normal)
        }
        //button.isSelected = !button.isSelected
    }
    
    @IBAction func clk_Visited(button:UIButton)
    {
        visited = !visited
        if(visited==true){
            Visited.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        }else{
            Visited.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        }
        //button.isSelected = !button.isSelected
    }
}
