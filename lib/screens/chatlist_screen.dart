import 'package:chatapp/utils/auth_controller.dart';
import 'package:chatapp/widgets/select_avatar.dart';
import 'package:flutter/material.dart';

class Chatlistscreen extends StatelessWidget {
  const Chatlistscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat List"),
        actions: [
          IconButton(
              onPressed: () => AuthController.to.logout(context),
              icon: const Icon(Icons.logout))
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50.0),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24.0),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                        width: 2.0,
                      ),
                    ),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surfaceVariant,
                  ),
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.only(top: 8.0),
                  itemCount: 20,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      elevation: 0,
                      margin: const EdgeInsets.symmetric(vertical: 4.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.outlineVariant,
                        ),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        leading: CircleAvatar(
                          radius: 28,
                          backgroundImage: NetworkImage(
                            'https://randomuser.me/api/portraits/men/${index % 100}.jpg',
                          ),
                          backgroundColor:
                              Theme.of(context).colorScheme.surfaceVariant,
                        ),
                        title: Text(
                          'User $index',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        subtitle: Text(
                          'This is a message from user $index',
                          style: Theme.of(context).textTheme.bodyMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Text(
                          '12:${index.toString().padLeft(2, '0')} PM',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const SizedBox(height: 8.0),
                ),
              ),
              ElevatedButton(
                onPressed: () =>
                    SelectAvatar().showAvatarSelectionDialog(context),
                child: const Text('Select Avatar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
