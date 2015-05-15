# Meme-App
This MemeApp is submitted as a part of the 5 projects requested to fulfill the iOS Developer Nanodegree at Udacity.com

# Application usage and flow
The app has 3 main viewControllers; named and funcitoned as follows:

- MemeViewController "also known as MemeEditorViewController"
  - This is where the user picks an image from either the Device-Album or snapps one by the device's camera, then starts to edit it by adding a top and botton text fields.
  - It then allows the user to perform some sharing activities on the editedImage "the what so know as memedImage"
  - A shared MemedImage get saved into the app's memory "shared array - not presistance" and kept-in accessable as long as the app is not terminated.


- TabViewController:
  - This is where the shared-array's items got presented in both tableView and collectionView controllers.
  - TableView shows the sharedMemes into custom cells, presenting the memedImage, topText, and bottomText fields.
  - CollectionView shows the sharedMemes into customized cells, presenting only the memedImage into its whole cell view.
  - Both Table and Collection views have Edit button to enable the user to select and delete a cell view.
  - Both views can show the selected Meme Cell into a separated large view called MemeDetailsViewController.
  

- MemeDetailsViewController:
  - Issued to display the selected memedImage from a cell of either table or collection view into a separate large view.
  - Has 2 main buttons;
    - Edit: to trash the current displayed meme and launch the MemeEditorVC to start over.
    - Delete: to delete the current displayed meme and return back to the original selector screen "Table or CollectionVCs".
  - A Back button is presented to allow user to return back to the original selector screen "Table or CollectionVCs"
  
  
  
  
  
  
  


