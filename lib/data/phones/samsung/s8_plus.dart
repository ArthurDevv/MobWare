import 'package:flutter/material.dart';
import 'package:mobwear/custom_icons/brand_icons.dart';
import 'package:mobwear/providers/customization_provider.dart';
import 'package:mobwear/utils/constants.dart';
import 'package:mobwear/widgets/phone_widgets/back_panel.dart';
import 'package:mobwear/widgets/phone_widgets/camera.dart';
import 'package:mobwear/widgets/phone_widgets/camera_bump.dart';
import 'package:mobwear/widgets/phone_widgets/flash.dart';
import 'package:mobwear/widgets/phone_widgets/screen.dart';
import 'package:mobwear/widgets/phone_widgets/heart_rate_sensor.dart';
import 'package:provider/provider.dart';

class S8Plus extends StatelessWidget {
  static final int phoneIndex = 1;
  static final int phoneID = 0301;
  static final int phoneBrandIndex = 2;
  static const String phoneBrand = 'Samsung';
  static const String phoneModel = 'Galaxy';
  static const String phoneName = 'Galaxy S8+';

  static final Camera camera1 = Camera(
    trimColor: Colors.grey[700],
    diameter: 14.0,
    lenseDiameter: 4.0,
    trimWidth: 1.0,
  );

  final Screen front = Screen(
    phoneName: phoneName,
    phoneModel: phoneModel,
    phoneBrand: phoneBrand,
    phoneID: phoneID,
    screenWidth: 240.0,
    screenHeight: 490.0,
    horizontalPadding: 6.0,
    verticalPadding: 25.0,
    screenAlignment: Alignment(0.0, -0.1),
    innerCornerRadius: 20.0,
    cornerRadius: 25.0,
    screenItems: <Widget>[
      Align(
        alignment: Alignment(0.9, -0.965),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: 42.0,
            height: 20.0,
            decoration: BoxDecoration(
                color: Colors.black, borderRadius: BorderRadius.circular(20.0)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  camera1,
                  camera1,
                ],
              ),
            ),
          ),
        ),
      ),
    ],
  );

  get getPhoneFront => front;
  get getPhoneName => phoneName;
  get getPhoneBrand => phoneBrand;
  get getPhoneBrandIndex => phoneBrandIndex;
  get getPhoneIndex => phoneIndex;

  @override
  Widget build(BuildContext context) {
    var phonesBox = Provider.of<CustomizationProvider>(context).phonesBox;

    var colors = phonesBox.get(phoneID).colors;
    var textures = phonesBox.get(phoneID).textures;

    Color backPanelColor = colors['Back Panel'];
    Color cameraBumpColor = colors['Camera'];
    Color logoColor = colors['Samsung Logo'];
    Color bezelsColor = colors['Bezels'];

    String cameraBumpTexture = textures['Camera'].asset;
    Color cameraBumpTextureBlendColor = textures['Camera'].blendColor;
    BlendMode cameraBumpTextureBlendMode =
        kGetTextureBlendMode(textures['Camera'].blendModeIndex);

    String backPanelTexture = textures['Back Panel'].asset;
    Color backPanelTextureBlendColor = textures['Back Panel'].blendColor;
    BlendMode backPanelTextureBlendMode =
        kGetTextureBlendMode(textures['Back Panel'].blendModeIndex);

    Camera camera2 = Camera(
      diameter: 20.0,
      trimWidth: 3.0,
      lenseDiameter: 8.0,
      trimColor: Colors.grey[900],
    );

    CameraBump cameraBump = CameraBump(
      width: 160.0,
      height: 40.0,
      cornerRadius: 10.0,
      cameraBumpColor: cameraBumpColor,
      backPanelColor: backPanelColor,
      texture: cameraBumpTexture,
      textureBlendColor: cameraBumpTextureBlendColor,
      textureBlendMode: cameraBumpTextureBlendMode,
      cameraBumpPartsPadding: 2.0,
      borderWidth: 1.2,
      borderColor: Colors.grey[500],
      cameraBumpParts: [
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              camera2,
              camera2,
              Row(
                children: <Widget>[
                  camera2,
                  SizedBox(width: 10.0),
                  Flash(diameter: 15.0),
                  SizedBox(width: 4.0),
                  HeartRateSensor(),
                ],
              ),
            ],
          ),
        ),
      ],
    );

    return FittedBox(
      child: BackPanel(
        height: 490,
        cornerRadius: 25.0,
        backPanelColor: backPanelColor,
        bezelsColor: bezelsColor,
        texture: backPanelTexture,
        textureBlendColor: backPanelTextureBlendColor,
        textureBlendMode: backPanelTextureBlendMode,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(
              width: 240.0,
              height: 490.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.0),
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    backPanelColor.computeLuminance() > 0.335
                        ? Colors.black.withOpacity(0.019)
                        : Colors.black.withOpacity(0.025),
                  ],
                  stops: [0.2, 0.2],
                  begin: FractionalOffset(0.7, 0.3),
                  end: FractionalOffset(0.0, 0.5),
                ),
              ),
              child: Align(
                alignment: Alignment(-0.150, -0.3),
                child: Icon(
                  BrandIcons.samsung3,
                  color: logoColor,
                  size: 54.0,
                ),
              ),
            ),
            Align(
              alignment: Alignment(0.0, -0.7),
              child: cameraBump,
            ),
          ],
        ),
      ),
    );
  }
}
