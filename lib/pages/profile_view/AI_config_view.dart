import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:template/models/ai_model.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';

class AIConfig extends StatefulWidget {
  const AIConfig({super.key});

  @override
  State<AIConfig> createState() => _AIConfigState();
}

class _AIConfigState extends State<AIConfig> {
  final TextEditingController _controller = TextEditingController();
  final TapGestureRecognizer _linkRecognizer = TapGestureRecognizer();

  Future<void> _openLink(String url, BuildContext context) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      // fallback / error handling
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Could not open link')));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _linkRecognizer.onTap = () =>
        _openLink("https://aistudio.google.com/app/api-keys", context);
  }

  @override
  void dispose() {
    _controller.dispose();
    _linkRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AISettings settings = context.watch<AISettings>();
    _controller.text = settings.apiKey ?? "";

    return Scaffold(
      appBar: AppBar(title: Text("AI settings")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        labelText: 'Enter Gemeni API key',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: OutlinedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                          settings.apiKey == null
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.secondary,
                        ),
                        shadowColor: WidgetStateProperty.all(
                          Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      onPressed: () {
                        settings.apiKey = _controller.text;
                      },
                      child: Text(
                        "OK",
                        style: TextTheme.of(context).labelLarge,
                      ),
                    ),
                  ),
                ],
              ),
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: _controller,
                builder: (context, value, child) {
                  if (value.text != "") {
                    return const SizedBox.shrink();
                  }
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: RichText(
                        text: TextSpan(
                          style: Theme.of(context).textTheme.bodySmall,
                          children: [
                            const TextSpan(text: 'Don\'t have one? Get one '),
                            TextSpan(
                              text: 'here',
                              style: const TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: _linkRecognizer,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),

              if (settings.apiKey != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: const Divider(thickness: 1),
                ),
              if (settings.apiKey != null)
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Enable AI suggestions",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Text(
                          "Let AI suggest replies in chats",
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ],
                    ),
                    Spacer(),
                    Switch(
                      inactiveTrackColor: Theme.of(context).colorScheme.primary,
                      activeTrackColor: Theme.of(context).colorScheme.secondary,
                      value: settings.aiSuggestionsEnabled,
                      onChanged: (value) {
                        //print("set toggle $value");
                        settings.aiSuggestionsEnabled = value;
                      },
                    ),
                  ],
                ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: const Divider(thickness: 1),
              ),
              if (settings.aiSuggestionsEnabled && settings.apiKey != null)
                Expanded(
                  child: ListView.builder(
                    itemCount: settings.personalities.length,
                    itemBuilder: (context, index) {
                      Personality pi = settings.personalities[index];
                      return RowItem(pi, settings.isSelected(pi));
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class RowItem extends StatelessWidget {
  const RowItem(this.pi, this.isSelected, {super.key});
  final Personality pi;
  final bool isSelected;
  @override
  Widget build(BuildContext context) {
    Color backgroundColor = isSelected
        ? Theme.of(context).colorScheme.secondary
        : Theme.of(context).colorScheme.primary;
    TextStyle? titleStyle = Theme.of(context).textTheme.titleMedium;
    TextStyle? descStyle = Theme.of(context).textTheme.labelMedium;

    double iconSize =
        ((titleStyle?.fontSize ?? 0) + (descStyle?.fontSize ?? 0)) * 1.5;
    return InkWell(
      onTapUp: (details) {
        assert(context.read<AISettings>().selectPersonality(pi));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          color: backgroundColor, // background color
          borderRadius: BorderRadius.circular(15),
          border: BoxBorder.all(
            color: Theme.of(context).colorScheme.secondary,
            width: 3,
          ),
        ),
        child: Row(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Icon(pi.iconData, size: iconSize),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(pi.name, style: titleStyle),
                Text(pi.desc, style: descStyle),
              ],
            ),

            const Spacer(),
            if (isSelected) Icon(Icons.check),
          ],
        ),
      ),
    );
  }
}
