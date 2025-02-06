import 'dart:convert'; // Importing the 'convert' library to handle base64 image decoding.
import 'package:cloud_firestore/cloud_firestore.dart'; // Importing Firebase Firestore to fetch documents from Firestore.
import 'package:flutter/material.dart'; // Importing Flutter Material Design widgets for UI components.

import 'edit_list_admin.dart'; // Importing the edit document page to navigate and edit documents.

class ViewDocumentsPage extends StatefulWidget {
  @override
  _ViewDocumentsPageState createState() => _ViewDocumentsPageState(); // Creating the state for this widget.
}

class _ViewDocumentsPageState extends State<ViewDocumentsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Firestore instance for database operations.
  List<Map<String, dynamic>> documents = []; // List to hold documents fetched from Firestore.

  @override
  void initState() {
    super.initState();
    fetchDocuments(); // Fetch documents from Firestore when the page is loaded.
  }

  // Function to fetch documents from the 'users' collection in Firestore.
  Future<void> fetchDocuments() async {
    try {
      QuerySnapshot snapshot =
          await _firestore.collection('users').get(); // Fetch all documents from the 'users' collection.

      setState(() {
        // Mapping the fetched documents into a list of maps, with each document including its ID.
        documents = snapshot.docs
            .map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>})
            .toList();
      });
    } catch (e) {
      print('Error fetching documents: $e'); // Catch and log any errors during fetching.
    }
  }

  // Function to navigate to the edit page with the document data passed as arguments.
  void editDocument(BuildContext context, Map<String, dynamic> document) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditDocumentPage(
          document: document, // Passing document data.
          documentId: document['id'], // Passing the document ID.
        ),
      ),
    ).then((_) {
      fetchDocuments(); // Refresh the documents list after editing.
    });
  }

  // Function to show a confirmation dialog before deleting a document.
  void _showDeleteConfirmationDialog(String docId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Document?"),
          content: const Text(
              "Are you sure you want to delete this document? This action cannot be undone."),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          actions: [
            TextButton(
              child: const Text("Cancel", style: TextStyle(color: Colors.teal)),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog if cancel is pressed.
              },
            ),
            TextButton(
              child: const Text("Delete", style: TextStyle(color: Colors.redAccent)),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog and proceed with deletion.
                deleteDocument(docId); // Call the delete function.
              },
            ),
          ],
        );
      },
    );
  }

  // Function to delete a document from Firestore.
  void deleteDocument(String docId) async {
    try {
      await _firestore.collection('users').doc(docId).delete(); // Delete the document with the given ID.
      fetchDocuments(); // Refresh the list after deletion.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Document deleted successfully!")), // Show a success message.
      );
    } catch (e) {
      print('Error deleting document: $e'); // Catch and log any errors during deletion.
    }
  }

  // Function to build an image widget (profile picture) for each document.
  Widget buildImage(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      // If the imagePath is null or empty, show a default icon.
      return const Icon(Icons.person, size: 60, color: Colors.grey);
    }

    try {
      final decodedBytes = base64Decode(imagePath); // Try decoding the base64 image.
      return CircleAvatar(
        radius: 30,
        backgroundImage: MemoryImage(decodedBytes), // Show decoded image as profile picture.
      );
    } catch (e) {
      // If decoding fails, treat imagePath as a URL.
      return CircleAvatar(
        radius: 30,
        backgroundImage: NetworkImage(imagePath), // Assume the imagePath is a URL.
        onBackgroundImageError: (_, __) =>
            const Icon(Icons.broken_image, size: 60), // Show error icon if the image fails to load.
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade50, // Set background color.
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60), // Set the preferred height of the AppBar.
        child: ClipRRect(
          borderRadius:
              const BorderRadius.vertical(bottom: Radius.circular(20)), // Round the bottom corners of the AppBar.
          child: AppBar(
            backgroundColor: Colors.teal, // Set AppBar background color.
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new,
                  color: Colors.white, size: 22), // Back button.
              onPressed: () => Navigator.pop(context), // Pop the page when the back button is pressed.
            ),
            title: const Text(
              'View Documents',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22,
                letterSpacing: 1.2,
              ),
            ),
            centerTitle: true,
            elevation: 8, // Set elevation for AppBar.
          ),
        ),
      ),
      body: documents.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.hourglass_empty,
                      size: 100, color: Colors.grey),
                  const SizedBox(height: 10),
                  Text('No documents available.',
                      style: TextStyle(fontSize: 18, color: Colors.grey[600])),
                ],
              ),
            )
          : ListView.builder(
              itemCount: documents.length, // Number of documents to display.
              itemBuilder: (context, index) {
                final document = documents[index]; // Get the document at the current index.
                return Card(
                  color: const Color(0xfff5f5f5), // Set card background color.
                  margin:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10), // Set margin for the card.
                  elevation: 3, // Set card elevation.
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)), // Round card corners.
                  child: ListTile(
                    leading: buildImage(document['profile_pic']), // Display the user's profile picture.
                    title: Text(
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      document['name'] ?? 'Unknown Name', // Display the user's name.
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      document['phone'] ?? 'No Phone Number',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min, // Align the trailing buttons horizontally.
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue), // Edit button.
                          onPressed: () => editDocument(context, document), // Navigate to the edit page when pressed.
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red), // Delete button.
                          onPressed: () =>
                              _showDeleteConfirmationDialog(document['id']), // Show delete confirmation dialog.
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
