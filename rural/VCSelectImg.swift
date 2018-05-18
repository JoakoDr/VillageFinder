//
//  VCSelectImg.swift
//  rural
//
//  Created by JOAQUIN DIAZ RAMIREZ on 24/4/18.
//  Copyright © 2018 DAVID ANGULO CORCUERA. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore

class VCSelectImg: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet var imgSub:UIImageView?
    @IBOutlet var btnSalir:UIButton?
    @IBOutlet var txtNombre:NuevoTextField?
    @IBOutlet var txtLocalizacion:NuevoTextField?
    @IBOutlet var txtProvincia:NuevoTextField?
    @IBOutlet var txtPoblacion:NuevoTextField?
    @IBOutlet var txtLatitud:NuevoTextField?
    @IBOutlet var txtLongitud:NuevoTextField?
    var downloadURL = ""
  
        let imagePicker = UIImagePickerController()
    let alert:UIAlertController = UIAlertController(title: "Subir foto de perfil", message:  "¡Has subido tu imagen!", preferredStyle: UIAlertControllerStyle.actionSheet)
    let alert1:UIAlertController = UIAlertController(title: "Perfil Subido", message:  "¡Has subido tu perfil!", preferredStyle: UIAlertControllerStyle.actionSheet)
       let alert2:UIAlertController = UIAlertController(title: "Error", message:  "¡Completa todos los campos!", preferredStyle: UIAlertControllerStyle.actionSheet)

    
    
    
    
    var imgData:Data?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //create action and add them to alert
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        alert1.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        
        imagePicker.delegate = self
        btnSalir?.layer.cornerRadius = 15        // Do any additional setup after loading the view.
        //imgSub?.layer.cornerRadius = 10.0
        self.imgSub?.layer.cornerRadius = (self.imgSub?.frame.size.width)! / 2
        self.imgSub?.clipsToBounds = true
        self.imgSub?.layer.borderWidth = 1.0
        self.imgSub?.layer.borderColor = UIColor.blue.cgColor
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func accionBotonGaleria()
    {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    @IBAction func accionBotonCamara()
    {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .camera
        self.present(imagePicker, animated: true, completion: nil)
    }
    @IBAction func accionBotonConfirmar()
    {
       
        if imgData != nil {
            let tiempoMilis:Int = Int((Date().timeIntervalSince1970 * 1000.0).rounded())
            let ruta:String = String(format: "imagenes/imagen%d.jpg", tiempoMilis)
            let imagenRef = DataHolder.sharedInstance.firStorageRef?.child(ruta)
            let metadata =  StorageMetadata()
            metadata.contentType = "image/jpeg"
            // Upload the file to the path "images/rivers.jpg"
            let uploadTask = imagenRef?.putData(imgData!, metadata: metadata) { (metadata, error) in
                guard let metadata = metadata else {
                    // print("ERROR!!! ",error)
                    // Uh-oh, an error occurred!
                    return
                }
                let downloadURL = metadata.downloadURL()
                // Metadata contains file metadata such as size, content-type, and download URL.
                self.downloadURL = (downloadURL?.absoluteString)!//.path!
                DataHolder.sharedInstance.savePerfil()
                //self.present(self.alert, animated: true)
                // print("AAAA!!!! ",downloadURL)
                print("----->"+self.downloadURL)
                DataHolder.sharedInstance.miPerfil.sNombre=self.txtNombre?.text
                DataHolder.sharedInstance.miPerfil.sLocalizacion=self.txtLocalizacion?.text
                DataHolder.sharedInstance.miPerfil.sProvincia=self.txtProvincia?.text
                DataHolder.sharedInstance.miPerfil.sPoblacion=self.txtPoblacion?.text
                //var firstNumberConv:Double? = Double(txtLatitud?.text)!
                //var secondNumberConv:Double? = Double(txtLongitud?.text)!
                let auxLatitud :String? = (self.txtLatitud?.text!)
                let auxLongitud :String? = (self.txtLongitud?.text!)
                let Latitud = (auxLatitud! as NSString).doubleValue
                let Longitud = (auxLongitud! as NSString).doubleValue
                DataHolder.sharedInstance.miPerfil.sLatitud=Latitud
                DataHolder.sharedInstance.miPerfil.sLongitud=Longitud
                DataHolder.sharedInstance.miPerfil.sImagen = self.downloadURL
                print("----IMAGEN-->",self.downloadURL)
                DataHolder.sharedInstance.savePerfil()
                self.present(self.alert1, animated: true)
                
            }
        
        }
    }
    
    @IBAction func accionBotonSubir()
    {
        /*
        if imgData != nil{
            
            let tiempoMilis:Int = Int((Date().timeIntervalSince1970 * 1000.0).rounded())
            
            let ruta:String = String(format: "imagenes/imagen%d.jpg", tiempoMilis)
            
            let perfiles = DataHolder.sharedInstance.firStorageRef?.child(ruta)
            let metadata =  StorageMetadata()
            metadata.contentType = "image/jpeg"
            
        let uploadTask = perfiles?.putData(imgData! , metadata:nil){(metadata, error) in
                
            guard let metadata = metadata else{
                    
                    return
                    
                    }
                
                let downloadURL = metadata.downloadURL()
                
                DataHolder.sharedInstance.miPerfil.sImagen = downloadURL?.absoluteString
                
                DataHolder.sharedInstance.savePerfil()
         
                */
            //DataHolder.sharedInstance.miPerfil.idurlimg = downloadURL.
                
            
            
            

        
       
        
            
            
        }
     
    
        

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let img = info[UIImagePickerControllerOriginalImage] as? UIImage
        imgData = UIImageJPEGRepresentation(img!, 1)!
        imgSub?.image = img
        self.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)

    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


