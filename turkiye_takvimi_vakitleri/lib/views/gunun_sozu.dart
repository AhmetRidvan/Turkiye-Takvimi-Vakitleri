import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:html/parser.dart';
import 'package:turkiye_takvimi_vakitleri/models/arka_sayfa_model.dart';
import 'package:widget_zoom/widget_zoom.dart';

class GununSozu extends StatefulWidget {
  GununSozu({super.key, required this.ark});

  ArkaSayfaModel ark;

  @override
  State<GununSozu> createState() => _GununSozuState();
}

class _GununSozuState extends State<GununSozu> {
  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).colorScheme;
    final parsed = parse(widget.ark.veri!.gununSozu);
    final parsed2 = parse(widget.ark.veri!.gununOlayi);
    return Scaffold(
      body: SafeArea(
        child: WidgetZoom(
          heroAnimationTag: 'se',
          zoomWidget: Dialog(
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Container(
                decoration: BoxDecoration(
                  color: themeColor.onPrimary,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        parsed.body!.text,
                        textAlign: TextAlign.center,

                        style: TextStyle(
                          fontSize: 35.sp,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      Image.asset(
                        width: 300.w,
                        'images/divider2.png',
                        color: Theme.of(context).colorScheme.error,
                      ),

                      Text(
                        parsed2.body!.text,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 35.sp,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          size: 35.sp,
                          Icons.keyboard_return_rounded,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
