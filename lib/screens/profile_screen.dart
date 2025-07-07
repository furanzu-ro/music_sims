import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../utils/constants.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  String _artistName = '';
  String _realName = '';
  int _age = 0;
  String _profilePicture = '';
  String _gender = 'Male';
  String _description = '';
  String _genre = 'Classical';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Your Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Artist Name',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) => value == null || value.isEmpty ? 'Please enter artist name' : null,
                onSaved: (value) => _artistName = value ?? '',
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Real Name',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) => value == null || value.isEmpty ? 'Please enter real name' : null,
                onSaved: (value) => _realName = value ?? '',
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Age',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter age';
                  final age = int.tryParse(value);
                  if (age == null || age <= 0) return 'Please enter a valid age';
                  return null;
                },
                onSaved: (value) => _age = int.tryParse(value ?? '0') ?? 0,
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Profile Picture URL',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                onSaved: (value) => _profilePicture = value ?? '',
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Gender',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                value: _gender,
                items: const [
                  DropdownMenuItem(value: 'Male', child: Text('Male')),
                  DropdownMenuItem(value: 'Female', child: Text('Female')),
                ],
                onChanged: (value) => setState(() => _gender = value ?? 'Male'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                maxLines: 3,
                onSaved: (value) => _description = value ?? '',
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Genre',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                value: _genre,
                items: const [
                  DropdownMenuItem(value: 'Classical', child: Text('Classical')),
                  DropdownMenuItem(value: 'Pop', child: Text('Pop')),
                  DropdownMenuItem(value: 'Rock', child: Text('Rock')),
                  DropdownMenuItem(value: 'Hip-hop', child: Text('Hip-hop')),
                  DropdownMenuItem(value: 'Electronic', child: Text('Electronic')),
                  DropdownMenuItem(value: 'Jazz', child: Text('Jazz')),
                  DropdownMenuItem(value: 'Blues', child: Text('Blues')),
                  DropdownMenuItem(value: 'Country', child: Text('Country')),
                  DropdownMenuItem(value: 'Folk', child: Text('Folk')),
                ],
                onChanged: (value) => setState(() => _genre = value ?? 'Classical'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    _formKey.currentState?.save();
                    final gameProvider = Provider.of<GameProvider>(context, listen: false);
                    gameProvider.setProfile(
                      artistName: _artistName,
                      realName: _realName,
                      age: _age,
                      profilePicture: _profilePicture,
                      gender: _gender,
                      description: _description,
                      genre: _genre,
                    );
                    Navigator.pushNamed(context, '/date_selection');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Next',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
