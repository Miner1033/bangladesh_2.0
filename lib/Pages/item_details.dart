// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:photo_view/photo_view.dart';
// import 'package:photo_view/photo_view_gallery.dart';
// import 'package:url_launcher/url_launcher.dart';

// class ItemDetailsPage extends StatelessWidget {
//   final Map<String, dynamic> item;

//   ItemDetailsPage({required this.item});

//   @override
//   Widget build(BuildContext context) {
//     List<String> photoPaths = [];
//     if (item['photos'] != null && item['photos'] is List) {
//       photoPaths = List<String>.from(item['photos']);
//     }

//     return Scaffold(
//       backgroundColor: const Color(0xfff5f5f5),
//       appBar: AppBar(
//         title: Text(item['name'] ?? 'Item Details'),
//         backgroundColor: Colors.teal,
//         elevation: 4,
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [

//             Center(
//               child: GestureDetector(
//                 onTap: () {
//                   if (item['profile_pic'] != null &&
//                       item['profile_pic'].isNotEmpty) {
//                     _openFullScreenPhoto([item['profile_pic']], 0, context);
//                   }
//                 },
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(16),
//                   child: Container(
//                     width: 250,
//                     height: 250,
//                     decoration: BoxDecoration(
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black12,
//                           blurRadius: 8,
//                           spreadRadius: 2,
//                         ),
//                       ],
//                       borderRadius: BorderRadius.circular(16),
//                       border: Border.all(color: Colors.teal, width: 2),
//                       gradient: LinearGradient(
//                         colors: [Colors.orangeAccent, Colors.yellowAccent],
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                       ),
//                     ),
//                     child: item['profile_pic'] != null &&
//                             item['profile_pic'].isNotEmpty
//                         ? ClipRRect(
//                             borderRadius: BorderRadius.circular(16),
//                             child: Image.network(
//                               item['profile_pic'],
//                               width: 250,
//                               height: 250,
//                               fit: BoxFit.cover,
//                               errorBuilder: (context, error, stackTrace) =>
//                                   Center(
//                                 child: Icon(Icons.person,
//                                     size: 250, color: Colors.grey),
//                               ),
//                             ),
//                           )
//                         : Center(
//                             child: Icon(Icons.person,
//                                 size: 250, color: Colors.grey)),
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(height: 16.0),

//             // Name Section
//             Text(
//               'Name: ${item['name'] ?? 'N/A'}',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 8.0),

//             // Phone Section with Icon Indicator
//             Row(
//               children: [
//                 Expanded(
//                   child: Text(
//                     item['phone']?.isNotEmpty == true
//                         ? item['phone']
//                         : 'No number available',
//                     style: TextStyle(
//                       fontSize: 16,
//                       color: item['phone']?.isNotEmpty == true
//                           ? Colors.green
//                           : Colors.redAccent,
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.call, color: Colors.green),
//                   onPressed: () => _makePhoneCall(item['phone'], context),
//                   tooltip: 'Call',
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.message, color: Colors.blue),
//                   onPressed: () => _sendSms(item['phone'], context),
//                   tooltip: 'Message',
//                 ),
//               ],
//             ),

