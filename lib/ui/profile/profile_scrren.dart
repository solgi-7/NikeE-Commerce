import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:seven_learn_nick/data/repo/auth_reposityory.dart';
import 'package:seven_learn_nick/data/repo/cart_repository.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('پروفایل')),
        actions: [
          IconButton(onPressed: (){
             CartRepository.cartItemCountNotifier.value = 0;
                          authRepository.signOut();
          }, icon: const Icon(Icons.exit_to_app),),
        ],
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                height: 65,
                width: 65,
                padding: const EdgeInsets.all(8.0),
                margin: const EdgeInsets.only(top: 32.0, bottom: 8.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).dividerColor,
                    width: 1,
                  ),
                ),
                child: Image.asset('assets/img/nike_logo.png')),
            const Text('ssolgi772@gmail.com'),
            const SizedBox(
              height: 32.0,
            ),
            const Divider(
              height: 1,
            ),
            InkWell(
              onTap: () {
                
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                height: 56,
                child: Row(
                  children: const [
                    Icon(CupertinoIcons.heart),
                    SizedBox(width: 16,),
                    Text('لیست علاقه مندی ها')
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
