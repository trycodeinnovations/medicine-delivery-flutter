import 'package:flutter/material.dart';
import 'package:medquick/User/change_password.dart';
import 'package:medquick/User/edit_profile.dart';
import 'package:medquick/User/orderhistory_Screen.dart';
import 'package:medquick/User/rating.dart';



class ProfileScreenD extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Account'),
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back_ios),
        //   onPressed: () {
        //     Navigator.pop(context);
        //   },
        // ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                  colors: [Color.fromRGBO(243, 243, 243, 1), Colors.greenAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(Icons.person, color: Colors.greenAccent),
                        ),
                        SizedBox(width: 10.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Avinash S',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text('avinashkrishanarchana@gmail.com'),
                            Text('8848563409'),
                          ],
                        ),
                        Spacer(),
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => PersonalDetails(),));
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      children: [
                        Icon(Icons.location_on),
                        SizedBox(width: 10.0),
                        Expanded(
                          child: Text('Bangalore - 560004'),
                        ),
                        TextButton(
                          onPressed: () {
                            
                          },
                          child: Text('Change'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.0),
            
             buildListTile(
          Icons.location_on,
          'Addresses',
          context,
          onTap: () {
            // Navigate to the Addresses page
            // Navigator.push(context, MaterialPageRoute(builder: (context) => AddressesPage()));
          },
        ),
              buildListTile(
          Icons.lock_rounded,
          'Change Password',
          context,
          // trailing: Text('₹ 0'),
          onTap: () {
            // Navigate to the bbWallet page
            Navigator.push(context, MaterialPageRoute(builder: (context) => ChangePassword()));
          },
        ),
               buildListTile(
          Icons.support_agent_rounded,
          'About Us',
          context,
          onTap: () {
            // Navigate to the Saved Payments page
            // Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentsPage()));
          },
        ),
           
             buildListTile(
          Icons.settings,
          'Account Settings',
          context,
          onTap: () {
            // Navigate to the NeuPass page
            // Navigator.push(context, MaterialPageRoute(builder: (context) => NeuPassPage()));
          },
        ),
          buildListTile(
          Icons.logout,
          'Log Out',
          context,
          onTap: () {
            // Navigate to the Gift Cards page
            // Navigator.push(context, MaterialPageRoute(builder: (context) => GiftCardsPage()));
          },
        ),
            // buildListTile(Icons.support_agent, 'Support', context),
            // buildListTile(Icons.notifications, 'Notifications', context),
          ],
        ),
      ),
    );
  }

  ListTile buildListTile(IconData icon, String title, BuildContext context, {Widget? trailing, required VoidCallback onTap}) {
  return ListTile(
    leading: Icon(icon, color: Colors.green),
    title: Text(title),
    trailing: trailing,
    onTap: onTap,
  );
}

  }