//             SizedBox(height: 16.0),
//             Column(
//               children: [
//                 Text(
//                   'Father name: ${item['father_name']?.isNotEmpty == true ? item['father_name'] : 'N/A'}',
//                 ),
//                 SizedBox(
//                   height: 5,
//                 ),
//                 Text(
//                   'Mother name: ${item['mother_name']?.isNotEmpty == true ? item['mother_name'] : 'N/A'}',
//                 ),
//                 SizedBox(
//                   height: 5,
//                 ),
//                 Text(
//                   'Date Of Birth: ${item['date_of_birth']?.isNotEmpty == true ? item['date_of_birth'] : 'N/A'}',
//                 ),
//                 SizedBox(
//                   height: 5,
//                 ),
//                 Text(
//                   'District: ${item['district']?.isNotEmpty == true ? item['district'] : 'N/A'}',
//                 ),
//                 SizedBox(
//                   height: 5,
//                 ),
//                 Text(
//                   'Sub District: ${item['sub_district']?.isNotEmpty == true ? item['sub_district'] : 'N/A'}',
//                 ),
//                 SizedBox(
//                   height: 5,
//                 ),
//                 Text(
//                   'Section: ${item['category']?.isNotEmpty == true ? item['category'] : 'N/A'}',
//                 ),
//               ],
//             ),
//             // Expanded Personal Details Section with ExpansionTileList
//             ExpansionTileList(
//               children: [
//                 // ExpansionTile(
//                 //   title: Text(
//                 //     'Personal Details:',
//                 //     style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
//                 //   ),
//                 //   children: [
//                 //     Padding(
//                 //       padding: EdgeInsets.all(16.0),
//                 //       child: Text(
//                 //         item['personal_details']?.isNotEmpty == true
//                 //             ? item['personal_details']
//                 //             : 'N/A',
//                 //         style: TextStyle(fontSize: 16),
//                 //       ),
//                 //     ),
//                 //   ],
//                 // ),

//                 ExpansionTile(
//                   title: Text(
//                     'Description:',
//                     style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
//                   ),
//                   children: [
//                     Padding(
//                       padding: EdgeInsets.all(16.0),
//                       child: Text(
//                         item['description']?.isNotEmpty == true
//                             ? item['description']
//                             : 'No description provided.',
//                         style: TextStyle(fontSize: 16),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//               onExpansionChanged: (int index, bool isExpanded) {
//                 // Optional: Perform any additional actions when expanded or collapsed
//               },
//             ),
//             SizedBox(height: 16.0),

//             Text(
//               'Photos:',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 8.0),
//             photoPaths.isNotEmpty
//                 ? Container(
//                     height: 200,
//                     child: ListView.builder(
//                       scrollDirection: Axis.horizontal,
//                       itemCount: photoPaths.length,
//                       itemBuilder: (context, index) {
//                         final photoPath = photoPaths[index];

//                         return GestureDetector(
//                           onTap: () {
//                             _openFullScreenPhoto(photoPaths, index, context);
//                           },
//                           child: Padding(
//                             padding:
//                                 const EdgeInsets.symmetric(horizontal: 8.0),
//                             child: ClipRRect(
//                               borderRadius: BorderRadius.circular(12),
//                               child: Image.network(
//                                 photoPath,
//                                 width: 180,
//                                 height: 200,
//                                 fit: BoxFit.cover,
//                                 loadingBuilder:
//                                     (context, child, loadingProgress) {
//                                   if (loadingProgress == null) return child;
//                                   return Container(
//                                     width: 180,
//                                     height: 200,
//                                     color: Colors.grey[300],
//                                     child: Center(
//                                         child: CircularProgressIndicator()),
//                                   );
//                                 },
//                                 errorBuilder: (context, error, stackTrace) =>
//                                     Container(
//                                   width: 180,
//                                   height: 200,
//                                   color: Colors.grey[300],
//                                   child: Center(
//                                     child: Icon(Icons.broken_image,
//                                         size: 50, color: Colors.redAccent),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   )
//                 : Center(child: Text('No photos available.')),
//             SizedBox(height: 16.0),

