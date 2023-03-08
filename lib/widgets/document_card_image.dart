import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:math' as math;

class DocumentCardImage extends StatefulWidget {
  const DocumentCardImage({
    Key? key,
    required this.cardFront,
    required this.cardBack,
  }) : super(key: key);

  final Uint8List cardFront;
  final Uint8List cardBack;

  @override
  State<DocumentCardImage> createState() => _DocumentCardImageState();
}

class _DocumentCardImageState extends State<DocumentCardImage>
    with SingleTickerProviderStateMixin {
  double angle = 0;
  bool isSelectedImage = true;
  bool firstTap = true;
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              5.0,
            ),
            border: Border.all(color: Theme.of(context).colorScheme.primary)),
        child: TabBar(
          controller: _tabController,
          indicator: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
          ),
          unselectedLabelColor: Theme.of(context).colorScheme.primary,
          tabs: const [
            Tab(
              text: 'Front View',
            ),
            Tab(
              text: 'Back View',
            ),
          ],
          onTap: (value) {
            if (_tabController!.index == 0) {
              setState(() {
                angle = 0;
              });
            } else {
              setState(() {
                angle = math.pi;
              });
            }
          },
        ),
      ),
      const SizedBox(
        height: 20,
      ),
      GestureDetector(
        onTap: () {
          //change tabcontrol to that of image i.e. tab sync with image

          if (firstTap &&
              _tabController!.previousIndex == _tabController!.index) {
            log(_tabController!.previousIndex.toString());
            log(_tabController!.index.toString());

            _tabController!.animateTo(_tabController!.index + 1);
            firstTap = false;
          } else {
            _tabController!.animateTo(_tabController!.previousIndex,
                duration: const Duration(milliseconds: 600));
          }
          setState(() {
            angle = (angle + math.pi) % (2 * math.pi);
          });
        },
        child: TweenAnimationBuilder(
            tween: Tween<double>(begin: 0, end: angle),
            duration: const Duration(milliseconds: 600),
            builder: (context, value, _) {
              if (value >= (math.pi / 2)) {
                isSelectedImage = false;
              } else {
                isSelectedImage = true;
              }
              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(value),
                child: SizedBox(
                  width: width,
                  height: 230,
                  child: isSelectedImage
                      ? Image.memory(
                          widget.cardFront,
                          fit: BoxFit.contain,
                        )
                      : Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()..rotateY(math.pi),
                          child: Image.memory(
                            widget.cardBack,
                            fit: BoxFit.contain,
                          ),
                        ),
                ),
              );
            }),
      ),
    ]);
  }
}
