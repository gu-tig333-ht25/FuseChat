import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:template/models/AI_model.dart';

class AIConfig extends StatefulWidget {
  const AIConfig({super.key});

  @override
  State<AIConfig> createState() => _AIConfigState();
}

class _AIConfigState extends State<AIConfig> {
  final TextEditingController _controller = TextEditingController();
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AISettings settings = context.watch<AISettings>();
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
                      decoration: const InputDecoration(labelText: 'Enter Gemeni API key'),
                      
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: OutlinedButton(onPressed: () { 
                      settings.api_key = _controller.text;
                     },
                    child: Text("OK"),),
                  )
                ],
              ),
             if (settings.api_key != null) Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: const Divider(thickness: 1),
              ),
              if (settings.api_key != null)
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
                      value: settings.aiSuggestionsEnabled,
                      onChanged: (value) {
                        settings.aiSuggestionsEnabled = value;
                      },
                    ),
                  ],
                ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: const Divider(thickness: 1),
              ),
              if (settings.aiSuggestionsEnabled && settings.api_key != null)
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
        : Theme.of(context).colorScheme.surface;
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
            color: Theme.of(context).colorScheme.primary,
            width: 2,
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