//             // Videos Section
//             Text(
//               'Videos:',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 8.0),
//             if (item['videos'] != null && item['videos'].isNotEmpty)
//               Container(
//                 height: 200,
//                 child: ListView.builder(
//                   scrollDirection: Axis.horizontal,
//                   itemCount: item['videos'].length,
//                   itemBuilder: (context, index) {
//                     return Container(
//                       width: 180,
//                       margin: EdgeInsets.symmetric(horizontal: 8.0),
//                       color: Colors.grey[300],
//                       child: Center(
//                         child: Text('Video ${index + 1}'),
//                       ),
//                     );
//                   },
//                 ),
//               )
//             else
//               Center(child: Text('No videos available.')),
//             SizedBox(height: 16.0),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> _makePhoneCall(String? phoneNumber, BuildContext context) async {
//     if (phoneNumber == null || phoneNumber.isEmpty) {
//       _showSnackBar(context, 'Number not exist');
//       return;
//     }
//     final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
//     try {
//       await launchUrl(launchUri);
//     } catch (e) {
//       debugPrint('Error launching CALL URI: $e');
//       _showSnackBar(context, 'Unable to make the call');
//     }
//   }

//   Future<void> _sendSms(String? phoneNumber, BuildContext context) async {
//     if (phoneNumber == null || phoneNumber.isEmpty) {
//       _showSnackBar(context, 'Number not exist');
//       return;
//     }
//     final Uri launchUri = Uri(scheme: 'sms', path: phoneNumber);
//     try {
//       await launchUrl(launchUri);
//     } catch (e) {
//       debugPrint('Error launching SMS URI: $e');
//       _showSnackBar(context, 'Unable to send message');
//     }
//   }

//   void _collapseOtherExpansion(BuildContext context, String expandSection) {
//     // Ensure this part is handled carefully if you want to expand or collapse other expansion tiles
//   }

//   void _openFullScreenPhoto(
//       List<String> photoPaths, int index, BuildContext context) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) =>
//             FullScreenPhotoView(photoPaths: photoPaths, initialIndex: index),
//       ),
//     );
//   }

//   // Function to show SnackBar with message
//   void _showSnackBar(BuildContext context, String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(
//           message,
//           style: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         backgroundColor: Colors.redAccent,
//         duration: const Duration(seconds: 2),
//       ),
//     );
//   }
// }

// class FullScreenPhotoView extends StatelessWidget {
//   final List<String> photoPaths;
//   final int initialIndex;

//   FullScreenPhotoView({required this.photoPaths, this.initialIndex = 0});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Full-Screen Photo'),
//         backgroundColor: Colors.teal,
//         elevation: 4,
//       ),
//       body: PhotoViewGallery.builder(
//         itemCount: photoPaths.length,
//         builder: (context, index) {
//           return PhotoViewGalleryPageOptions(
//             imageProvider:
//                 NetworkImage(photoPaths[index]), // ✅ Use NetworkImage
//             minScale: PhotoViewComputedScale.contained,
//             maxScale: PhotoViewComputedScale.covered * 2,
//           );
//         },
//         loadingBuilder: (context, event) => Center(
//           child: CircularProgressIndicator(),
//         ),
//         backgroundDecoration: BoxDecoration(color: Colors.black),
//         pageController: PageController(initialPage: initialIndex),
//       ),
//     );
//   }
// }

// class ExpansionTileList extends StatelessWidget {
//   final List<Widget> children;

//   ExpansionTileList(
//       {required this.children,
//       required Null Function(int index, bool isExpanded) onExpansionChanged});

//   @override
//   Widget build(BuildContext context) {
//     return ListView(
//       physics: NeverScrollableScrollPhysics(),
//       shrinkWrap: true,
//       children: children,
//     );
//   }
// }

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:url_launcher/url_launcher.dart';

class ItemDetailsPage extends StatelessWidget {
  final Map<String, dynamic> item;

  ItemDetailsPage({required this.item});

  @override
  Widget build(BuildContext context) {
    List<String> photoPaths =
        item['photos'] is List ? List<String>.from(item['photos']) : [];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(item['name'] ?? 'Item Details',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.teal,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Picture
            Center(
              child: InkWell(
                onTap: () {
                  if (item['profile_pic'] != null &&
                      item['profile_pic'].isNotEmpty) {
                    _openFullScreenPhoto([item['profile_pic']], 0, context);
                  }
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    width: 220,
                    height: 220,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            spreadRadius: 2)
                      ],
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.teal, width: 2),
                    ),
                    child: item['profile_pic'] != null &&
                            item['profile_pic'].isNotEmpty
                        ? Image.network(
                            item['profile_pic'],
                            width: 220,
                            height: 220,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Center(
                                    child: Icon(Icons.person,
                                        size: 100, color: Colors.grey)),
                          )
                        : Center(
                            child: Icon(Icons.person,
                                size: 100, color: Colors.grey)),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),

