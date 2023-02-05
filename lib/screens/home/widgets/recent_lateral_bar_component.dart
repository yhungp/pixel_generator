import 'package:calculator/styles/styles.dart';
import 'package:flutter/material.dart';

class RecentLateralBarComponent extends StatelessWidget {
  RecentLateralBarComponent({
    Key? key,
    required this.darkTheme,
    required this.fileName,
    required this.openProject}
      ) : super(key: key);

  String fileName;
  bool darkTheme;
  Function openProject;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Tooltip(
        verticalOffset: 8,
        message: fileName,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextButton(
              onPressed: (){},
              child: Text(fileName,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: textColor(darkTheme))),
            ),
          ],
        ),
      ),
    );
  }
}