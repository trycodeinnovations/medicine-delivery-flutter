import 'package:flutter/material.dart';
import 'package:medquick/User/productScreen.dart';



class Viewall extends StatelessWidget {
  final List<Map<String, String>> medicines = [
    {
      "image": "assets/Image/WhatsApp Image 2024-08-07 at 17.10.18_23cfa924.jpg",
      "name": "Neurobion Forte 30 Tablets",
      "discount": "9%",
      "price": "₹ 38.35",
      "originalPrice": "₹ 41.91"
    },
    {
      "image": "assets/Image/WhatsApp Image 2024-08-07 at 17.10.18_23cfa924.jpg",
      "name": "A TO Z Gold (New) 15 Capsules",
      "discount": "14%",
      "price": "₹ 194.26",
      "originalPrice": "₹ 225.00"
    },
    {
      "image": "assets/Image/WhatsApp Image 2024-08-07 at 17.10.18_23cfa924.jpg",
      "name": "Zincovit 15 Tablets",
      "discount": "12%",
      "price": "₹ 96.95",
      "originalPrice": "₹ 110.00"
    },
    {
      "image": "assets/Image/WhatsApp Image 2024-08-07 at 17.10.18_23cfa924.jpg",
      "name": "Electral Sachet 21.8 g",
      "discount": "5%",
      "price": "₹ 21.52",
      "originalPrice": "₹ 22.66"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('View All'),
        
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Essential Support Aid',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            Expanded(
              child: GridView.builder(
                itemCount: medicines.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  childAspectRatio: 0.7,
                ),
                itemBuilder: (context, index) {
                  return MedicineCard(
                    image: medicines[index]['image']!,
                    name: medicines[index]['name']!,
                    discount: medicines[index]['discount']!,
                    price: medicines[index]['price']!,
                    originalPrice: medicines[index]['originalPrice']!,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MedicineCard extends StatelessWidget {
  final String image;
  final String name;
  final String discount;
  final String price;
  final String originalPrice;

  const MedicineCard({
    required this.image,
    required this.name,
    required this.discount,
    required this.price,
    required this.originalPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                child: Image.asset(image, fit: BoxFit.cover, height: 100, width: double.infinity),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  color: Colors.green,
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  child: Text(
                    '$discount OFF',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      price,
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 8),
                    Text(
                      originalPrice,
                      style: TextStyle(
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetailsPage(),));
                  },
                  child: Text('View'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.blue,
                     backgroundColor: Colors.white,
                    side: BorderSide(color: Colors.blue),
                    minimumSize: Size(double.infinity, 36),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
