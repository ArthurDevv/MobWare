import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:mobware/data/models/phone_model.dart';
import 'package:mobware/pages/edit_phone_page.dart';
import 'package:mobware/providers/settings_provider.dart';
import 'package:mobware/utils/constants.dart';
import 'package:provider/provider.dart';

class PhoneCarousel extends StatefulWidget {
  final List<PhoneModel> phoneList;
  final SwiperController controller;

  PhoneCarousel(this.phoneList, this.controller);

  @override
  _PhoneCarouselState createState() => _PhoneCarouselState();
}

class _PhoneCarouselState extends State<PhoneCarousel> {
  bool autoplay;
  SwiperController controller;

  @override
  void initState() {
    super.initState();
    controller = widget.controller;
  }

  @override
  Widget build(BuildContext context) {
    List<PhoneModel> phoneList = widget.phoneList;
    int reverseIndex(i) => phoneList.length - 1 - i;

    return Swiper(
      controller: controller,
      itemCount: phoneList.length,
      itemBuilder: (context, i) {
        return Padding(
          padding: EdgeInsets.all(kScreenAwareSize(24.0, context)),
          child: Hero(
            tag: phoneList[reverseIndex(i)].id,
            child: phoneList[reverseIndex(i)].phone,
          ),
        );
      },
      autoplay: Provider.of<SettingsProvider>(context).autoplayCarousel,
      autoplayDisableOnInteraction: true,
      duration: 800,
      outer: true,
      fade: 0.0,
      viewportFraction: 1.0,
      scale: 1.0,
      pagination: SwiperPagination(
        margin: EdgeInsets.only(right: 50.0, bottom: 8.0),
        builder: DotSwiperPaginationBuilder(
          activeColor: kBrightnessAwareColor(context,
              lightColor: Colors.black, darkColor: Colors.white),
          color: kBrightnessAwareColor(context,
              lightColor: Colors.grey[350], darkColor: Colors.grey[800]),
          size: kScreenAwareSize(8.0, context),
          activeSize: kScreenAwareSize(8.0, context),
        ),
      ),
      onTap: (i) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return EditPhonePage(
                phone: phoneList[reverseIndex(i)].phone,
                phoneList: phoneList,
                phoneIndex: reverseIndex(i),
              );
            },
          ),
        ).whenComplete(() {
          widget.controller.move(i, animation: false);
        });
      },
    );
  }
}
