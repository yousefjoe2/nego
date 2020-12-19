import 'package:about/about.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AboutPage(
      title: Text('النقوشی'),
      // applicationVersion: 'Version {{ version }}',
      applicationDescription: Text(
        '''
        مؤسسة النقوشی لمعدات الصيد و الفروسية والبنادق الهوائية ت: 50879797 – 24336426

بنادق_صيد لنادق_هوائية#

بنادق_صيد #بنادق_هوائية وكيل حصري لكبرى الشركات العالمية . متخصصين في البنادق الهوائية واكسسوارتها ۔ العنوان: الضجيج – مجمع الأمول

الإدارة مبيعات

ت: 50879797- 24336426 الاسلحة . اسلحة الصيد . بنادق صيد – المسدس – النخيرة – أولمبي – إكسسورات – اكسسوارات صيد – الصيانه – بنادق هوائية

بيع البنادق الهوائية# بنادق الصيد وذخائرها وكافة مستلزمات الصيد# مؤسسة النقوش التجارة بنادق الصيد وذخائرها وكافة مستلزمات الصيد

بنادق_صيد هوائية أنواع أسلحة الصيد واسعارها البندقية الهوائية أو بندقية ضغط الهواء متخصصون في بيع أدوات الصيد واكسسواراتها

بنادق_هوائية#
        ''',
        softWrap: true,
        style: GoogleFonts.tajawal()
            .copyWith(fontSize: 16, fontWeight: FontWeight.normal),
        textAlign: TextAlign.right,
      ),
      applicationIcon: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/fav2.png',
            color: Colors.amber,
            scale: 3,
          ),
          Image.asset(
            'assets/images/loqo.png',
            color: Colors.amber,
            scale: 3,
          ),
        ],
      ),
      applicationLegalese: 'جميع الحقوق محفوظة لمتجر النقوشی ©  {{ year }}',
      children: <Widget>[
        Directionality(
          textDirection: TextDirection.rtl,
          child: LicensesPageListTile(
            title: InkWell(
                onTap: () => _launchURL(
                    'fb://%D9%86%D9%82%D9%88%D8%B4%D9%8A-100679771706877/'),
                child: Text('Facebook')),
            icon: FaIcon(
              FontAwesomeIcons.facebook,
              color: Colors.blue,
            ),
          ),
        ),
        Directionality(
          textDirection: TextDirection.rtl,
          child: LicensesPageListTile(
            title: InkWell(
              onTap: () => _launchURL('https://www.instagram.com/negochi.kt/'),
              child: Text('Instagram'),
            ),
            icon: FaIcon(FontAwesomeIcons.instagram),
          ),
        ),
      ],
    );
  }
}

_launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
