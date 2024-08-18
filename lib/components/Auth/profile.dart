import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  final int id;
  final String name,phone,email,gender,password;

  
  const ProfilePage({Key? key,
                    required this.id,
                    required this.name,
                    required this.phone,
                    required this.email,
                    required this.gender,
                    required this.password
    });

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late SharedPreferences _prefs;
  String _name = '';
  String _email = '';
  String _phoneNumber = '';
  String _address = '';
  String? _gender;

  @override
  void initState() {
    super.initState();
    // _loadProfile();
  }

  // Future<void> _loadProfile() async {
  //   _prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     _name = _prefs.getString('name') ?? '';
  //     _email = _prefs.getString('email') ?? '';
  //     _phoneNumber = _prefs.getString('phoneNumber') ?? '';
  //     _address = _prefs.getString('address') ?? '';
  //     _gender = _prefs.getString('gender');
  //   });
  // }

  // Future<void> _saveProfile() async {
  //   await _prefs.setString('name', _name);
  //   await _prefs.setString('email', _email);
  //   await _prefs.setString('phoneNumber', _phoneNumber);
  //   await _prefs.setString('address', _address);
  //   await _prefs.setString('gender', _gender ?? '');
  // }

  void _showEditProfileDialog() {
    TextEditingController _nameController = TextEditingController(text: _name);
    TextEditingController _emailController =
        TextEditingController(text: _email);
    TextEditingController _phoneNumberController =
        TextEditingController(text: _phoneNumber);
    TextEditingController _addressController =
        TextEditingController(text: _address);
    String? _selectedGender = _gender;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Profile'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _phoneNumberController,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    labelText: 'Address',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: _selectedGender,
                  hint: Text('Select Gender'),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedGender = newValue;
                    });
                  },
                  items: <String>['Male', 'Female']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    labelText: 'Gender',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _name = _nameController.text;
                  _email = _emailController.text;
                  _phoneNumber = _phoneNumberController.text;
                  _address = _addressController.text;
                  _gender = _selectedGender;
                  // _saveProfile();
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Profile Updated')),
                );
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Page'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 80,
                backgroundImage: AssetImage(
                  widget.gender.toUpperCase() == 'MALE' ? 'assest/image/male.png' : 'assest/image/female.png',
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: 500,
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Name:',
                        style:
                            TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(widget.name, style: TextStyle(fontSize: 16)),
                      SizedBox(height: 10),
                      Text(
                        'Email:',
                        style:
                            TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(widget.email, style: TextStyle(fontSize: 16)),
                      SizedBox(height: 10),
                      Text(
                        'Phone Number:',
                        style:
                            TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(widget.phone, style: TextStyle(fontSize: 16)),
                      SizedBox(height: 10),
                      // Text(
                      //   'Address:',
                      //   style:
                      //       TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      // ),
                      // Text(_address, style: TextStyle(fontSize: 16)),
                      SizedBox(height: 10),
                      Text(
                        'Gender:',
                        style:
                            TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(widget.gender , style: TextStyle(fontSize: 16)),
                      SizedBox(height: 20),
                      // Center(
                      //   child: ElevatedButton(
                      //     onPressed: _showEditProfileDialog,
                      //     child: Text('Update Profile'),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
