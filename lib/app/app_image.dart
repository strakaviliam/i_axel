import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'app_progress.dart';

class AppImage extends StatefulWidget {

  final dynamic content;
  final Color? color;
  final AppImage? errorImage;
  final Size size;
  final BoxFit boxFit;
  final int alignH;
  final int alignV;

  const AppImage(this.content, {
    Key? key,
    this.color,
    this.errorImage,
    this.size = const Size(0,0),
    this.boxFit = BoxFit.scaleDown,
    this.alignH = 0,
    this.alignV = 0,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AppImageState();
}

class _AppImageState extends State<AppImage> {

  BoxFit boxFit = BoxFit.scaleDown;
  int alignH = 0;
  int alignV = 0;

  @override
  void initState() {
    super.initState();
    _setState();
  }

  void _setState() {
    boxFit = widget.boxFit;
    alignH = widget.alignH;
    alignV = widget.alignV;
  }

  @override
  void didUpdateWidget(AppImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.boxFit != boxFit || widget.alignV != alignV || widget.alignH != alignH) {
      _setState();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {

    if (widget.content is String) {

      if (widget.content == '') {
        return Container();
      }

      final String path = widget.content as String;

      final Alignment align = Alignment(alignH.toDouble(), alignV.toDouble());

      return LayoutBuilder(builder: (context, constraint) {
        final double useWidth = widget.size == null ? constraint.biggest.width : (widget.size.width == 0 ? constraint.biggest.width : widget.size.width);
        final double useHeight = widget.size == null ? constraint.biggest.height : (widget.size.height == 0 ? constraint.biggest.height : widget.size.height);

        Widget image;

        if (path.startsWith('http')) {
          image = CachedNetworkImage(
            imageUrl: path,
            width: useWidth,
            height: useHeight,
            fit: boxFit,
            alignment: align,
            progressIndicatorBuilder: (context, url, loadingProgress) {
              double size = 26;
              if (constraint.biggest.width < 30) {
                size = 15;
              }
              return Center(
                child:  SizedBox(
                  width: size,
                  height: size,
                  child: const AppProgress(),
                ),
              );
            },
          );
        } else {
          image = Image(
            width: useWidth,
            height: useHeight,
            image: AssetImage(path),
            color: widget.color,
            fit: boxFit,
            alignment: align,
          );
        }

        if (image != null) {
          return SizedBox(
            width: useWidth,
            height: useHeight,
            child: Center(child: image),
          );
        }

        image = Container(padding: const EdgeInsets.all(5), child: const Center(child: SizedBox(width: 30, height: 30, child: AppProgress())));

        return image;
      });
    } else if (widget.content is IconData) {
      //icon
      return LayoutBuilder(builder: (context, constraint) {
        final double useWidth = widget.size == null ? constraint.biggest.width : (widget.size.width == 0 ? constraint.biggest.width : widget.size.width);
        final double useHeight = widget.size == null ? constraint.biggest.height : (widget.size.height == 0 ? constraint.biggest.height : widget.size.height);
        return SizedBox(
          width: useWidth,
          height: useHeight,
          child: Icon(
            widget.content as IconData,
            color: widget.color ?? Colors.black,
            size: useHeight*0.8,
          ),
        );
      });
    }

    return const Placeholder();
  }

}
