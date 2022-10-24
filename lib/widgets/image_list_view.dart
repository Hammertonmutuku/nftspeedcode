import 'dart:async';
import 'dart:math';

import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';

class ImageListView extends StatefulWidget {
  const ImageListView({super.key, required this.startIndex,  this.duration = 0});

  final int startIndex;

  final int duration;

  @override
  State<ImageListView> createState() => _ImageListViewState();
}

class _ImageListViewState extends State<ImageListView> {

  late  ScrollController _scrollController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController = ScrollController();

    _scrollController.addListener(() {
      //Detect if is at the end of list view
      if(_scrollController.position.atEdge) {
        _autoScroll();
      }
     });

   //added to make sure that controller has been attacted to list view
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _autoScroll();
     });
  }

  _autoScroll() {

    final _currentScrollPosition = _scrollController.offset;
    final _scrollEndPosition = _scrollController.position.maxScrollExtent;

    scheduleMicrotask( () {
   _scrollController.animateTo(_currentScrollPosition == _scrollEndPosition ? 0 : _scrollEndPosition,
    duration:  Duration(seconds: widget.duration),
     curve: Curves.linear,
   );
    });
  }
  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: 1.96 * pi,
      child: SizedBox(
        height: 130,
        child: ListView.builder(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              return _ImageTile(image: 'assets/images/nfts/${widget.startIndex + index }.png');
            },
            itemCount: 10),
      ),
    );
  }
}

class _ImageTile extends StatelessWidget {
  const _ImageTile({Key? key, required this.image}) : super(key: key);

  final String image;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Hero(
        tag: image,
        child: Image.asset(
          image,
          width: 130,
        ),
      ),
    );
  }
}
