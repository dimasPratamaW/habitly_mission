import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitly_mission/presentation/state/auth_providers.dart';
import 'package:habitly_mission/presentation/screens/login_screen.dart';

class AccountScreen extends ConsumerWidget {
  const AccountScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.account_circle, size: 60),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Email :'),
              SizedBox(width: 2,),
              Text(user?.email??''),
            ],
          ),
          ElevatedButton(onPressed: ()async{
            await ref.read(authNotifierProvider.notifier).logout();
            if(!context.mounted)return;
            Navigator.pushReplacementNamed(context, LoginScreen.routeName);
          }, child: const Text('logout'))
        ],
      ),
    );
  }
}
