import 'package:admin_project/features/bookings/screens/booking.dart';
import 'package:admin_project/features/chat/screens/chat_list.dart';
import 'package:admin_project/features/chat/screens/chat_screen.dart';
import 'package:admin_project/features/core/theme/colors.dart';
import 'package:admin_project/features/tour/screens/travel_packages.dart';
import 'package:admin_project/features/screens/users_list.dart';
import 'package:flutter/material.dart';

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text(
              'Dashboard',
              style: TextStyle(color: whitecolor, fontSize: 25),
            ),
            decoration: BoxDecoration(
              color: homebg,
            ),
          ),
          ListTile(
            leading: Icon(Icons.list),
            title: Text('Users list'),
            onTap: () => {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => UsersList(),
              ))
            },
          ),
          ListTile(
              leading: Icon(Icons.travel_explore),
              title: Text('Travel packages'),
              onTap: () => {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => TravelPackages(),
                    ))
                  }),
          ListTile(
            leading: Icon(Icons.chat),
            title: Text('Chat'),
            onTap: () => {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ChatLitsshow(),
              ))
            },
          ),
          ListTile(
            leading: Icon(Icons.list_alt_rounded),
            title: Text('Bookings'),
            onTap: () => {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => Booking(),
              ))
            },
          ),
          // ListTile(
          //   leading: Icon(Icons.exit_to_app),
          //   title: Text('Logout'),
          //   onTap: () => {Navigator.of(context).pop()},
          // ),
        ],
      ),
    );
  }
}
