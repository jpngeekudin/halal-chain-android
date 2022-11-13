import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:logger/logger.dart';

class HomeItemWidget extends StatefulWidget {
  const HomeItemWidget({
    Key? key,
    required this.title,
    required this.subtitle,
    this.isDone = false,
    this.route,
    this.routeView,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final bool isDone;
  final String? route;
  final String? routeView;

  @override
  State<HomeItemWidget> createState() => _HomeItemWidgetState();
}

class _HomeItemWidgetState extends State<HomeItemWidget> {
  @override
  Widget build(BuildContext context) {
    return  InkWell(
      onTap: () {
        try {
          String? route = widget.isDone && widget.routeView != null
            ? widget.routeView : widget.route;

          if (route != null) {
            Navigator.of(context).pushNamed(route).then((value) {
              setState(() { });
            });
          }
        }

        catch(err) {
          final _logger = Logger();
          _logger.e(err);
          String message = err.toString();
          final snackBar = SnackBar(content: Text(message));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: widget.isDone
                ? Theme.of(context).primaryColor.withOpacity(0.2)
                : Colors.grey[400]!.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            width: 60,
            height: 60,
            alignment: Alignment.center,
            child: widget.isDone 
              ? Icon(Icons.check_circle, color: Theme.of(context).primaryColor)
              : Icon(Icons.watch_later_outlined, color: Colors.grey[800]),
          ),
          SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.title, style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16
                )),
                Text(widget.subtitle, style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12
                ),)
              ],
            ),
          ),
          Icon(Icons.chevron_right, size: 48, color: Theme.of(context).primaryColor)
        ],
      ),
    );
  }
}