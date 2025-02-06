

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );

  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: RequestDetailsPage(email: "shondip@gmail.com"),
  ));
}

class RequestDetailsPage extends StatelessWidget {
  final String email;

  const RequestDetailsPage({Key? key, required this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
          child: AppBar(
            backgroundColor: Colors.teal,
            leading: IconButton(
              icon:
                  const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 22),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              'Request Details',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22,
                letterSpacing: 1.2,
              ),
            ),

            centerTitle: true,
            elevation: 8,
            // shadowColor: Colors.black54,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: email)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("❌ No user found."));
          }
          var user = snapshot.data!.docs.first.data() as Map<String, dynamic>;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 🔹 Profile Picture (Clickable for Full Screen)
                GestureDetector(
                  onTap: () {
                    _openProfileViewer(context, user['profile_pic']);
                  },
                  child: Hero(
                    tag: 'profile_pic',
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.teal, width: 3),
                      ),
                      child: CircleAvatar(
                        radius: 65,
                        backgroundImage: user['profile_pic'] != null
                            ? CachedNetworkImageProvider(user['profile_pic'])
                            : const AssetImage('assets/default_profile.png')
                                as ImageProvider,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // 🔹 User Name
                Text(
                  user['name'] ?? "No Name",
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),

                // 🔹 Email
                Text(user['email'] ?? "No Email",
                    style: TextStyle(color: Colors.grey.shade700)),

                const SizedBox(height: 20),

                // 🔹 User Details (Card-based layout)
                _buildUserInfoCard(user),

                const SizedBox(height: 20),

                // 🔹 User Photos (Grid with Clickable Images)
                _buildUserPhotos(context, user),

                const SizedBox(height: 20),

                // 🔹 Approve & Reject Buttons
                _buildActionButtons(context, user['id']),
              ],
            ),
          );
        },
      ),
    );
  }

  // 🔹 User Info Card
  Widget _buildUserInfoCard(Map<String, dynamic> user) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildInfoTile("Category", user['category']),
            _buildInfoTile("Date of Birth", user['date_of_birth']),
            _buildInfoTile("Phone", user['phone']),
            _buildInfoTile("Father's Name", user['father_name']),
            _buildInfoTile("Mother's Name", user['mother_name']),
            _buildInfoTile("District", user['district']),
            _buildInfoTile("Sub-District", user['sub_district']),
            _buildInfoTile("Description", user['description']),
          ],
        ),
      ),
    );
  }

  // 🔹 User Photos Grid (With Click to View)
  Widget _buildUserPhotos(BuildContext context, Map<String, dynamic> user) {
    List<dynamic>? photos = user['photos'];

    if (photos == null || photos.isEmpty) {
      return const Center(child: Text("📷 No photos available"));
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: photos.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            _openPhotoViewer(context, photos, index);
          },
          child: Hero(
            tag: 'photo_$index',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: photos[index],
                placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
    );
  }

  // 🔹 Full-Screen Profile Picture Viewer
  void _openProfileViewer(BuildContext context, String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          body: Center(
            child: Hero(
              tag: 'profile_pic',
              child: PhotoView(
                imageProvider: CachedNetworkImageProvider(imageUrl),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 2,
              ),
            ),
          ),
        ),
      ),
    );
  }

// 🔹 Info Tile
  Widget _buildInfoTile(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text("$label: ",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Expanded(
            child: Text(value ?? "Not Provided",
                style: TextStyle(fontSize: 16, color: Colors.grey.shade700)),
          ),
        ],
      ),
    );
  }

  // 🔹 Full-Screen Photo Viewer
  void _openPhotoViewer(BuildContext context, List<dynamic> photos, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PhotoViewGallery.builder(
          itemCount: photos.length,
          builder: (context, index) {
            return PhotoViewGalleryPageOptions(
              imageProvider: CachedNetworkImageProvider(photos[index]),
              minScale: PhotoViewComputedScale.contained,
              maxScale: PhotoViewComputedScale.covered * 2,
            );
          },
          scrollPhysics: const BouncingScrollPhysics(),
          backgroundDecoration: const BoxDecoration(color: Colors.black),
          pageController: PageController(initialPage: index),
        ),
      ),
    );
  }

  // 🔹 Approve & Reject Buttons
  Widget _buildActionButtons(BuildContext context, String userId) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton.icon(
          onPressed: () => _approveUser(context, userId),
          icon: const Icon(Icons.check, color: Colors.white),
          label: const Text("Approve"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
        ),
        ElevatedButton.icon(
          onPressed: () => _rejectUser(context, userId),
          icon: const Icon(Icons.cancel, color: Colors.white),
          label: const Text("Reject"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
        ),
      ],
    );
  }

  // 🔹 Approve & Reject Functions (Same as before)
  void _approveUser(BuildContext context, String userId) async {/*...*/}
  void _rejectUser(BuildContext context, String userId) async {/*...*/}
}
