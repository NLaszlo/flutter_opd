import 'package:flutter/material.dart';
import 'package:flutter_opd/opd_appbar.dart';
import 'package:flutter_opd/states/downtime_state.dart';
import 'package:provider/provider.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

class CommentPage extends StatefulWidget {
  final commentTitle;

  const CommentPage({super.key, required this.commentTitle});

  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  final TextEditingController _controller = TextEditingController();
  String text = "";
  bool _isValid = false;
  bool shiftEnabled = false;

  void _validateInput(String value) {
    setState(() {
      _isValid = value.length >= 10;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Just local variable. Use Text widget or similar to show in UI.
    var downtimeState = context.watch<DowntimesState>();

    /// Fired when the virtual keyboard key is pressed.
    onKeyPress(VirtualKeyboardKey key) {
      if (key.keyType == VirtualKeyboardKeyType.String) {
        text = text + (shiftEnabled ? key.capsText ?? "" : key.text ?? "");
      } else if (key.keyType == VirtualKeyboardKeyType.Action) {
        switch (key.action) {
          case VirtualKeyboardKeyAction.Backspace:
            if (text.isEmpty) return;
            text = text.substring(0, text.length - 1);
            break;
          case VirtualKeyboardKeyAction.Return:
            text += '\n';
            break;
          case VirtualKeyboardKeyAction.Space:
            text += " ";
            break;
          case VirtualKeyboardKeyAction.Shift:
            shiftEnabled = !shiftEnabled;
            break;
          default:
        }
      }
      // Update the screen
      setState(() {
        // text = text;
        _controller.text = text;
      });
    }

    return Scaffold(
      appBar: const OPDAppBar(title: 'Micro Downtimes'),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 16.0, left: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.commentTitle,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Divider(height: 0,),
          // SizedBox(height: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                textAlignVertical: TextAlignVertical.top,
                controller: _controller,
                maxLines: null,
                expands: true,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Comment required - minimum 10 characters ...',
                ),
                onChanged: _validateInput,
              ),
            ),
          ),
          // Spacer(),
          Container(
            // Keyboard is transparent
            color: Colors.grey[200],
            child: VirtualKeyboard(
                // Default height is 300
                height: 350,
                // Default height is will screen width
                // width: 600,
                // Default is black
                textColor: Colors.black,
                // Default 14
                fontSize: 20,
                // the layouts supported
                // defaultLayouts = [VirtualKeyboardDefaultLayouts.English],
                // [A-Z, 0-9]
                type: VirtualKeyboardType.Alphanumeric,
                // Callback for key press event
                onKeyPress: onKeyPress),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                style: TextButton.styleFrom(
                  minimumSize: const Size(64, 64),
                  // backgroundColor: Colors.grey,33
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.all(0),
                ),
                onPressed: () async {
                  // Handle the button press
                  print('Comment submitted: ${_controller.text}');
                  await downtimeState.commentMicroDowntimes(_controller.text);
                  if (!context.mounted) return;
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Comment micro downtimes',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
