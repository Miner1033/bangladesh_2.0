import 'package:flutter/material.dart'; // Importing Material Design components.
import 'package:cloud_firestore/cloud_firestore.dart'; // Importing Firestore for data handling.
import 'package:firebase_auth/firebase_auth.dart'; // Importing Firebase Authentication for user login status.

// Creating a stateful widget to manage categories.
class ManageCategoriesPage extends StatefulWidget {
  @override
  _ManageCategoriesPageState createState() => _ManageCategoriesPageState(); // Creating the state for this widget.
}

class _ManageCategoriesPageState extends State<ManageCategoriesPage> {
  final TextEditingController _categoryController = TextEditingController(); // Controller for the category name text field.
  final CollectionReference categoriesCollection = FirebaseFirestore.instance.collection('categories'); // Reference to the Firestore 'categories' collection.

  // Function to check if the user is logged in.
  bool isUserLoggedIn() {
    return FirebaseAuth.instance.currentUser != null; // Returns true if the user is logged in, false otherwise.
  }

  // Function to add a new category to Firestore.
  void _addCategory() async {
    if (!isUserLoggedIn()) { // If the user is not logged in, show an error.
      _showError("You must be logged in to add categories.");
      return;
    }

    if (_categoryController.text.isNotEmpty) { // If the category name is not empty, proceed to add it.
      try {
        await categoriesCollection
            .add({'name': _categoryController.text.trim()}); // Adds the new category to the Firestore collection.
        _categoryController.clear(); // Clears the text field after adding the category.
      } catch (e) {
        _showError("Failed to add category: $e"); // If an error occurs, show an error message.
      }
    }
  }

  // Function to delete a category from Firestore by document ID.
  void _deleteCategory(String docId) async {
    if (!isUserLoggedIn()) { // If the user is not logged in, show an error.
      _showError("You must be logged in to delete categories.");
      return;
    }

    try {
      await categoriesCollection.doc(docId).delete(); // Deletes the category from Firestore by its document ID.
    } catch (e) {
      _showError("Failed to delete category: $e"); // If an error occurs, show an error message.
    }
  }

  // Function to display error messages using a SnackBar.
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar( // Displays the error message at the bottom of the screen.
      SnackBar(content: Text(message), backgroundColor: Colors.red), // The SnackBar has a red background for error messages.
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( // The main screen structure.
      backgroundColor: Colors.teal.shade50, // Sets the background color of the screen.
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60), // Customizing the height of the AppBar.
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)), // Rounding the bottom corners of the AppBar.
          child: AppBar(
            backgroundColor: Colors.teal, // AppBar color set to teal.
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 22), // Back button for navigation.
              onPressed: () => Navigator.pop(context), // Pops the current page off the navigation stack.
            ),
            title: const Text(
              'Manage Categories', // The title of the AppBar.
              style: const TextStyle(
                color: Colors.white, // Title text color.
                fontWeight: FontWeight.bold, // Title text weight.
                fontSize: 22, // Title text size.
                letterSpacing: 1.2, // Letter spacing for the title.
              ),
            ),
            centerTitle: true, // Centers the title in the AppBar.
            elevation: 8, // Adds shadow beneath the AppBar.
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Adds padding around the content.
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField( // Text field for entering category name.
                    controller: _categoryController, // Binds the text field to the controller.
                    decoration: const InputDecoration(
                      labelText: 'Category Name', // Label inside the text field.
                      border: OutlineInputBorder(), // Border around the text field.
                      hintText: 'Enter a new category', // Placeholder text inside the text field.
                    ),
                  ),
                ),
                const SizedBox(width: 10), // Adds space between the text field and button.
                ElevatedButton(
                  onPressed: _addCategory, // Calls _addCategory function when the button is pressed.
                  child: const Text('Add', style: TextStyle(color: Colors.white)), // Button text.
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal, // Button color set to teal.
                    shape: RoundedRectangleBorder( // Rounded corners for the button.
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20), // Adds space below the button.

            // Fetching and displaying categories from Firestore in real-time.
            Expanded(
              child: StreamBuilder<QuerySnapshot>( // Listening to Firestore changes using StreamBuilder.
                stream: categoriesCollection.snapshots(), // Stream that listens for updates in the 'categories' collection.
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) { // Shows a loading spinner while waiting for data.
                    return const Center(child: CircularProgressIndicator());
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) { // If no data is found, show a message.
                    return const Center(child: Text('No categories available.'));
                  } else {
                    final categoryList = snapshot.data!.docs; // The list of categories fetched from Firestore.
                    return ListView.builder( // Displaying categories in a scrollable list.
                      itemCount: categoryList.length, // Number of categories in the list.
                      itemBuilder: (context, index) {
                        final category = categoryList[index]; // Fetching the current category document.
                        final categoryName = category['name']; // Fetching the category name from the document.
                        return Card(
                          color: const Color(0xfff5f5f5), // Card background color.
                          margin: const EdgeInsets.symmetric(vertical: 8.0), // Margin around each card.
                          elevation: 4, // Adds shadow effect to the card.
                          child: ListTile( // Displays the category name.
                            title: Text(categoryName), // Displaying the category name.
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red), // Delete icon.
                              onPressed: () => _deleteCategory(category.id), // Calls _deleteCategory function when pressed.
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
