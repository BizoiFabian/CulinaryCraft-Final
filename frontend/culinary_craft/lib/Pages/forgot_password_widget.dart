import 'package:flutter/material.dart';
import '../Components/auth_scaffold.dart';
import '../Models/forgot_password_model.dart';
import '../Services/auth_service.dart';
import '../l10n/app_localizations.dart';

class ForgotPasswordWidget extends StatefulWidget {
  const ForgotPasswordWidget({super.key});

  @override
  State<ForgotPasswordWidget> createState() => _ForgotPasswordWidgetState();
}

class _ForgotPasswordWidgetState extends State<ForgotPasswordWidget> {
  late ForgotPasswordModel _model;
  bool _loading = false;
  String? _emailError;

  @override
  void initState() {
    super.initState();
    _model = ForgotPasswordModel();
    _model.emailAddressController = TextEditingController();
    _model.emailAddressControllerValidator = _model.validateEmailAddress;
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  void _sendCode() {
    setState(() {
      _emailError = _model.emailAddressControllerValidator!(
          context, _model.emailAddressController!.text);
    });
    if (_emailError != null) return;
    setState(() => _loading = true);
    AuthService.forgotPassword(
        context, _model.emailAddressController!.text.trim());
    Future<void>.delayed(const Duration(seconds: 1), () {
      if (mounted) setState(() => _loading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;

    return AuthScaffold(
      title: l10n.forgotPasswordTitle,
      subtitle: l10n.forgotPasswordSubtitle,
      heroIcon: Icons.lock_reset_rounded,
      showBackButton: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextField(
            controller: _model.emailAddressController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _sendCode(),
            decoration: InputDecoration(
              labelText: l10n.email,
              prefixIcon: const Icon(Icons.mail_outline_rounded),
              errorText: _emailError,
            ),
          ),
          const SizedBox(height: 22),
          FilledButton.icon(
            onPressed: _loading ? null : _sendCode,
            icon: _loading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.send_rounded),
            label: Text(l10n.sendCode),
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
