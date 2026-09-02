import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../injection.dart';
import '../../items/presentation/item_list_cubit.dart';
import '../../items/presentation/item_list_page.dart';
import 'login_cubit.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _passwordFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _emailController.text = AppConfig.testEmail;
    _passwordController.text = AppConfig.testPassword;
  }

  Future<void> _submit() async {
    final cubit = context.read<LoginCubit>();
    await cubit.login(_emailController.text.trim(), _passwordController.text);

    final state = cubit.state;
    if (state.status == LoginStatus.success) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<ItemListCubit>()..loadFirstPage(),
            child: const ItemListPage(),
          ),
        ),
      );
    } else if (state.status == LoginStatus.failure) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(state.error ?? 'Sign in failed.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Salary overview',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 32),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (_) => _passwordFocus.requestFocus(),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  focusNode: _passwordFocus,
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (_) => _submit(),
                ),
                const SizedBox(height: 24),
                BlocBuilder<LoginCubit, LoginState>(
                  builder: (context, state) {
                    return FilledButton(
                      onPressed: state.isLoading ? null : _submit,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: state.isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Sign in'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
