import 'package:flutter/material.dart';


class MacOsInspiredDoc extends StatefulWidget {
  const MacOsInspiredDoc({super.key});

  @override
  State<MacOsInspiredDoc> createState() => _MacOsInspiredDockState();
}

class _MacOsInspiredDockState extends State<MacOsInspiredDoc> {
  int? hoveredIndex; // Index of the item being hovered over
  int? draggedIndex; // Index of the item currently being dragged
  double baseItemHeight = 60; // Base height for each item in the dock
  double verticalItemsPadding = 12; // Padding between items
  List<String> items = ['A', 'B', 'C', 'D', 'E']; // List of items in the dock

  /// Scales the size of the dock item based on whether it's hovered or dragged.
  double getScaledSize(int index) {
    const double maxSize = 80;
    const double nonHoveredMaxSize = 60;

    // Return the size based on whether the item is hovered or dragged
    if (hoveredIndex == index || draggedIndex == index) {
      return maxSize;
    }
    return nonHoveredMaxSize;
  }

  /// Adjusts the Y translation for the dragged or hovered item.
  double getTranslationY(int index) {
    return (hoveredIndex == index || draggedIndex == index) ? -24 : 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E), // Dark background for modern look
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Dock background with gradient and rounded corner
            Positioned(
              height: baseItemHeight + 30,
              left: 0,
              right: 0,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF4A90E2), // Soft blue for a more polished feel
                      Color(0xFF0065D1), // Darker blue to match macOS dock style
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
                children: List.generate(items.length, (index) {
                  return Draggable<String>(
                    data: items[index],
                    feedback: Material(
                      color: Colors.transparent,
                      child: Opacity(
                        opacity: 0.8,
                        child: Container(
                          height: 100, // Larger feedback size
                          width: 100,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF9F00), // Vibrant amber feedback
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
                            child: Text(
                              items[index],
                              style: const TextStyle(
                                fontSize: 40,
                                color: Colors.white,
                                fontWeight: FontWeight.bold, // Emphasized text
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    childWhenDragging: Container(), // Empty space when dragging
                    onDragStarted: () {
                      setState(() {
                        hoveredIndex = index; // Highlight item being dragged
                        draggedIndex = index; // Track dragged item
                      });
                    },
                    onDragCompleted: () {
                      setState(() {
                        draggedIndex = null; // Reset dragged item after completion
                      });
                    },
                    onDraggableCanceled: (velocity, offset) {
                      setState(() {
                        hoveredIndex = null; // Reset hovered item if drag is canceled
                      });
                    },
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click, // Change cursor to 'click' on hover
                      onEnter: (event) {
                        setState(() {
                          hoveredIndex = index; // Set hovered item index
                        });
                      },
                      onExit: (event) {
                        setState(() {
                          // Reset hovered index when mouse leaves
                          if (draggedIndex != index) {
                            hoveredIndex = null;
                          }
                        });
                      },
                      child: DragTarget<String>(
                        onAcceptWithDetails: (details) {
                          setState(() {
                            int fromIndex = items.indexOf(details.data);
                            int toIndex = index;

                            // Move item in the list with smooth animation
                            if (fromIndex != toIndex) {
                              String draggedItem = items.removeAt(fromIndex);
                              items.insert(toIndex, draggedItem);
                              hoveredIndex = null; // Reset hovered index after move
                            }
                          });
                        },
                        onWillAcceptWithDetails: (details) {
                          return true; // Allow drop
                        },
                        builder: (context, candidateData, rejectedData) {
                          double margin = (hoveredIndex == index) ? 30 : 10; // Space adjustment for hovered items
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut, // Smooth animation
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
                                      ? const Color(0xFFFFB300) // Lighter amber on hover
                                      : const Color(0xFFFF9F00), // Default amber color
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
                                  child: Text(
                                    items[index],
                                    style: const TextStyle(
                                      fontSize: 22,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
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
