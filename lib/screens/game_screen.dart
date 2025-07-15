import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../utils/constants.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {

  final _formKey = GlobalKey<FormState>();
  late AnimationController _musicNoteController;
  late Animation<double> _musicNoteAnimation;

  // Form fields
  String _artistName = '';
  String _realName = '';
  int _age = 0;
  String _profilePicture = '';
  String _gender = 'Male';
  String _description = '';
  String _genre = 'Pop';
  String _country = 'USA';
  int _startingYear = DateTime.now().year;

  @override
  void initState() {
    super.initState();
    _musicNoteController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
    _musicNoteAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _musicNoteController,
      curve: Curves.easeInOut,
    ));
  }

  Widget _buildImagePickerField() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: cardColor.withOpacity(0.85),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: primaryColor.withOpacity(0.4)),
      ),
      child: InkWell(
        onTap: () async {
          final ImagePicker picker = ImagePicker();
          final XFile? image =
              await picker.pickImage(source: ImageSource.gallery);
          if (image != null) {
            setState(() {
              _profilePicture = image.path;
            });
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            children: [
              const Icon(Icons.image, color: accentColor),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  _profilePicture.isEmpty
                      ? 'Select Profile Picture (Optional)'
                      : _profilePicture.split('/').last,
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.85), fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (_profilePicture.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _profilePicture = '';
                    });
                  },
                  child: const Icon(Icons.close, color: Colors.white70),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _musicNoteController.dispose();
    super.dispose();
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<GameProvider>(
        builder: (context, gameProvider, child) {

          if (!gameProvider.isProfileComplete) {
            // Show profile creation form
            return Stack(
              fit: StackFit.expand,
              children: [
                // Clean solid background color instead of image and gradient
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        bgColor.withOpacity(0.95),
                        primaryColor.withOpacity(0.95),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
                SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // Header
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: cardColor.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 15,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.person_add,
                                  size: 60,
                                  color: accentColor,
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'Create Your Artist Profile',
                                  style: TextStyle(
                                    fontFamily: 'PressStart2P',
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Tell us about your musical journey',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white.withOpacity(0.8),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Form fields
                          _buildFormField(
                            label: 'Artist Name',
                            icon: Icons.music_note,
                            validator: (value) => value == null || value.isEmpty
                                ? 'Please enter artist name'
                                : null,
                            onSaved: (value) => _artistName = value ?? '',
                          ),
                          const SizedBox(height: 12),

                          _buildFormField(
                            label: 'Real Name',
                            icon: Icons.person,
                            validator: (value) => value == null || value.isEmpty
                                ? 'Please enter real name'
                                : null,
                            onSaved: (value) => _realName = value ?? '',
                          ),
                          const SizedBox(height: 12),

                          _buildFormField(
                            label: 'Age',
                            icon: Icons.cake,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter age';
                              }
                              final age = int.tryParse(value);
                              if (age == null || age <= 0) {
                                return 'Please enter a valid age';
                              }
                              return null;
                            },
                            onSaved: (value) =>
                                _age = int.tryParse(value ?? '0') ?? 0,
                          ),
                          const SizedBox(height: 12),

                          _buildDropdownField(
                            label: 'Country',
                            icon: Icons.public,
                            value: _country,
                            items: const ['USA', 'UK', 'Brazil', 'France'],
                            onChanged: (value) =>
                                setState(() => _country = value ?? 'USA'),
                          ),
                          const SizedBox(height: 12),

                          _buildDropdownField(
                            label: 'Gender',
                            icon: Icons.person_outline,
                            value: _gender,
                            items: const ['Male', 'Female', 'Other'],
                            onChanged: (value) =>
                                setState(() => _gender = value ?? 'Male'),
                          ),
                          const SizedBox(height: 12),

                          _buildFormField(
                            label: 'Description',
                            icon: Icons.description,
                            maxLines: 3,
                            onSaved: (value) => _description = value ?? '',
                          ),
                          const SizedBox(height: 12),

                          _buildDropdownField(
                            label: 'Genre',
                            icon: Icons.library_music,
                            value: _genre,
                            items: const [
                               'Pop',
                              'Classical',
                              'Rock',
                              'Hip-hop',
                              'Electronic',
                              'Jazz',
                              'Blues',
                              'Country',
                              'Folk'
                            ],
                            onChanged: (value) =>
                                setState(() => _genre = value ?? 'Pop'),
                          ),
                          const SizedBox(height: 12),

                          _buildFormField(
                            label: 'Year',
                            icon: Icons.calendar_today,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter year';
                              }
                              final year = int.tryParse(value);
                              if (year == null ||
                                  year < 1900 ||
                                  year > DateTime.now().year) {
                                return 'Please enter a valid year';
                              }
                              return null;
                            },
                            onSaved: (value) => _startingYear = int.tryParse(
                                    value ?? DateTime.now().year.toString()) ??
                                DateTime.now().year,
                          ),
                          const SizedBox(height: 12),

                          _buildImagePickerField(),
                          const SizedBox(height: 24),

                          // Create Artist Button
                          _buildCreateArtistButton(gameProvider),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          }

          // Removed Game Home Screen UI code as per request
          // Returning an empty container instead
          return Container();
        },
      ),
    );
  }

  Widget _buildCreateArtistButton(GameProvider gameProvider) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState?.validate() ?? false) {
            _formKey.currentState?.save();

            // Show cool loading dialog with music note animation
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => Center(
                child: Card(
                  color: cardColor,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedBuilder(
                          animation: _musicNoteAnimation,
                          builder: (context, child) {
                            return Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [
                                    accentColor.withOpacity(0.3),
                                    accentColor,
                                  ],
                                  stops: [0.0, _musicNoteAnimation.value],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                ),
                              ),
                              child: const Icon(
                                Icons.music_note,
                                color: Colors.white,
                                size: 30,
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Creating your artist profile...',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );

            // Simulate loading
            await Future.delayed(const Duration(seconds: 2));

            gameProvider.setProfile(
              artistName: _artistName,
              realName: _realName,
              age: _age,
              profilePicture: _profilePicture,
              gender: _gender,
              description: _description,
              genre: _genre,
            );
            gameProvider.startNewGame(DateTime(_startingYear, 1, 1));

            Navigator.of(context).pop(); // Close loading dialog
            Navigator.pushReplacementNamed(context, '/main_navigation');
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: accentColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          elevation: 10,
          shadowColor: accentColor.withOpacity(0.6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.star, size: 26),
            SizedBox(width: 12),
            Text(
              'Create Artist',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    offset: Offset(1, 1),
                    blurRadius: 3,
                    color: Colors.black45,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    void Function(String?)? onSaved,
    TextInputType? keyboardType,
    int maxLines = 1,
    double fontSize = 14,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: cardColor.withOpacity(0.85),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: primaryColor.withOpacity(0.4)),
      ),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
              color: Colors.white.withOpacity(0.85), fontSize: fontSize),
          prefixIcon: Icon(icon, color: accentColor),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        ),
        style: TextStyle(color: Colors.white, fontSize: fontSize),
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: validator,
        onSaved: onSaved,
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required IconData icon,
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
    double fontSize = 14,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: cardColor.withOpacity(0.85),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: primaryColor.withOpacity(0.4)),
      ),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
              color: Colors.white.withOpacity(0.85), fontSize: fontSize),
          prefixIcon: Icon(icon, color: accentColor),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        ),
        value: value,
        dropdownColor: cardColor,
        style: TextStyle(color: Colors.white, fontSize: fontSize),
        items: items
            .map((item) => DropdownMenuItem(
                  value: item,
                  child:
                      Text(item, style: const TextStyle(color: Colors.white)),
                ))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }

}