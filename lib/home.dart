import 'package:flutter/material.dart';

class MacOsInspiredDock extends StatefulWidget {
  const MacOsInspiredDock({super.key});

  @override
  State<MacOsInspiredDock> createState() => _MacOsInspiredDockState();
}

class _MacOsInspiredDockState extends State<MacOsInspiredDock> {
  int? hoveredIndex;
  int? draggedIndex;
  double baseItemHeight = 60;
  double verticalItemsPadding = 12;

  List<IconData> icons = [
    Icons.person,
    Icons.message,
    Icons.call,
    Icons.camera,
    Icons.photo,
  ];

  double getScaledSize(int index) {
    const double maxSize = 80;
    const double nonHoveredMaxSize = 60;
    const double adjacentSize = 70;

    if (hoveredIndex == index || draggedIndex == index) {
      return maxSize;
    } else if ((hoveredIndex != null && (index == hoveredIndex! - 1 || index == hoveredIndex! + 1))) {
      return adjacentSize;
    } else {
      return nonHoveredMaxSize;
    }
  }

  double getTranslationY(int index) {
    return (hoveredIndex == index || draggedIndex == index) ? -24 : 0;
  }

  void moveApp(int fromIndex, int toIndex) {
    setState(() {
      IconData draggedIcon = icons.removeAt(fromIndex);
      icons.insert(toIndex, draggedIcon);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Dock background with gradient and rounded corners
            Positioned(
              height: baseItemHeight + 30,
              left: 0,
              right: 0,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF4A90E2),
                      Color(0xFF0065D1),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
            // Dock items with hover and drag functionalities
            Padding(
              padding: EdgeInsets.all(verticalItemsPadding),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(icons.length, (index) {
                  return Draggable<IconData>(
                    data: icons[index],
                    feedback: Material(
                      color: Colors.transparent,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 400), // Increased duration for smoother animation
                        curve: Curves.easeInOut,
                        height: getScaledSize(index),
                        width: getScaledSize(index),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF9F00),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              spreadRadius: 5,
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Icon(
                            icons[index],
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                    childWhenDragging: Container(),
                    onDragStarted: () {
                      setState(() {
                        draggedIndex = index;
                      });
                    },
                    onDragCompleted: () {
                      setState(() {
                        draggedIndex = null;
                      });
                    },
                    onDraggableCanceled: (velocity, offset) {
                      setState(() {
                        hoveredIndex = null;
                      });
                    },
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      onEnter: (event) {
                        setState(() {
                          hoveredIndex = index;
                        });
                      },
                      onExit: (event) {
                        setState(() {
                          if (draggedIndex != index) {
                            hoveredIndex = null;
                          }
                        });
                      },
                      child: DragTarget<IconData>(
                        onAcceptWithDetails: (details) {
                          setState(() {
                            int fromIndex = icons.indexOf(details.data);
                            int toIndex = index;

                            if (fromIndex != toIndex) {
                              moveApp(fromIndex, toIndex);
                            }
                          });
                        },
                        onWillAcceptWithDetails: (details) => true,
                        builder: (context, candidateData, rejectedData) {
                          double margin = (hoveredIndex == index) ? 30 : 10;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 400), // Smoother transition
                            curve: Curves.easeInOut,
                            height: getScaledSize(index),
                            width: getScaledSize(index),
                            alignment: AlignmentDirectional.bottomCenter,
                            margin: EdgeInsets.symmetric(horizontal: margin),
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: hoveredIndex == index
                                      ? const Color(0xFFFFB300)
                                      : const Color(0xFFFF9F00),
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      spreadRadius: 2,
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Icon(
                                    icons[index],
                                    size: 32,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
