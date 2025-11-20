import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart'; // Ajoutez ceci
import '../models/contact.dart';
import '../services/contact_storage.dart';
import 'create_edit_contact.dart';

class ContactDetailsPage extends StatelessWidget {
  final Contact contact;

  const ContactDetailsPage({required this.contact});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(
            child: Column(
              children: [
                SizedBox(height: 20),
                _buildInfoSection(context),
                SizedBox(height: 20),
                _buildQuickActions(context), // Nouveau: Actions rapides
                SizedBox(height: 20),
                _buildActionButtons(context),
                SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    final initials = contact.name.isNotEmpty
        ? contact.name.split(' ').map((e) => e[0]).take(2).join().toUpperCase()
        : '?';

    return SliverAppBar(
      expandedHeight: 250,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue[700]!, Colors.blue[500]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 40),
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(60),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 15,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    initials,
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[700],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                contact.name,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.edit),
          onPressed: () => _navigateToEdit(context),
        ),
        IconButton(
          icon: Icon(Icons.delete),
          onPressed: () => _confirmDelete(context),
        ),
      ],
    );
  }

  Widget _buildInfoSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _buildInfoCard(
            icon: Icons.phone,
            title: "Téléphone",
            value: contact.phone,
            onTap: () => _copyToClipboard(context, contact.phone),
          ),
          SizedBox(height: 12),
          _buildInfoCard(
            icon: Icons.email,
            title: "Email",
            value: contact.email.isEmpty ? "Non renseigné" : contact.email,
            onTap: contact.email.isNotEmpty ? () => _copyToClipboard(context, contact.email) : null,
          ),
          SizedBox(height: 12),
          _buildInfoCard(
            icon: Icons.home,
            title: "Adresse",
            value: contact.address.isEmpty ? "Non renseigné" : contact.address,
            onTap: contact.address.isNotEmpty ? () => _copyToClipboard(context, contact.address) : null,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
    VoidCallback? onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Icon(icon, color: Colors.blue[700], size: 26),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[800],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              if (onTap != null)
                Icon(Icons.content_copy, size: 18, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _navigateToEdit(context),
              icon: Icon(Icons.edit),
              label: Text("Modifier"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[700],
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => _confirmDelete(context),
              icon: Icon(Icons.delete),
              label: Text("Supprimer"),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                padding: EdgeInsets.symmetric(vertical: 16),
                side: BorderSide(color: Colors.red, width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Copié dans le presse-papiers"),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _navigateToEdit(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CreateEditContactPage(contact: contact)),
    );
    Navigator.pop(context);
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text("Confirmer la suppression"),
        content: Text("Êtes-vous sûr de vouloir supprimer ce contact ?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text("Annuler"),
          ),
          ElevatedButton(
            onPressed: () async {
              await ContactHive.deleteContact(contact.id);
              Navigator.pop(ctx);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Contact supprimé")),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text("Supprimer"),
          ),
        ],
      ),
    );
  }

  // NOUVEAU: Section des actions rapides (WhatsApp, Appel, SMS)
  Widget _buildQuickActions(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: EdgeInsets.all(6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildQuickActionButton(
                    icon: Icons.phone,
                    label: "Appeler",
                    color: Colors.green,
                    onTap: () => _makePhoneCall(context),
                  ),
                  _buildQuickActionButton(
                    icon: Icons.message,
                    label: "SMS",
                    color: Colors.blue,
                    onTap: () => _sendSMS(context),
                  ),
                  _buildQuickActionButton(
                    icon: Icons.chat,
                    label: "WhatsApp",
                    color: Color(0xFF25D366), // Couleur officielle WhatsApp
                    onTap: () => _openWhatsApp(context),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fonction pour ouvrir WhatsApp
  Future<void> _openWhatsApp(BuildContext context) async {
    // Nettoyer le numéro de téléphone (enlever espaces, tirets, etc.)
    String phoneNumber = contact.phone.replaceAll(RegExp(r'[^\d+]'), '');
    
    // Ajouter l'indicatif international si nécessaire
    // Si le numéro commence par 0, remplacer par l'indicatif du pays
    if (phoneNumber.startsWith('0')) {
      phoneNumber = '+216${phoneNumber.substring(1)}';
    } else if (!phoneNumber.startsWith('+')) {
      phoneNumber = '+216$phoneNumber';
    }

    final whatsappUrl = Uri.parse('https://wa.me/$phoneNumber');

    try {
      if (await canLaunchUrl(whatsappUrl)) {
        await launchUrl(
          whatsappUrl,
          mode: LaunchMode.externalApplication,
        );
      } else {
        _showError(context, 'WhatsApp n\'est pas installé sur cet appareil');
      }
    } catch (e) {
      _showError(context, 'Impossible d\'ouvrir WhatsApp: $e');
    }
  }

  // Fonction pour passer un appel téléphonique
  Future<void> _makePhoneCall(BuildContext context) async {
    final phoneUrl = Uri.parse('tel:${contact.phone}');

    try {
      if (await canLaunchUrl(phoneUrl)) {
        await launchUrl(phoneUrl);
      } else {
        _showError(context, 'Impossible de passer l\'appel');
      }
    } catch (e) {
      _showError(context, 'Erreur lors de l\'appel: $e');
    }
  }

  // Fonction pour envoyer un SMS
  Future<void> _sendSMS(BuildContext context) async {
    final smsUrl = Uri.parse('sms:${contact.phone}');

    try {
      if (await canLaunchUrl(smsUrl)) {
        await launchUrl(smsUrl);
      } else {
        _showError(context, 'Impossible d\'ouvrir les messages');
      }
    } catch (e) {
      _showError(context, 'Erreur lors de l\'envoi du SMS: $e');
    }
  }

  // Fonction pour afficher les erreurs
  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}