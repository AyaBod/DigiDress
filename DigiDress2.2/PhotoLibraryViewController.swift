//
//  PhotoLibraryViewController.swift
//  DigiDress2.2
//
//  Created by AYANNA BODAKE on 7/9/24.
//

import UIKit
import CoreML
import Vision
import PhotosUI

class PhotoLibraryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate,  UIImagePickerControllerDelegate, UINavigationControllerDelegate, PHPickerViewControllerDelegate{
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var albumPullDownButton: UIButton!
    
    /*
    var albums: [Album] = [Album(name: "t-shirt"), Album(name: "pants"), Album(name: "longsleeve"), Album(name: "shirt"), Album(name: "dress"), Album(name: "shorts"), Album(name: "shoes"), Album(name: "outwear"), Album(name: "hat"), Album(name: "skirt"), Album(name: "donated")]*/
    
    var albums: [Album] {
        get { AlbumManager.shared.albums }
        set { AlbumManager.shared.albums = newValue }
    }


    var currentAlbum: Album {
        get { albums[selectedAlbumIndex] }
        set { albums[selectedAlbumIndex] = newValue }
    }
    
    var selectedAlbumIndex: Int = 0 {
        didSet {
            albumPullDownButton.setTitle(albums[selectedAlbumIndex].name, for: .normal)
            collectionView.reloadData()
        }
    }
    
