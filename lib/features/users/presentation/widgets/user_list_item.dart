import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/user.dart';

class UserListItem extends StatelessWidget {
  final User user;
  final VoidCallback onTap;
  const UserListItem({super.key, required this.user, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Hero(
        tag: 'avatar_${user.id}',
        child: CircleAvatar(
          backgroundImage: CachedNetworkImageProvider(user.avatar),
        ),
      ),
      title: Text(user.fullName),
      subtitle: Text(user.email),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
