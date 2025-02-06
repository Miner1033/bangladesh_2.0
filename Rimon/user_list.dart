import 'package:cloud_firestore/cloud_firestore.dart'; // Importing Firestore package for data handling.
import 'package:flutter/material.dart'; // Importing Flutter Material Design components.

class UsersListPage extends StatefulWidget {
  @override
  _UsersListPageState createState() => _UsersListPageState(); // Creating the state for this widget.
}

class _UsersListPageState extends State<UsersListPage> {
  // Reference to the Firestore 'users' collection to fetch user data.
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return Scaffold( // The main structure of the page.
      appBar: AppBar(title: Text("Users List")), // AppBar with the title 'Users List'.
      body: StreamBuilder<QuerySnapshot>( // StreamBuilder to listen to real-time updates from Firestore.
        stream: usersCollection.snapshots(), // Listening to the 'users' collection for real-time data.
        builder: (context, snapshot) {
          // If the connection is still waiting for data, show a loading spinner.
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          // If no data is found or the 'docs' list is empty, show a message.
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No users found"));
          }

          var users = snapshot.data!.docs; // List of users fetched from Firestore.

          // ListView.builder to display the fetched users in a scrollable list.
          return ListView.builder(
            itemCount: users.length, // The number of items in the list (users).
            itemBuilder: (context, index) {
              var user = users[index]; // Accessing the current user document.
              var data = user.data() as Map<String, dynamic>; // Extracting user data as a map.

              // Returning a Card widget for each user.
              return Card(
                margin: EdgeInsets.all(8), // Adding margin around each card.
                child: ListTile(
                  title: Text(data['name'] ?? 'No Name'), // Displaying the user's name, with a fallback if not available.
                  subtitle: Column( // Displaying the user's details in a column.
                    crossAxisAlignment: CrossAxisAlignment.start, // Aligning the text to the left.
                    children: [
                      Text("Email: ${data['email']}"), // Displaying user's email.
                      Text("Phone: ${data['phone']}"), // Displaying user's phone number.
                      Text("Category: ${data['category']}"), // Displaying user's category.
                      Text("Description: ${data['description']}"), // Displaying user's description.
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
