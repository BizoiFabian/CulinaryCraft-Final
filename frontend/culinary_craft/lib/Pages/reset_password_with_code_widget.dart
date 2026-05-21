import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../Components/auth_scaffold.dart';
import '../Models/reset_password_with_code_model.dart';
import '../Services/auth_service.dart';
import '../l10n/app_localizations.dart';

class ResetPasswordWithCodeWidget extends StatefulWidget {
  const ResetPasswordWithCodeWidget({super.key});

  @override
  State<ResetPasswordWithCodeWidget> createState() =>
      _ResetPasswordWithCodeWidgetState();
}

class _ResetPasswordWithCodeWidgetState
    extends State<ResetPasswordWithCodeWidget> {
  late ResetPasswordWithCodeModel _model;
  String _enteredCode = '';
  String? _codeError;

  @override
  void initState() {
    super.initState();
    _model = ResetPasswordWithCodeModel();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  void _verify() {
    final AppLocalizations l10n = context.l10n;
    setState(() {
      _codeError = _enteredCode.length != 4 ? l10n.pleaseEnter4DigitCode : null;
    });
    if (_codeError != null) return;
    AuthService.verifyCode(context, _enteredCode);
    setState(() => _codeError = l10n.wrongCode);
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return AuthScaffold(
      title: l10n.enterCodeTitle,
      subtitle: l10n.enterCodeSubtitle,
      heroIcon: Icons.mark_email_unread_rounded,
      showBackButton: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          PinCodeTextField(
            autoDisposeControllers: false,
            appContext: context,
            length: 4,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            textStyle: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
            enableActiveFill: true,
            autoFocus: true,
            enablePinAutofill: false,
            errorTextSpace: 0,
            showCursor: true,
            cursorColor: colorScheme.primary,
            obscureText: false,
            keyboardType: TextInputType.number,
            pinTheme: PinTheme(
              fieldHeight: 56,
              fieldWidth: 52,
              borderWidth: 1.5,
              borderRadius: BorderRadius.circular(14),
              shape: PinCodeFieldShape.box,
              activeColor: colorScheme.primary,
              inactiveColor: colorScheme.outlineVariant,
              selectedColor: colorScheme.primary,
              activeFillColor: colorScheme.primaryContainer.withValues(alpha: 0.35),
              inactiveFillColor: colorScheme.surfaceContainerHighest,
              selectedFillColor: colorScheme.surface,
            ),
            onChanged: (String value) => _enteredCode = value,
            onCompleted: (_) => _verify(),
          ),
          if (_codeError != null) ...<Widget>[
            const SizedBox(height: 6),
            Center(
              child: Text(
                _codeError!,
                style: TextStyle(
                  color: colorScheme.error,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
          const SizedBox(height: 22),
          FilledButton.icon(
            onPressed: _verify,
            icon: const Icon(Icons.check_rounded),
            label: Text(l10n.verifyCode),
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
