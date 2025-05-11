import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../widgets/custom_bottom_navigation_bar.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  int _selectedIndex = 2;
  final ScrollController _scrollController = ScrollController();
  bool _showAppBar = true;
  double _scrollPosition = 0;
  final PageController _pageController = PageController(viewportFraction: 1.0);
  int _currentPage = 0;

  // Carousel images
  final List<String> _carouselImages = [
    'assets/images/about_images/restaurant.jpg',
    'assets/images/about_images/food.jpg',
    'assets/images/about_images/drink.jpg',
  ];

  // Specialty dishes
  final List<Map<String, String>> specialties = [
    {
      'title': 'Rendang Padang',
      'image': 'assets/images/about_images/rendang_padang.jpg'
    },
    {
      'title': 'Soto Betawi',
      'image': 'assets/images/about_images/soto_betawi.jpg'
    },
    {
      'title': 'Gudeg Jogja',
      'image': 'assets/images/about_images/gudeg_jogja.jpg'
    },
    {
      'title': 'Papeda Papua',
      'image': 'assets/images/about_images/papeda_papua.jpg'
    },
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    _autoScrollCarousel();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _autoScrollCarousel() {
    Future.delayed(const Duration(seconds: 5), () {
      if (_pageController.hasClients && mounted) {
        final nextPage =
            _currentPage < _carouselImages.length - 1 ? _currentPage + 1 : 0;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        _autoScrollCarousel();
      }
    });
  }

  void _scrollListener() {
    final currentScroll = _scrollController.offset;
    if (currentScroll > _scrollPosition && currentScroll > 50) {
      if (_showAppBar) {
        setState(() => _showAppBar = false);
      }
    } else if (currentScroll < _scrollPosition) {
      if (!_showAppBar) {
        setState(() => _showAppBar = true);
      }
    }
    _scrollPosition = currentScroll;
  }

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;

    if (mounted) {
      setState(() {
        _selectedIndex = index;
      });
    }

    switch (index) {
      case 0:
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        break;
      case 1:
        Navigator.pushNamed(context, '/menu').then((_) {
          if (mounted) setState(() => _selectedIndex = 0);
        });
        break;
      case 2:
        break;
      case 3:
        Navigator.pushNamed(context, '/profile').then((_) {
          if (mounted) setState(() => _selectedIndex = 0);
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _showAppBar
          ? AppBar(
              title: Text('Tentang Kami',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.orange[400],
                  )),
              centerTitle: true,
              elevation: 0,
              backgroundColor: Colors.transparent,
              automaticallyImplyLeading: false,
            )
          : null,
      body: SafeArea(
        child: NotificationListener<ScrollNotification>(
          onNotification: (notification) => true,
          child: SingleChildScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                // Carousel Header
                SizedBox(
                  height: 220,
                  child: Stack(
                    children: [
                      // Image Carousel
                      PageView.builder(
                        controller: _pageController,
                        onPageChanged: (index) {
                          if (mounted) {
                            setState(() {
                              _currentPage = index;
                            });
                          }
                        },
                        itemCount: _carouselImages.length,
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(_carouselImages[index]),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                              ),
                            ),
                          );
                        },
                      ),

                      // Gradient Overlay
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.7),
                            ],
                          ),
                        ),
                      ),

                      // Title Text
                      Center(
                        child: Text(
                          'RASA NUSANTARA',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                blurRadius: 10,
                                color: Colors.black.withOpacity(0.8),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Page Indicators
                      Positioned(
                        bottom: 20,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            _carouselImages.length,
                            (index) => Container(
                              width: 8,
                              height: 8,
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _currentPage == index
                                    ? Colors.white
                                    : Colors.white.withOpacity(0.5),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Rest of the content remains the same...
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      Text(
                        'Selamat Datang di Rasa Nusantara',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 4,
                        width: 80,
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Tempat dimana kelezatan kuliner dari berbagai penjuru Nusantara disajikan dengan cita rasa otentik dan penyajian modern.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // History Card
                      Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: Colors.grey[300]!),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.history,
                                      color: AppColors.primaryColor),
                                  const SizedBox(width: 12),
                                  Text(
                                    'Sejarah Kami',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Rasa Nusantara didirikan pada tahun 2010 oleh Chef Andika Wibawa. Berawal dari warung kecil di Bandung, kini kami telah berkembang menjadi restoran dengan 5 cabang di Jawa Barat.',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                  height: 1.6,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Specialties Section
                      Text(
                        'Spesialisasi Kami',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 180,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            for (var item in specialties)
                              Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: _buildSpecialtyCard(
                                  item['title']!,
                                  item['image']!,
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Features Grid
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 0.9,
                        children: [
                          _buildFeatureItem(
                            Icons.emoji_food_beverage,
                            'Bahan Berkualitas',
                            'Hanya menggunakan bahan terbaik dari petani lokal',
                          ),
                          _buildFeatureItem(
                            Icons.people,
                            'Ramah Keluarga',
                            'Suasana nyaman untuk semua usia',
                          ),
                          _buildFeatureItem(
                            Icons.handshake,
                            'Pelayanan Prima',
                            'Staff kami siap melayani dengan senyuman',
                          ),
                          _buildFeatureItem(
                            Icons.delivery_dining,
                            'Pengiriman Cepat',
                            'Pesanan diantar dengan packaging khusus',
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Location Card
                      Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: Colors.grey[300]!),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.location_pin,
                                      color: AppColors.primaryColor),
                                  const SizedBox(width: 12),
                                  Text(
                                    'Lokasi Kami',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Jl. Terusan Buah Batu No.5, Batununggal, Kec. Bandung Kidul, Kota Bandung, Jawa Barat 40266',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Buka setiap hari:\n10.00 - 22.00 WIB',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primaryColor,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text('Petunjuk Arah'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildSpecialtyCard(String title, String imagePath) {
    return Container(
      width: 150,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.asset(
              imagePath,
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[200],
                  height: 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error, color: Colors.red),
                      Text(
                        'Gambar tidak ditemukan',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String description) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: AppColors.primaryColor),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
