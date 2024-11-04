import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';
import 'product_detail_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final List<Product> products = [
    Product(
      name: "Keyboard Mechanical Falcon",
      description:
          "Keyboard mekanik dengan switch biru yang memberikan feedback taktil. Cocok untuk mengetik dan gaming.",
      imageUrl: "assets/1.jpg",
      price: 350000,
    ),
    Product(
      name: "Keyboard Mechanical Thunder Pro",
      description:
          "Keyboard mekanik dengan lampu RGB yang dapat disesuaikan. Dibuat dari bahan aluminium untuk daya tahan tinggi.",
      imageUrl: "assets/2.png",
      price: 450000,
    ),
    Product(
      name: "Keyboard Mechanical DragonFire",
      description:
          "Dilengkapi dengan switch merah untuk pengalaman mengetik yang halus dan responsif, ideal untuk gamer.",
      imageUrl: "assets/3.png",
      price: 400000,
    ),
    Product(
      name: "Keyboard Mechanical Nitro-X",
      description:
          "Keyboard mekanik full-size dengan anti-ghosting untuk semua tombol. Nyaman untuk sesi bermain yang panjang.",
      imageUrl: "assets/4.jpg",
      price: 420000,
    ),
  ];

  final Map<Product, int> cart = {};
  final TextEditingController paymentController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();

  void _addToCart(Product product) {
    setState(() {
      cart.update(product, (quantity) => quantity + 1, ifAbsent: () => 1);
    });
  }

  void _showContactDialog(String title, String contactInfo) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text("Hubungi kami di nomor $contactInfo"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("Close"),
          ),
        ],
      ),
    );
  }

  void _showUpdatePasswordDialog() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> usernames = prefs.getStringList('usernames') ??
        []; // Retrieve the list of usernames
    String selectedUsername = usernames.isNotEmpty
        ? usernames.first
        : ''; // Set the default selected username

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Update Password"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButton<String>(
                    value: selectedUsername,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedUsername = newValue!;
                      });
                    },
                    items: usernames
                        .map<DropdownMenuItem<String>>((String username) {
                      return DropdownMenuItem<String>(
                        value: username,
                        child: Text(username),
                      );
                    }).toList(),
                  ),
                  TextField(
                    controller: newPasswordController,
                    decoration: InputDecoration(labelText: "New Password"),
                    obscureText: true,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Cancel"),
                ),
                TextButton(
                  onPressed: () async {
                    // Update the password for the selected username
                    await prefs.setString('$selectedUsername-password',
                        newPasswordController.text);
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content:
                              Text("Password updated for $selectedUsername")),
                    );
                  },
                  child: Text("Update"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _openMaps() async {
    const url = 'https://maps.app.goo.gl/iGRGoqRNMgpTxTQv8';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _showCartDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Cart"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: cart.entries.map((entry) {
              return ListTile(
                title: Text(entry.key.name),
                subtitle: Text('Jumlah: ${entry.value}'),
                trailing: Text('Rp ${entry.key.price * entry.value}'),
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Tutup"),
            ),
          ],
        );
      },
    );
  }

  void _showPaymentDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Pembayaran"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: paymentController,
                decoration: InputDecoration(labelText: "Metode Pembayaran"),
              ),
              SizedBox(height: 10),
              Text("Total: Rp ${_calculateTotal()}"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Batal"),
            ),
            TextButton(
              onPressed: () {
                _completePayment();
                Navigator.of(context).pop();
              },
              child: Text("Bayar"),
            ),
          ],
        );
      },
    );
  }

  int _calculateTotal() {
    return cart.entries
        .fold(0, (sum, entry) => sum + (entry.key.price * entry.value).toInt());
  }

  void _completePayment() {
    setState(() {
      cart.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Pembayaran Berhasil!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'Call Center':
                  _showContactDialog("Call Center", "+62 857 0185 4470");
                  break;
                case 'SMS Center':
                  _showContactDialog("SMS Center", "+62 857 0185 4470");
                  break;
                case 'Lokasi/Maps':
                  _openMaps();
                  break;
                case 'Update User & Password':
                  _showUpdatePasswordDialog();
                  break;
              }
            },
            itemBuilder: (context) {
              return {
                'Call Center',
                'SMS Center',
                'Lokasi/Maps',
                'Update User & Password'
              }.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(8.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          childAspectRatio: 0.75,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProductDetailScreen(product: products[index]),
                        ),
                      );
                    },
                    child: Image.asset(
                      products[index].imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    products[index].name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    'Rp ${products[index].price}',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      _addToCart(products[index]);
                    },
                    child: Text("Tambah Keranjang"),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total items: ${cart.values.fold<int>(0, (sum, quantity) => sum + quantity)}",
                style: TextStyle(fontSize: 18),
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.shopping_cart),
                    onPressed: _showCartDialog,
                  ),
                  ElevatedButton(
                    onPressed: _showPaymentDialog,
                    child: Text("Bayar Sekarang"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
