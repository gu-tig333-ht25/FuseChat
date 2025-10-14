import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:template/models/AI_model.dart';

class AIConfig extends StatelessWidget {
  const AIConfig({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("New Page")),
      body: Center(
        child: Column(
          children: [
            Consumer<AIPersonalitySettings>(
              builder: (BuildContext context, value, Widget? child) => Expanded(
                child: ListView.builder(
                  itemCount: value.personalities.length,
                  itemBuilder: (context, index) {
                    Personality pi = value.personalities[index];
                    return RowItem(pi, value.isSelected(pi));
                  },
                ),
              ),
            ),
          ],
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

    Color secondaryColor = Theme.of(context).colorScheme.secondary;
    Color onSecondaryColor = Theme.of(context).colorScheme.onSecondary;
    Color backgroundColor = isSelected
        ? Color.alphaBlend(secondaryColor, onSecondaryColor)
        : onSecondaryColor;
    return InkWell(
      onTapUp: (details) {
        assert(context.read<AIPersonalitySettings>().selectPersonality(pi));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          color: backgroundColor, // background color
          borderRadius: BorderRadius.circular(15),
          border: BoxBorder.all(color: secondaryColor, width: 2),
        ),
        child: Row(
          children: [
            Expanded(flex: 10, child: Icon(pi.iconData)),
            Expanded(
              flex: 80,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Text(pi.name), Text(pi.desc)],
              ),
            ),
            Expanded(
              flex: 10,
              child: Container(child: isSelected ? Icon(Icons.check) : null),
            ),
          ],
        ),
      ),
    );
  }
}
