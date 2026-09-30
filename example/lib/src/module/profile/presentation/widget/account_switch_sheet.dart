import 'package:app_pigeon/app_pigeon.dart';
import 'package:flutter/material.dart';

import '../../model/profile/profile.dart';

class AccountSwitchSheet extends StatefulWidget {
  const AccountSwitchSheet({
    super.key,
    required this.profile,
    required this.accounts,
    required this.currentAccountUid,
    required this.onSaveProfile,
    required this.onSwitchAccount,
    required this.onAddAccount,
    required this.onLogout,
  });

  final Profile profile;
  final List<Auth> accounts;
  final String? currentAccountUid;
  final Future<void> Function(String fullName) onSaveProfile;
  final Future<void> Function(Auth auth) onSwitchAccount;
  final Future<void> Function() onAddAccount;
  final Future<void> Function() onLogout;

  @override
  State<AccountSwitchSheet> createState() => _AccountSwitchSheetState();
}

class _AccountSwitchSheetState extends State<AccountSwitchSheet> {
  late final TextEditingController _fullNameController;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(text: widget.profile.fullName);
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final email = widget.profile.email.isNotEmpty
        ? widget.profile.email
        : "Unknown";
    final userId = widget.profile.uid.isNotEmpty ? widget.profile.uid : "-";
    final isVerified = widget.profile.isVerified;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Account", style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(email),
            Text("User ID: $userId"),
            Text("Verified: ${isVerified ? "Yes" : "No"}"),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _fullNameController,
                    decoration: const InputDecoration(
                      labelText: "Full name",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: _saving
                      ? null
                      : () async {
                          final value = _fullNameController.text.trim();
                          if (value.isEmpty) return;
                          setState(() => _saving = true);
                          await widget.onSaveProfile(value);
                          if (mounted) setState(() => _saving = false);
                        },
                  child: const Text("Save"),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "All accounts",
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                TextButton.icon(
                  onPressed: () async => widget.onAddAccount(),
                  icon: const Icon(Icons.add),
                  label: const Text("Add account"),
                ),
              ],
            ),
            const SizedBox(height: 6),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 220),
              child: widget.accounts.isEmpty
                  ? const Text("No local accounts")
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget.accounts.length,
                      itemBuilder: (context, index) {
                        final auth = widget.accounts[index];
                        final uid = _value(auth.data, [
                          "user_id",
                          "userId",
                          "uid",
                          "id",
                        ]);
                        final email =
                            _value(auth.data, ["email", "userName", "name"]) ??
                            "Account";
                        final isCurrent =
                            uid != null &&
                            widget.currentAccountUid != null &&
                            uid == widget.currentAccountUid;
                        return ListTile(
                          dense: true,
                          leading: Icon(
                            isCurrent
                                ? Icons.check_circle
                                : Icons.account_circle_outlined,
                          ),
                          title: Text(email),
                          subtitle: Text(uid ?? "-"),
                          trailing: TextButton(
                            onPressed: isCurrent
                                ? null
                                : () async => widget.onSwitchAccount(auth),
                            child: const Text("Use"),
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () async => widget.onLogout(),
                icon: const Icon(Icons.logout),
                label: const Text("Logout"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? _value(Map<String, dynamic> data, List<String> keys) {
    for (final key in keys) {
      final value = data[key]?.toString().trim();
      if (value != null && value.isNotEmpty) return value;
    }
    return null;
  }
}
