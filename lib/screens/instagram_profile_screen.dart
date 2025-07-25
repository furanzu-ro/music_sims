import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:musica_journey/utils/constants.dart';
import 'package:provider/provider.dart';
import '../models/instagram_post.dart';
import '../providers/game_provider.dart';

class InstagramProfileScreen extends StatefulWidget {
  const InstagramProfileScreen({super.key});

  @override
  State<InstagramProfileScreen> createState() => _InstagramProfileScreenState();
}

class _InstagramProfileScreenState extends State<InstagramProfileScreen> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImageAndPost() async {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);

    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage == null) return;

    // Get screen size to calculate appropriate crop window size
    final screenSize = MediaQuery.of(context).size;
    final safeAreaInsets = MediaQuery.of(context).padding;
    
    // Calculate a safe crop area that avoids phone UI elements
    final cropHeight = screenSize.height - safeAreaInsets.top - safeAreaInsets.bottom - 200; // Extra padding
    final cropWidth = screenSize.width - safeAreaInsets.left - safeAreaInsets.right - 40; // Extra padding
    
    // Use the smaller dimension to ensure square crop
    final cropSize = cropHeight < cropWidth ? cropHeight : cropWidth;
    
    // Crop the image with Instagram aspect ratio (1:1)
    final CroppedFile? croppedImage = await ImageCropper().cropImage(
      sourcePath: pickedImage.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      compressQuality: 90,
      compressFormat: ImageCompressFormat.jpg,
      maxWidth: 1080, // Instagram standard
      maxHeight: 1080, // Instagram standard
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: Colors.black,
          toolbarWidgetColor: Colors.white,
          statusBarColor: Colors.black,
          backgroundColor: Colors.black,
          activeControlsWidgetColor: accentColor,
          dimmedLayerColor: Colors.black.withOpacity(0.7),
          hideBottomControls: false,
          showCropGrid: true,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: true,
          cropFrameStrokeWidth: 2,
          cropFrameColor: Colors.white,
          cropGridRowCount: 3,
          cropGridColumnCount: 3,
        ),
        IOSUiSettings(
          title: 'Crop Image',
          aspectRatioLockEnabled: true,
          resetAspectRatioEnabled: false,
          minimumAspectRatio: 1.0,
        ),
      ],
    );

    if (croppedImage == null) return;

    final caption = await _showCaptionDialog(croppedImage.path);
    if (caption == null) return;

    // For simplicity, use cropped image path as imageUrl (in real app, upload to server)
    gameProvider.addPost(croppedImage.path, caption);
  }

  Future<String?> _showCaptionDialog(String imagePath) async {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    final gameState = gameProvider.gameState;
    final TextEditingController captionController = TextEditingController();
    
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.9,
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // App bar
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.grey, width: 0.2)),
                      color: Colors.black,
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        const Expanded(
                          child: Text(
                            'New Post',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(captionController.text);
                          },
                          child: const Text(
                            'Share',
                            style: TextStyle(
                              color: accentColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Content
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Image and caption section
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Image preview
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    File(imagePath),
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                
                                // Caption input
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // User info
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 14,
                                            backgroundImage: gameState.profilePicture.isNotEmpty
                                                ? NetworkImage(gameState.profilePicture)
                                                : null,
                                            child: gameState.profilePicture.isEmpty
                                                ? const Icon(Icons.person, size: 14)
                                                : null,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            gameState.artistName,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      
                                      // Caption text field
                                      TextField(
                                        controller: captionController,
                                        decoration: const InputDecoration(
                                          hintText: 'Write a caption...',
                                          border: InputBorder.none,
                                          isDense: true,
                                          contentPadding: EdgeInsets.zero,
                                          hintStyle: TextStyle(color: Colors.grey),
                                        ),
                                        style: const TextStyle(fontSize: 14, color: Colors.white),
                                        maxLines: 5,
                                        autofocus: true,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          const Divider(color: Colors.grey, thickness: 0.2),
                          
                          // Additional options (non-functional placeholders)
                          _buildOptionItem(Icons.person_add_outlined, 'Tag People'),
                          _buildOptionItem(Icons.location_on_outlined, 'Add Location'),
                          _buildOptionItem(Icons.music_note_outlined, 'Add Music'),
                          
                          const Divider(color: Colors.grey, thickness: 0.2),
                          
                          // Social sharing options (non-functional placeholders)
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Also share to',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                _buildSocialShareOption('Facebook', true),
                                _buildSocialShareOption('Twitter', false),
                                _buildSocialShareOption('Tumblr', false),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
  
  Widget _buildOptionItem(IconData icon, String label) {
    return InkWell(
      onTap: () {}, // Non-functional placeholder
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(icon, size: 24, color: Colors.white),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
            const Spacer(),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSocialShareOption(String platform, bool isEnabled) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Text(
            platform,
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
          const Spacer(),
          Switch(
            value: isEnabled,
            onChanged: (value) {}, // Non-functional placeholder
            activeColor: accentColor,
          ),
        ],
      ),
    );
  }

  void _showPostDetail(InstagramPost post) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _PostDetailScreen(post: post),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);
    final gameState = gameProvider.gameState;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          gameState.artistName,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickImageAndPost,
        shape: const CircleBorder(),
        backgroundColor: accentColor,
        child: const Icon(
          Icons.add_a_photo,
          color: Colors.white,
          size: 30.0,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(16), // adjust for roundness
                      image: gameState.profilePicture.isNotEmpty
                          ? DecorationImage(
                              image: NetworkImage(gameState.profilePicture),
                              fit: BoxFit.cover,
                            )
                          : null,
                      color: Colors.grey.shade400, // fallback background
                    ),
                    child: gameState.profilePicture.isEmpty
                        ? const Icon(Icons.person,
                            size: 40, color: Colors.white)
                        : null,
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _ProfileStat(
                            count: gameState.posts.length.toString(),
                            label: 'posts'),
                        const _ProfileStat(count: '0', label: 'followers'),
                        const _ProfileStat(count: '0', label: 'following'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                gameState.realName,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              child: Text(
                gameState.description,
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 24),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
              ),
              itemCount: gameState.posts.length,
              itemBuilder: (context, index) {
                final post = gameState.posts[index];
                return GestureDetector(
                  onTap: () => _showPostDetail(post),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      image: DecorationImage(
                        image: FileImage(
                          File(post.imageUrl),
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileStat extends StatelessWidget {
  final String count;
  final String label;

  const _ProfileStat({required this.count, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.grey, fontSize: 14),
        ),
      ],
    );
  }
}

class _PostDetailScreen extends StatelessWidget {
  final InstagramPost post;

  const _PostDetailScreen({required this.post});

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    final gameState = gameProvider.gameState;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Post',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Info Header
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundImage: gameState.profilePicture.isNotEmpty
                        ? NetworkImage(gameState.profilePicture)
                        : null,
                    child: gameState.profilePicture.isEmpty
                        ? const Icon(Icons.person, size: 16)
                        : null,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    gameState.artistName,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.more_vert, color: Colors.white),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            // Image
            Image.file(
              File(post.imageUrl),
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            // Action Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.favorite_border,
                        color: Colors.white, size: 28),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.chat_bubble_outline,
                        color: Colors.white, size: 28),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.send_outlined,
                        color: Colors.white, size: 28),
                    onPressed: () {},
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.bookmark_border,
                        color: Colors.white, size: 28),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            // Likes and Caption
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '0 likes', // Placeholder
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      children: [
                        TextSpan(
                          text: '${gameState.artistName} ',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: post.caption),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'View all 0 comments', // Placeholder
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '1 hour ago', // Placeholder
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

