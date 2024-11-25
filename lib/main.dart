import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Stack(
        children: [
          // Fullscreen background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/wallpaper.jpg'),
                fit: BoxFit.cover, // Ensure the image covers the entire screen
              ),
            ),
          ),
          // Transparent scaffold with the dock
          const Scaffold(
            backgroundColor: Colors.transparent,
            body: MacOSDock(),
          ),
        ],
      ),
    );
  }
}

class MacOSDock extends StatefulWidget {
  const MacOSDock({super.key});

  @override
  MacOSDockState createState() => MacOSDockState();
}

class MacOSDockState extends State<MacOSDock> {
  List<IconData> dockIcons = [
    Icons.person,
    Icons.message,
    Icons.call,
    Icons.camera,
    Icons.photo,
  ];

  List<IconData> externalIcons = [];

  /// Handles moving the icon between lists
  void _onIconMoved(IconData icon, bool toDock) {
    setState(() {
      if (toDock) {
        // Ensure the icon is added to dock and removed from external list
        externalIcons.remove(icon);
        if (!dockIcons.contains(icon)) dockIcons.add(icon);
      } else {
        // Ensure the icon is added to external list and removed from dock
        dockIcons.remove(icon);
        if (!externalIcons.contains(icon)) externalIcons.add(icon);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // External List
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(8),
            constraints: BoxConstraints(
                minHeight: size.height * 0.8, minWidth: size.width),
            child: DragTargetList(
              icons: externalIcons,
              onIconMoved: (icon) => _onIconMoved(icon, true), // Move to Dock
              title: "External List",
            ),
          ),
        ),

        // Dock
        Center(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            constraints: const BoxConstraints(minHeight: 50, minWidth: 100),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(40),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black38,
                  offset: Offset(0, 6),
                  blurRadius: 10,
                ),
              ],
            ),
            child: DragTargetList(
              icons: dockIcons,
              onIconMoved: (icon) =>
                  _onIconMoved(icon, false), // Move to External List
              title: "Dock",
            ),
          ),
        ),
      ],
    );
  }
}

class DragTargetList extends StatelessWidget {
  final List<IconData> icons;
  final Function(IconData) onIconMoved;
  final String title;

  const DragTargetList({
    super.key,
    required this.icons,
    required this.onIconMoved,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return DragTarget<IconData>(
      onAcceptWithDetails: (details) {
        onIconMoved(details.data);
      },
      builder: (context, candidateData, rejectedData) {
        return Wrap(
          //   mainAxisSize: MainAxisSize.min,
          children: [
            for (var icon in icons)
              DraggableIcon(
                icon: icon,
                onDragCompleted: () => onIconMoved(icon),
              ),
            if (candidateData.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: const BoxDecoration(
                    color: Colors.white24,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class DraggableIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onDragCompleted;

  const DraggableIcon(
      {super.key, required this.icon, required this.onDragCompleted});

  @override
  Widget build(BuildContext context) {
    return Draggable<IconData>(
      data: icon,
      feedback: Material(
        color: Colors.transparent,
        child: Icon(
          icon,
          size: 48,
          color: Colors.white,
        ),
      ),
      childWhenDragging: Container(
        width: 50,
        height: 50,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white10,
        ),
      ),
      onDragCompleted: onDragCompleted,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white12,
        ),
        padding: const EdgeInsets.all(16),
        child: Icon(
          icon,
          size: 36,
          color: Colors.white,
        ),
      ),
    );
  }
}