            // Information Card
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 3,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow("Name", item['name']),
                    _buildInfoRow("Father Name", item['father_name']),
                    _buildInfoRow("Mother Name", item['mother_name']),
                    _buildInfoRow("Date of Birth", item['date_of_birth']),
                    _buildInfoRow("District", item['district']),
                    _buildInfoRow("Sub District", item['sub_district']),
                    _buildInfoRow("Section", item['category']),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),

            // Phone Section
            // Card(
            //   shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(12)),
            //   elevation: 3,
            //   child: ListTile(
            //     leading: Icon(Icons.phone, color: Colors.teal),
            //     title: Text(item['phone']?.isNotEmpty == true
            //         ? item['phone']
            //         : "No number available"),
            //     subtitle: Row(
            //       children: [
            //         IconButton(
            //           icon: Icon(Icons.call, color: Colors.green),
            //           onPressed: () => _makePhoneCall(item['phone'], context),
            //         ),
            //         IconButton(
            //           icon: Icon(Icons.message, color: Colors.blue),
            //           onPressed: () => _sendSms(item['phone'], context),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),

            // Phone Section - Improved UI
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              elevation: 5,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: LinearGradient(
                    colors: [Colors.teal.shade400, Colors.teal.shade700],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: Row(
                  children: [
                    // Phone Icon
                    CircleAvatar(
                      backgroundColor: Colors.white.withOpacity(0.2),
                      radius: 28,
                      child: Icon(Icons.phone, color: Colors.white, size: 28),
                    ),
                    SizedBox(width: 16),

                    // Phone Number Text
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Phone Number",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            item['phone']?.isNotEmpty == true
                                ? item['phone']
                                : "No number available",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Action Buttons (Call & SMS)
                    Row(
                      children: [
                        _buildActionButton(
                          icon: Icons.call,
                          color: Colors.greenAccent,
                          onTap: () => _makePhoneCall(item['phone'], context),
                        ),
                        SizedBox(width: 10),
                        _buildActionButton(
                          icon: Icons.message,
                          color: Colors.blueAccent,
                          onTap: () => _sendSms(item['phone'], context),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),

            // Description Section
            _buildExpandableSection("Description", item['description']),
            SizedBox(height: 16),

            // Photos Section
            _buildPhotoSection(photoPaths, context),
            SizedBox(height: 16),

            // Videos Section
            _buildVideoSection(item['videos']),
            SizedBox(height: 16),
          ],
        ),
      ),

      // Floating Action Button for Call & Message
      floatingActionButton: item['phone']?.isNotEmpty == true
          ? FloatingActionButton.extended(
              onPressed: () => _makePhoneCall(item['phone'], context),
              icon: Icon(Icons.call),
              label: Text("Call Now"),
              backgroundColor: Colors.teal,
            )
          : null,
    );
  }

  Widget _buildInfoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Text("$label:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          SizedBox(width: 8),
          Expanded(
            child: Text(value?.isNotEmpty == true ? value! : "N/A",
                style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }

// Helper Method for Action Buttons
  Widget _buildActionButton(
      {required IconData icon,
      required Color color,
      required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: CircleAvatar(
        backgroundColor: color.withOpacity(0.2),
        radius: 24,
        child: Icon(icon, color: color, size: 26),
      ),
    );
  }

  Widget _buildExpandableSection(String title, String? content) {
    return ExpansionTile(
      title: Text(title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      children: [
        Padding(
          padding: EdgeInsets.all(16),
          child: Text(
              content?.isNotEmpty == true ? content! : "No details provided."),
        ),
      ],
    );
  }

  Widget _buildPhotoSection(List<String> photoPaths, BuildContext context) {
    if (photoPaths.isEmpty) return Center(child: Text("No photos available."));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Photos",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        SizedBox(height: 8),
        CarouselSlider(
          options: CarouselOptions(
              height: 200, enlargeCenterPage: true, autoPlay: true),
          items: photoPaths.map((path) {
            return InkWell(
              onTap: () => _openFullScreenPhoto(
                  photoPaths, photoPaths.indexOf(path), context),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  path,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey,
                      child: Icon(Icons.broken_image,
                          size: 50, color: Colors.red)),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildVideoSection(List<String>? videos) {
    if (videos == null || videos.isEmpty)
      return Center(child: Text("No videos available."));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Videos",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        SizedBox(height: 8),
        Container(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: videos.length,
            itemBuilder: (context, index) {
              return Container(
                width: 180,
                margin: EdgeInsets.symmetric(horizontal: 8.0),
                color: Colors.grey[300],
                child: Center(child: Text("Video ${index + 1}")),
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> _makePhoneCall(String? phoneNumber, BuildContext context) async {
    if (phoneNumber?.isEmpty == true) {
      _showSnackBar(context, "Number not available");
      return;
    }
    await launchUrl(Uri(scheme: 'tel', path: phoneNumber));
  }

  Future<void> _sendSms(String? phoneNumber, BuildContext context) async {
    if (phoneNumber?.isEmpty == true) {
      _showSnackBar(context, "Number not available");
      return;
    }
    await launchUrl(Uri(scheme: 'sms', path: phoneNumber));
  }

  void _openFullScreenPhoto(
      List<String> photoPaths, int index, BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => FullScreenPhotoView(
                photoPaths: photoPaths, initialIndex: index)));
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.redAccent));
  }
}

// class FullScreenPhotoView extends StatelessWidget {
//   final List<String> photoPaths;
//   final int initialIndex;

//   FullScreenPhotoView({required this.photoPaths, this.initialIndex = 0});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Full-Screen Photo'),
//         backgroundColor: Colors.teal,
//         elevation: 4,
//       ),
//       body: PhotoViewGallery.builder(
//         itemCount: photoPaths.length,
//         builder: (context, index) {
//           return PhotoViewGalleryPageOptions(
//             imageProvider:
//                 NetworkImage(photoPaths[index]), // ✅ Use NetworkImage
//             minScale: PhotoViewComputedScale.contained,
//             maxScale: PhotoViewComputedScale.covered * 2,
//           );
//         },
//         loadingBuilder: (context, event) => Center(
//           child: CircularProgressIndicator(),
//         ),
//         backgroundDecoration: BoxDecoration(color: Colors.black),
//         pageController: PageController(initialPage: initialIndex),
//       ),
//     );
//   }
// }

class FullScreenPhotoView extends StatelessWidget {
  final List<String> photoPaths;
  final int initialIndex;

  FullScreenPhotoView({required this.photoPaths, this.initialIndex = 0});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Full-Screen Photo'),
        backgroundColor: Colors.teal,
        elevation: 4,
      ),
      body: PhotoViewGallery.builder(
        itemCount: photoPaths.length,
        builder: (context, index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: CachedNetworkImageProvider(photoPaths[index]), // ✅ Cached image
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 2,
            errorBuilder: (context, error, stackTrace) => Image.asset(
              'assets/images/avatar.png', // placeholder if error
              fit: BoxFit.cover,
            ),
          );
        },
        loadingBuilder: (context, event) => Center(
          child: CircularProgressIndicator(),
        ),
        backgroundDecoration: BoxDecoration(color: Colors.black),
        pageController: PageController(initialPage: initialIndex),
      ),
    );
  }
}