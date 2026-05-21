import 'package:flutter/material.dart';
import '../Components/auth_scaffold.dart';
import '../Models/change_password_model.dart';
import '../Services/auth_service.dart';
import '../l10n/app_localizations.dart';

class ChangePasswordWidget extends StatefulWidget {
  const ChangePasswordWidget({super.key});

  @override
  State<ChangePasswordWidget> createState() => _ChangePasswordWidgetState();
}

class _ChangePasswordWidgetState extends State<ChangePasswordWidget> {
  late ChangePasswordModel _model;
  bool _obscure1 = true;
  bool _obscure2 = true;
  String? _passwordError1;
  String? _passwordError2;

  @override
  void initState() {
    super.initState();
    _model = ChangePasswordModel();
    _model.passwordController1 = TextEditingController();
    _model.passwordController2 = TextEditingController();
    _model.passwordFocusNode1 = FocusNode();
    _model.passwordFocusNode2 = FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  void _changePassword() {
    final AppLocalizations l10n = context.l10n;
    setState(() {
      _passwordError1 = _model.passwordController1.text.isEmpty
          ? l10n.enterNewPassword
          : null;
      _passwordError2 = _model.passwordController2.text.isEmpty
          ? l10n.confirmYourPassword
          : null;
      if (_passwordError1 == null && _passwordError2 == null) {
        if (_model.passwordController1.text != _model.passwordController2.text) {
          _passwordError2 = l10n.passwordsDontMatch;
        } else {
          AuthService.changePassword(context, _model.passwordController1.text);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;

    return AuthScaffold(
      title: l10n.changePasswordTitle,
      subtitle: l10n.changePasswordSubtitle,
      heroIcon: Icons.password_rounded,
      showBackButton: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextField(
            controller: _model.passwordController1,
            focusNode: _model.passwordFocusNode1,
            obscureText: _obscure1,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: l10n.newPassword,
              prefixIcon: const Icon(Icons.lock_outline_rounded),
              suffixIcon: IconButton(
                icon: Icon(_obscure1
                    ? Icons.visibility_off_rounded
                    : Icons.visibility_rounded),
                onPressed: () => setState(() => _obscure1 = !_obscure1),
              ),
              errorText: _passwordError1,
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _model.passwordController2,
            focusNode: _model.passwordFocusNode2,
            obscureText: _obscure2,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _changePassword(),
            decoration: InputDecoration(
              labelText: l10n.confirmPassword,
              prefixIcon: const Icon(Icons.lock_outline_rounded),
              suffixIcon: IconButton(
                icon: Icon(_obscure2
                    ? Icons.visibility_off_rounded
                    : Icons.visibility_rounded),
                onPressed: () => setState(() => _obscure2 = !_obscure2),
              ),
              errorText: _passwordError2,
            ),
          ),
          const SizedBox(height: 22),
          FilledButton.icon(
            onPressed: _changePassword,
            icon: const Icon(Icons.check_rounded),
            label: Text(l10n.changePasswordTitle),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
