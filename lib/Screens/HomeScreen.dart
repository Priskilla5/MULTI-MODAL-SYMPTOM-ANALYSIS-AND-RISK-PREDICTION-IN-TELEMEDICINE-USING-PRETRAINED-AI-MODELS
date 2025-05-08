import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:digixcare/widgets/AppBar.dart';
import '../widgets/EnhancedBottomNavBar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, String>> news = [
    {
      "title": "Vitamin A can't prevent measles. What this supplement actually does",
      "image": "https://img3.exportersindia.com/product_images/bc-small/dir_15/445478/folic-acid-tablets-2382220.jpg",
      "url": "https://www.medicalnewstoday.com/articles/vitamin-a-measles-prevention-health-experts-answer-questions",
    },
    {
      "title": "New-onset type 2 diabetes linked to cancer risk",
      "image": "https://t4.ftcdn.net/jpg/08/25/46/37/360_F_825463783_Uc61qdPftKBeyZND67bNf7gCw6limnLt.jpg",
      "url": "https://www.medicalnewstoday.com/articles/new-onset-type-2-diabetes-linked-to-higher-colorectal-pancreatic-liver-cancer-risk",
    },
    {
      "title": "Is excessive sleepiness a warning sign of dementia?",
      "image": "https://s.yimg.com/ny/api/res/1.2/bDhYCRfhVHp2YL43GvEumg--/YXBwaWQ9aGlnaGxhbmRlcjt3PTY0MDtoPTM1OQ--/https://media.zenfs.com/en/aol_medicalnewstoday_320/94f92878ce1e31365f3c1427a0178241",
      "url": "https://www.medicalnewstoday.com/articles/is-excessive-sleepiness-as-we-age-a-warning-sign-of-dementia",
    },
    {
      "title": "Heart Disease Prevention Tips",
      "image": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT5WyD5jA6Tp6OzBgfIWu0EAOPqMMPhA87gnw&s",
      "url": "https://www.medicalnewstoday.com/articles/how-to-prevent-heart-disease#awareness",
    },
  ];

  // Function to launch URL
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Appbar(),

              const Padding(
                padding: EdgeInsets.only(top: 10, left: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Latest Medical News',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              // News Cards
              Column(
                children: news.map((newsItem) {
                  return GestureDetector(
                    onTap: () => _launchURL(newsItem['url']!),
                    child: Card(
                      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                newsItem['image']!,
                                width: 90,
                                height: 90,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 90,
                                    height: 90,
                                    color: Colors.grey.shade200,
                                    child: const Icon(Icons.broken_image, size: 40),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    newsItem['title']!,
                                    maxLines: 4,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  const Align(
                                    alignment: Alignment.bottomRight,
                                    child: Icon(Icons.open_in_new,
                                        color: Colors.blue, size: 18),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const EnhancedBottomNavBar(),
    );
  }
}
