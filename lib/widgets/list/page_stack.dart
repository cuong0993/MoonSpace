import 'package:flutter/material.dart';

class PageStack extends StatefulWidget {
  const PageStack({super.key, required this.children});

  final List<Widget> children;

  @override
  State<PageStack> createState() => _PageStackState();
}

class _PageStackState extends State<PageStack> {
  late final PageController con;

  @override
  void initState() {
    con = PageController();
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    con.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(48),
      ),
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.all(8.0),
      child: AspectRatio(
        aspectRatio: 1.7,
        child: AnimatedBuilder(
          animation: con,
          builder: (context, child) {
            final p = con.hasClients ? (con.page?.floor() ?? 0) : 0;
            final v = con.hasClients ? ((con.page ?? 0) - p) : 0;

            return Stack(
              fit: StackFit.expand,
              children: [
                Opacity(
                  opacity: (1 - v).toDouble(),
                  child: Transform.scale(
                    scale: 1.2 - (1 - v).toDouble() * .2,
                    child: widget.children[p],
                  ),
                ),
                Opacity(
                  opacity: v.toDouble(),
                  child: Transform.scale(
                    scale: 1.2 - (v).toDouble() * .2,
                    child: widget.children[p],
                  ),
                ),
                PageView.builder(
                  physics: const BouncingScrollPhysics(),
                  pageSnapping: true,
                  controller: con,
                  itemCount: widget.children.length,
                  itemBuilder: (context, index) {
                    return const SizedBox();
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
