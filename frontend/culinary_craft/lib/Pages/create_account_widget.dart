import 'package:flutter/material.dart';
import '../Components/auth_scaffold.dart';
import '../Models/create_account_model.dart';
import '../Services/auth_service.dart';
import '../l10n/app_localizations.dart';

class CreateAccountWidget extends StatefulWidget {
  const CreateAccountWidget({super.key});

  @override
  State<CreateAccountWidget> createState() => _CreateAccountWidgetState();
}

class _CreateAccountWidgetState extends State<CreateAccountWidget> {
  late CreateAccountModel _model;
  bool _loading = false;
  String? _emailError;
  String? _passwordError;
  String? _usernameError;
  String? _authError;

  @override
  void initState() {
    super.initState();
    _model = CreateAccountModel();
    _model.initState(context);
    _model.usernameController = TextEditingController();
    _model.emailAddressController = TextEditingController();
    _model.passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _createAccount() async {
    setState(() {
      _emailError = _model.emailAddressControllerValidator!(
          context, _model.emailAddressController!.text);
      _passwordError = _model.passwordControllerValidator!(
          context, _model.passwordController!.text);
      _usernameError = _model.usernameControllerValidator!(
          context, _model.usernameController!.text);
      _authError = null;
    });

    if (_emailError != null ||
        _passwordError != null ||
        _usernameError != null) return;

    setState(() => _loading = true);
    final String? error = await AuthService.register(
      context,
      _model.usernameController!.text.trim(),
      _model.emailAddressController!.text.trim(),
      _model.passwordController!.text,
    );
    if (!mounted) return;
    setState(() {
      _loading = false;
      _authError = error;
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return AuthScaffold(
      title: l10n.createAccount,
      subtitle: l10n.createAccountSubtitle,
      heroIcon: Icons.person_add_alt_1_rounded,
      showBackButton: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (_authError != null)
            Container(
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: colorScheme.errorContainer.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.error_outline_rounded,
                    color: colorScheme.onErrorContainer,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _authError!,
                      style: TextStyle(
                        color: colorScheme.onErrorContainer,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          TextField(
            controller: _model.usernameController,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: l10n.username,
              prefixIcon: const Icon(Icons.person_outline_rounded),
              errorText: _usernameError,
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _model.emailAddressController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: l10n.email,
              prefixIcon: const Icon(Icons.mail_outline_rounded),
              errorText: _emailError,
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _model.passwordController,
            obscureText: !_model.passwordVisibility,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _createAccount(),
            decoration: InputDecoration(
              labelText: l10n.password,
              prefixIcon: const Icon(Icons.lock_outline_rounded),
              errorText: _passwordError,
              suffixIcon: IconButton(
                icon: Icon(_model.passwordVisibility
                    ? Icons.visibility_rounded
                    : Icons.visibility_off_rounded),
                onPressed: () => setState(
                    () => _model.passwordVisibility = !_model.passwordVisibility),
              ),
            ),
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: _loading ? null : _createAccount,
            icon: _loading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.check_rounded),
            label: Text(l10n.createAccount),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.termsOfUseNote,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: TextButton(
              onPressed: () => Navigator.of(context).pushNamed('/signin'),
              child: Text(l10n.iAlreadyHaveAccount),
            ),
          ),
        ],
      ),
    );
  }
}
