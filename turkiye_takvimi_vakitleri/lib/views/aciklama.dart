import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:widget_zoom/widget_zoom.dart';

class Aciklama extends StatefulWidget {
  const Aciklama({super.key});

  @override
  State<Aciklama> createState() => _AciklamaState();
}

class _AciklamaState extends State<Aciklama> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: Row(
          mainAxisSize: MainAxisSize.min, // Butonlar çok kenara yapışmasın
          children: [
            FloatingActionButton(
              heroTag: "btn1", // Hero animasyon hatasını engellemek için
              backgroundColor: Theme.of(context).colorScheme.primary,
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Icon(Icons.arrow_back),
            ),
            SizedBox(width: 10.w), // Butonlar arası boşluk
            FloatingActionButton(
              heroTag: "btn2", // Hero animasyon hatasını engellemek için
              backgroundColor: Theme.of(context).colorScheme.primary,
              onPressed: () {
                showDialog(
                  context: context,
                  barrierDismissible: true, // dışarı tıklayınca kapanması için
                  builder: (context) {
                    return Dialog(
                      insetPadding: EdgeInsets.zero, // kenar boşluğunu sıfırla
                      backgroundColor: Colors.white,
                      child: SizedBox.expand(
                        // tam ekran yap
                        child: Stack(
                          children: [
                            SfPdfViewer.network(
                              'https://www.turktakvim.com/pdf/MuhimAciklama.TT.pdf',
                            ),
                            Positioned(
                              bottom: 30.h,
                              right: 30.w,
                              child: IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: Icon(
                                  Icons.arrow_back,
                                  size: 50.w,
                                  color: Theme.of(context).colorScheme.error,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              child: Icon(Icons.description_sharp),
            ),
          ],
        ),

        body: SingleChildScrollView(
          child: ClipRRect(
            borderRadius: BorderRadiusGeometry.circular(30),
            child: Column(
              children: [
                WidgetZoom(
                  heroAnimationTag: 'Detaylı bilgi',
                  zoomWidget: Image.asset(
                    'images/NAMAZ VAKİTLERİ AÇIKLAMA-1.jpg',
                  ),
                ),
                WidgetZoom(
                  heroAnimationTag: 'asddad',
                  zoomWidget: Image.asset(
                    'images/NAMAZ VAKİTLERİ AÇIKLAMA-2.jpg',
                  ),
                ),
                WidgetZoom(
                  heroAnimationTag: 'asqqqd',
                  zoomWidget: Image.asset(
                    'images/NAMAZ VAKİTLERİ AÇIKLAMA-3.jpg',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
