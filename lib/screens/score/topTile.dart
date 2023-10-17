import 'package:flutter/material.dart';

class TopTile extends StatefulWidget {
  final Color col;
  final String nr;
  final String score;
  final double height;
  final String img;
  final String name;
  TopTile({required this.col, required this.nr, required this.score, required this.height, required this.img, required this.name});

  @override
  _TopTileState createState() => _TopTileState();
}

class _TopTileState extends State<TopTile> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Tween<double> _tween = Tween(begin: 0.35, end: 1);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 900), vsync: this);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(20),
          child: ScaleTransition(
              scale: _tween.animate(CurvedAnimation(
                  parent: _controller, curve: Curves.elasticOut)),
              child: CircleAvatar(
                radius: 28,
                backgroundImage: widget.img != "" && widget.img != null
                    ? NetworkImage(widget.img)
                    : const AssetImage("assets/profilePic.png")  as ImageProvider,
              )),
          decoration: BoxDecoration(
            border: Border.all(
                color: widget.col, width: 4),
            shape: BoxShape.circle,
          ),
        ),
        Transform.translate(
          offset: Offset(0, -10),
          child: Container(
            width: 115,
            child: Text(
              widget.name.split(" ")[0],
              textScaleFactor: 1.0,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        ScaleTransition(
              scale: _tween.animate(CurvedAnimation(
                  parent: _controller, curve: Curves.elasticOut)),
              child:Container(
                decoration: BoxDecoration(
                  color: widget.col,
                  borderRadius: const BorderRadius.only(topLeft: const Radius.circular(15), topRight: const Radius.circular(15))
                ),
          width: 100,
          height: widget.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.nr,
                textScaleFactor: 1.0,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "${widget.score}",
                textScaleFactor: 1.0,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                "poeng",
                textScaleFactor: 1.0,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          ),
        ),
      ],
    );
  }
}
