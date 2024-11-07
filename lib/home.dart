import 'package:flutter/material.dart';

class MacOsInspiredDock extends StatefulWidget {
  const MacOsInspiredDock({super.key});

  @override
  State<MacOsInspiredDock> createState() => _MacOsInspiredDockState();
}

class _MacOsInspiredDockState extends State<MacOsInspiredDock> {
  /// The index of the currently hovered icon.
  int? hoveredIndex;

  /// The index of the icon currently being dragged.
  int? draggedIndex;

  /// The base height of each dock item.
  double baseItemHeight = 60;

  /// Vertical padding between dock items.
  double verticalItemsPadding = 12;

  /// List of icons to display in the dock.
  List<IconData> icons = [
    Icons.person,
    Icons.message,
    Icons.call,
    Icons.camera,
    Icons.photo,
  ];

  /// Returns the scaled size for an icon based on whether it's hovered or being dragged.
  double getScaledSize(int index) {
    const double maxSize = 80;
    const double nonHoveredMaxSize = 60;

    return (hoveredIndex == index || draggedIndex == index)
        ? maxSize
        : nonHoveredMaxSize;
  }

  /// Returns the vertical translation for an icon based on hover or drag.
  double getTranslationY(int index) {
    return (hoveredIndex == index || draggedIndex == index) ? -24 : 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E), // Background color for the app
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
                      child: Container(
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
                      // Mark the item as being dragged and hovered
                      setState(() {
                        hoveredIndex = index;
                        draggedIndex = index;
                      });
                    },
                    onDragCompleted: () {
                      // Reset the dragged index once drag is complete
                      setState(() {
                        draggedIndex = null;
                      });
                    },
                    onDraggableCanceled: (velocity, offset) {
                      // Reset hovered state if drag is canceled
                      setState(() {
                        hoveredIndex = null;
                      });
                    },
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      onEnter: (event) {
                        // Set the hovered index when mouse enters the region
                        setState(() {
                          hoveredIndex = index;
                        });
                      },
                      onExit: (event) {
                        // Reset hovered index when mouse exits
                        setState(() {
                          if (draggedIndex != index) {
                            hoveredIndex = null;
                          }
                        });
                      },
                      child: DragTarget<IconData>(
                        onAcceptWithDetails: (details) {
                          // Handle the drag-and-drop logic
                          setState(() {
                            int fromIndex = icons.indexOf(details.data);
                            int toIndex = index;

                            // Only move if the source and target are different
                            if (fromIndex != toIndex) {
                              IconData draggedIcon = icons.removeAt(fromIndex);
                              icons.insert(toIndex, draggedIcon);
                              hoveredIndex = null; // Reset hover state
                            }
                          });
                        },
                        onWillAcceptWithDetails: (details) => true,
                        builder: (context, candidateData, rejectedData) {
                          // Set margin for the hovered item
                          double margin = (hoveredIndex == index) ? 30 : 10;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 500),
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