    var selectedPhotos: [IndexPath] = []


    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.allowsMultipleSelection = true
        setupAlbumPullDownButton()
    }
    
    func setupAlbumPullDownButton() {
        var actions: [UIAction] = []
        for (index, album) in albums.enumerated() {
            let action = UIAction(title: album.name, handler: { [weak self] _ in
                self?.selectedAlbumIndex = index
            })
            actions.append(action)
        }
        let menu = UIMenu(title: "Select Album", children: actions)
        albumPullDownButton.menu = menu
        albumPullDownButton.showsMenuAsPrimaryAction = true
        albumPullDownButton.setTitle(albums[selectedAlbumIndex].name, for: .normal)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return currentAlbum.photos.count
        }

        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCollectionViewCell
            cell.imageView.image = currentAlbum.photos[indexPath.row]
            cell.setSelected(selectedPhotos.contains(indexPath))
            return cell
        }

        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            selectedPhotos.append(indexPath)
            let cell = collectionView.cellForItem(at: indexPath) as! PhotoCollectionViewCell
            cell.setSelected(true)
        }

        func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
            if let index = selectedPhotos.firstIndex(of: indexPath) {
                selectedPhotos.remove(at: index)
            }
            let cell = collectionView.cellForItem(at: indexPath) as! PhotoCollectionViewCell
            cell.setSelected(false)
        }
    

    
    //adding photos by library or taking them
    @IBAction func addPhotoButtonTapped(_ sender: UIButton) {
        let actionSheet = UIAlertController(title: "Add a Photo", message: nil, preferredStyle: .actionSheet)

                actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { action in
                    self.showImagePicker(sourceType: .camera)
                }))

                actionSheet.addAction(UIAlertAction(title: "Choose from Library", style: .default, handler: { action in
                    self.showPHPicker()
                }))

                actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

                present(actionSheet, animated: true, completion: nil)
            }

            func showImagePicker(sourceType: UIImagePickerController.SourceType) {
                if UIImagePickerController.isSourceTypeAvailable(sourceType) {
                    let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    imagePicker.sourceType = sourceType
                    present(imagePicker, animated: true, completion: nil)
                }
            }

            
    func showPHPicker() {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 0 // 0 means no limit

        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        let group = DispatchGroup()

        for result in results {
            group.enter()
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (object, error) in
                defer { group.leave() }
                if let image = object as? UIImage {
                    self?.addImageToCurrentAlbum(image)
                }
            }
        }

                group.notify(queue: .main) {
                    self.collectionView.reloadData()
                }
            }

            func addImageToCurrentAlbum(_ image: UIImage) {
                var album = currentAlbum
                album.photos.append(image)
                currentAlbum = album
                collectionView.reloadData()
            }

    
    //move dleete buttons
    @IBAction func movePhotoButtonTapped(_ sender: UIButton) {
        guard !selectedPhotos.isEmpty else {
                showAlert(title: "No Photos Selected", message: "Please select photos to move.")
                return
            }

            let actionSheet = UIAlertController(title: "Move Photo", message: "Choose the destination album", preferredStyle: .actionSheet)

            for (index, album) in albums.enumerated() where album.name != currentAlbum.name {
                actionSheet.addAction(UIAlertAction(title: album.name, style: .default, handler: { [weak self] _ in
                    self?.moveSelectedPhotosToAlbum(at: index)
                }))
            }

            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(actionSheet, animated: true, completion: nil)
        }

    func moveSelectedPhotosToAlbum(at index: Int) {
        guard !selectedPhotos.isEmpty else { return }

        var sourceAlbum = currentAlbum
        var destinationAlbum = albums[index]

        for indexPath in selectedPhotos.sorted(by: { $0.item > $1.item }) {
            let photo = sourceAlbum.photos[indexPath.item]
            sourceAlbum.photos.remove(at: indexPath.item)
            destinationAlbum.photos.append(photo)
        }

        currentAlbum = sourceAlbum
        albums[index] = destinationAlbum
        selectedPhotos.removeAll()
        collectionView.reloadData()
    }


    @IBAction func deletePhotoButtonTapped(_ sender: UIButton) {
        guard !selectedPhotos.isEmpty else {
                showAlert(title: "No Photos Selected", message: "Please select photos to delete.")
                return
            }

            deleteSelectedPhotos()
        }

    func deleteSelectedPhotos() {
        var album = currentAlbum

        for indexPath in selectedPhotos.sorted(by: { $0.item > $1.item }) {
            album.photos.remove(at: indexPath.item)
        }

        currentAlbum = album
        selectedPhotos.removeAll()
        collectionView.reloadData()
    }

    
    func showAlert(title: String, message: String) {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    
    /*
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }*/
    
    
    
    func handleClassificationResult(_ result: String, for image: UIImage) {
        print("Handling classification result: \(result)")
        DispatchQueue.main.async {
            if let album = self.albums.first(where: { $0.name.lowercased() == result.lowercased() }) {
                album.photos.append(image)
                if album.name == self.currentAlbum.name {
                    self.collectionView.reloadData()
                }
            } else {
                print("Unable to find matching album for category: \(result)")
                self.showAlert(title: "Error", message: "Unable to find matching album for category: \(result)")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showOverallAnalysisSegue" {
            if let analysisVC = segue.destination as? OverallAnalysisViewController {
                // No need to set albums here since OverallAnalysisViewController gets albums from AlbumManager
            }
        }
    }

    

    
    
    @IBAction func showOverallAnalysis(_ sender: UIButton) {
        guard let analysisVC = storyboard?.instantiateViewController(withIdentifier: "OverallAnalysisViewController") as? OverallAnalysisViewController else { return }
        analysisVC.modalPresentationStyle = .popover
        present(analysisVC, animated: true, completion: nil)
    }

    
}

            
//---------------------------------------------------------------------------------
// --------------- Model Classification Code ---------------------------------------
//---------------------------------------------------------------------------------
/*
    func classifyImage(_ image: UIImage) {
        print("Starting image classification")
        
        guard let modelURL = Bundle.main.url(forResource: "ClothingClassifier", withExtension: "mlmodelc") else {
            print("Failed to find model file")
            DispatchQueue.main.async {
                self.showAlert(title: "Error", message: "Model file not found.")
            }
            return
        }
        
        do {
            let model = try VNCoreMLModel(for: MLModel(contentsOf: modelURL))
            let request = VNCoreMLRequest(model: model) { [weak self] request, error in
                if let error = error {
                    print("Classification error: \(error)")
                    DispatchQueue.main.async {
                        self?.showAlert(title: "Error", message: "Classification error: \(error.localizedDescription)")
                    }
                    return
                }
                guard let results = request.results as? [VNClassificationObservation],
                      let topResult = results.first else {
                    print("No classification results")
                    DispatchQueue.main.async {
                        self?.showAlert(title: "Error", message: "Unable to classify image.")
                    }
                    return
                }

                print("Classification result: \(topResult.identifier) with confidence: \(topResult.confidence)")

                DispatchQueue.main.async {
                    self?.handleClassificationResult(topResult.identifier, for: image)
                }
            }

            guard let ciImage = CIImage(image: image) else {
                print("Unable to create CIImage from UIImage")
                DispatchQueue.main.async {
                    self.showAlert(title: "Error", message: "Unable to create CIImage from UIImage")
                }
                return
            }

            let handler = VNImageRequestHandler(ciImage: ciImage)
            DispatchQueue.global(qos: .userInteractive).async {
                do {
                    try handler.perform([request])
                } catch {
                    print("Failed to perform classification: \(error)")
                    DispatchQueue.main.async {
                        self.showAlert(title: "Error", message: "Failed to perform classification.")
                    }
                }
            }
        } catch {
            print("Failed to load model: \(error)")
            DispatchQueue.main.async {
                self.showAlert(title: "Error", message: "Failed to load model.")
            }
        }
    }

*/
