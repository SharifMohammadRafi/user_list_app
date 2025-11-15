import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/user.dart';

class UserDetailPage extends StatelessWidget {
  final User user;
  const UserDetailPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('User Details')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 600;
          final avatar = Hero(
            tag: 'avatar_${user.id}',
            child: CircleAvatar(
              radius: isWide ? 80 : 66,
              backgroundImage: CachedNetworkImageProvider(user.avatar),
            ),
          );

          final details = Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(user.fullName, style: theme.textTheme.headlineSmall),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.email_outlined, size: 18),
                  const SizedBox(width: 6),
                  Text(user.email),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.phone_outlined, size: 18),
                  const SizedBox(width: 6),
                  Text(user.phone),
                ],
              ),
            ],
          );

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: isWide
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      avatar,
                      const SizedBox(width: 24),
                      Expanded(child: details),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [avatar, const SizedBox(height: 16), details],
                  ),
          );
        },
      ),
    );
  }
}
