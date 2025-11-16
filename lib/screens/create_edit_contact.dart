import 'package:flutter/material.dart';
import '../models/contact.dart';
import '../services/contact_storage.dart';

class CreateEditContactPage extends StatefulWidget {
  final Contact? contact;

  const CreateEditContactPage({this.contact});

  @override
  _CreateEditContactPageState createState() => _CreateEditContactPageState();
}

class _CreateEditContactPageState extends State<CreateEditContactPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameCtrl;
  late TextEditingController phoneCtrl;
  late TextEditingController emailCtrl;
  late TextEditingController addressCtrl;

  bool get isEditing => widget.contact != null;

  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController(text: widget.contact?.name ?? '');
    phoneCtrl = TextEditingController(text: widget.contact?.phone ?? '');
    emailCtrl = TextEditingController(text: widget.contact?.email ?? '');
    addressCtrl = TextEditingController(text: widget.contact?.address ?? '');
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    phoneCtrl.dispose();
    emailCtrl.dispose();
    addressCtrl.dispose();
    super.dispose();
  }

  Future<void> _saveContact() async {
    if (!_formKey.currentState!.validate()) return;

    final contact = Contact(
      id: widget.contact?.id ?? DateTime.now().toString(),
      name: nameCtrl.text.trim(),
      phone: phoneCtrl.text.trim(),
      email: emailCtrl.text.trim(),
      address: addressCtrl.text.trim(),
    );

    await ContactHive.saveContact(contact);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isEditing ? "Contact mis à jour" : "Contact créé"),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue[700]!, Colors.blue[500]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Text(
          isEditing ? "Modifier le contact" : "Nouveau contact",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(20),
          children: [
            _buildHeader(),
            SizedBox(height: 30),
            _buildTextField(
              controller: nameCtrl,
              label: "Nom complet",
              icon: Icons.person,
              validator: (val) => val!.isEmpty ? "Le nom est requis" : null,
            ),
            SizedBox(height: 16),
            _buildTextField(
              controller: phoneCtrl,
              label: "Numéro de téléphone",
              icon: Icons.phone,
              keyboardType: TextInputType.phone,
              validator: (val) => val!.isEmpty ? "Le téléphone est requis" : null,
            ),
            SizedBox(height: 16),
            _buildTextField(
              controller: emailCtrl,
              label: "Email (optionnel)",
              icon: Icons.email,
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 16),
            _buildTextField(
              controller: addressCtrl,
              label: "Adresse (optionnel)",
              icon: Icons.home,
              maxLines: 3,
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: _saveContact,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[700],
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
              ),
              child: Text(
                isEditing ? "Enregistrer les modifications" : "Créer le contact",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[100]!, Colors.blue[50]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(isEditing ? Icons.edit : Icons.person_add, size: 40, color: Colors.blue[700]),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              isEditing
                  ? "Modifiez les informations du contact"
                  : "Ajoutez un nouveau contact à votre liste",
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blue[700]),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue[700]!, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red),
        ),
      ),
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
    );
  }
}