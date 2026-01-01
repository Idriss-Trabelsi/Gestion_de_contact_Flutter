// lib/screens/home.dart
import 'package:flutter/material.dart';
import '../models/contact.dart';
import '../services/api_service.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../widgets/contact_card.dart';
import 'contact_details.dart';
import 'create_edit_contact.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Contact> contacts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    setState(() => isLoading = true);
    
    final authService = Provider.of<AuthService>(context, listen: false);
    final username = authService.currentUsername;
    
    if (username == null) {
      // Rediriger vers la page de login si non connecté
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/login');
      });
      return;
    }

    try {
      final contactsData = await ApiService.getAllContacts(username);
      contacts = contactsData.map((json) => Contact.fromJson(json)).toList();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erreur: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final username = authService.currentUsername ?? 'Utilisateur';

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
          "Mes Contacts",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text("Informations utilisateur"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Utilisateur: $username"),
                      SizedBox(height: 10),
                      Text("Email: ${authService.currentUser?['email'] ?? 'Non disponible'}"),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: Text("Fermer"),
                    ),
                  ],
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              authService.logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : contacts.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
                  onRefresh: _loadContacts,
                  child: ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: contacts.length,
                    itemBuilder: (context, index) {
                      return ContactCard(
                        contact: contacts[index],
                        onTap: () => _navigateToDetails(contacts[index]),
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToCreateContact(),
        icon: Icon(Icons.person_add),
        label: Text("Ajouter"),
        backgroundColor: Colors.blue[700],
        elevation: 6,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.contacts_outlined, size: 100, color: Colors.grey[400]),
          SizedBox(height: 20),
          Text(
            "Aucun contact",
            style: TextStyle(fontSize: 22, color: Colors.grey[600], fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 10),
          Text(
            "Ajoutez votre premier contact",
            style: TextStyle(fontSize: 16, color: Colors.grey[500]),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _navigateToCreateContact,
            child: Text("Ajouter un contact"),
          ),
        ],
      ),
    );
  }

  void _navigateToDetails(Contact contact) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ContactDetailsPage(contact: contact)),
    );
    _loadContacts();
  }

  void _navigateToCreateContact() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final username = authService.currentUsername;
    
    if (username == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Vous devez être connecté pour ajouter un contact"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CreateEditContactPage(username: username),
      ),
    );
    _loadContacts();
  }
}