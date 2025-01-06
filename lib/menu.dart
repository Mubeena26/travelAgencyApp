import 'package:admin_project/booking.dart';
import 'package:admin_project/chat/chat_list.dart';
import 'package:admin_project/chat/chat_screen.dart';
import 'package:admin_project/travel_packages.dart';
import 'package:admin_project/users_list.dart';
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
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 152, 190, 221),
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
