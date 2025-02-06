import 'package:flutter/material.dart'; // Importing material design components for UI
import 'package:cloud_firestore/cloud_firestore.dart'; // Importing Cloud Firestore for database interaction

// This is the ViewAllUsersPage widget that represents the page for viewing all users.
class ViewAllUsersPage extends StatefulWidget {
  @override
  State<ViewAllUsersPage> createState() => _ViewAllUsersPageState();
}

// The state class for managing the state of the ViewAllUsersPage widget
class _ViewAllUsersPageState extends State<ViewAllUsersPage> {
  // FirebaseFirestore instance to interact with Firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // This function returns a Stream of users who are not added by the admin (based on 'is_admin_added' field)
  Stream<List<Map<String, dynamic>>> getUsersStream() {
    return _firestore
        .collection('users') // Accessing the 'users' collection in Firestore
        .where('is_admin_added',
            isEqualTo: false) // Only get users not added by the admin
        .snapshots() // Getting real-time updates from the Firestore collection
        .map((snapshot) =>
            snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList()); // Mapping documents to a list of maps
  }

  // Function to delete a user from Firestore by their userId
  Future<void> deleteUser(String userId) async {
    try {
      // Deleting the user document from the 'users' collection by userId
      await _firestore.collection('users').doc(userId).delete();
    } catch (e) {
      print('Error deleting user: $e'); // Printing error in case of failure
    }
  }

  // Function to show a delete confirmation dialog
  void showDeleteDialog(String userId) {
    showDialog(
      context: context, // Current context for the dialog
      builder: (context) => AlertDialog(
        title: const Text("Delete User"), // Dialog title
        content: const Text("Are you sure you want to delete this user?"), // Dialog message
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Close the dialog if "Cancel" is pressed
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              deleteUser(userId); // Delete the user if "Delete" is pressed
              Navigator.pop(context); // Close the dialog after deletion
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)), // Delete button with red text color
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade50, // Setting background color for the scaffold
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60), // Setting app bar height
        child: ClipRRect(
          borderRadius:
              const BorderRadius.vertical(bottom: Radius.circular(20)), // Rounding the bottom corners of the app bar
          child: AppBar(
            backgroundColor: Colors.teal, // Setting app bar background color
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 22), // Back button
              onPressed: () => Navigator.pop(context), // Navigate back when pressed
            ),
            title: const Text(
              'All Users', // Title text in the app bar
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22,
                letterSpacing: 1.2,
              ),
            ),
            centerTitle: true, // Centering the title
            elevation: 8, // Adding elevation to the app bar
          ),
        ),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>( // StreamBuilder to listen to changes in the user data
        stream: getUsersStream(), // Providing the stream of user data
        builder: (context, snapshot) {
          // Checking the connection state to handle loading or error states
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator()); // Show loading spinner while waiting for data
          }

          // If no data is available, show a message indicating no users
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.hourglass_empty, size: 100, color: Colors.grey), // Empty icon
                  const SizedBox(height: 10),
                  Text(
                    'No user available.',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]), // No users message
                  ),
                ],
              ),
            );
          }

          // If data is available, display it in a ListView
          final documents = snapshot.data!;

          return ListView.builder(
            itemCount: documents.length, // Number of items in the list
            itemBuilder: (context, index) {
              final user = documents[index]; // Fetching user data at the current index

              return Card(
                color: const Color(0xfff5f5f5), // Setting card background color
                margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10), // Setting margin around the card
                elevation: 5, // Adding elevation to the card
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.teal, // Avatar color
                    child: Icon(Icons.person, color: Colors.white), // Avatar icon
                  ),
                  title: Text(
                    overflow: TextOverflow.ellipsis, // Handling overflow in title
                    maxLines: 1, // Limiting title to 1 line
                    user['name'] ?? 'Unknown Name', // Displaying user's name or 'Unknown Name' if not available
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold), // Styling title
                  ),
                  subtitle: Text(user['phone'] ?? 'No Phone Number'), // Displaying user's phone number
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), // Padding inside the trailing container
                    decoration: BoxDecoration(
                      color: (user['isApproved'] == 1 ||
                              user['isApproved'] == true) // Checking if the user is approved
                          ? Colors.green // Green if approved
                          : Colors.orange, // Orange if pending
                      borderRadius: BorderRadius.circular(12), // Rounding corners of the trailing container
                    ),
                    child: Text(
                      (user['isApproved'] == 1 ||
                              user['isApproved'] == true) // Display 'Approved' or 'Pending'
                          ? 'Approved'
                          : 'Pending',
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold), // Styling the approval status text
                    ),
                  ),
                  onLongPress: () => showDeleteDialog(user['id']), // Show delete dialog on long press
                ),
              );
            },
          );
        },
      ),
    );
  }
}
