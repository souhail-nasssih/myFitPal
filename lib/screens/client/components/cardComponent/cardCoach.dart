import 'package:flutter/material.dart';
import 'package:myfitpal/helpers/helpers.dart';

class ProfileCard extends StatefulWidget {
  final String fullname;
  final int pricing;
  final String email;
  final String city;
  final String certifications;
  final String image;
  final String birthday;
  final String duration;

  const ProfileCard({
    super.key,
    required this.pricing,
    required this.email,
    required this.city,
    required this.certifications,
    required this.image,
    required this.birthday,
    required this.fullname,
    required this.duration,
  });

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image placeholder
            Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.grey.shade300,
                  child: Image.asset(widget.image, width: 80, height: 80),
                ),
                const SizedBox(height: 8),
                IconButton(
                  icon: Icon(
                    isFavorite ? Icons.star : Icons.star_border,
                    color: isFavorite ? Colors.yellow[900] : Colors.black,
                  ),
                  onPressed: () {
                    setState(() {
                      isFavorite = !isFavorite;
                    });
                    print(isFavorite
                        ? "Ajouté aux favoris"
                        : "Retiré des favoris");
                  },
                ),
              ],
            ),
            const SizedBox(width: 16),
            // Profile information
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.fullname,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${widget.pricing} \$US - Cours de ${widget.duration}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.certifications,
                    style: const TextStyle(
                      fontSize: 14,
                      color: ColorsHelper.secondaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'dans : ${widget.city}',
                    style: const TextStyle(
                      color: ColorsHelper.colorGrey,
                    ),
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
