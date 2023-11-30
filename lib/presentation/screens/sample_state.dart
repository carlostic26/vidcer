// my_button_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final buttonSelectedProvider = StateProvider<bool>((ref) => false);

class MyButtonWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Riverpod Button Example'),
      ),
      body: Center(
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed))
                  return Colors.orange;
                return ref.watch(buttonSelectedProvider.notifier).state
                    ? Colors.orange
                    : Colors.white;
              },
            ),
          ),
          onPressed: () {
            ref.read(buttonSelectedProvider.notifier).state =
                !ref.read(buttonSelectedProvider.notifier).state;
          },
          child: Text('Press me'),
        ),
      ),
    );
  }
}
