import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:mobwear/data/models/texture_model.dart';
import 'package:mobwear/providers/customization_provider.dart';
import 'package:mobwear/utils/constants.dart';
import 'package:mobwear/widgets/app_widgets/custom_snack_bar.dart';
import 'package:mobwear/widgets/app_widgets/customization_indicator.dart';
import 'package:mobwear/widgets/app_widgets/customization_picker_dialog.dart';
import 'package:mobwear/widgets/app_widgets/elevated_card.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mobwear/widgets/app_widgets/show_up_widget.dart';
import 'package:provider/provider.dart';

class CustomizationPickerTile extends StatelessWidget {
  final String title;
  final int index;
  final Color color;
  final MyTexture texture;
  final Map colors, textures;
  final bool noTexture, noImage, isSharePage;

  const CustomizationPickerTile({
    this.title,
    this.index,
    this.color,
    this.texture,
    this.colors,
    this.textures,
    this.noTexture = false,
    this.noImage = true,
    this.isSharePage = false,
  });

  @override
  Widget build(BuildContext context) {
    MyTexture texture =
        noTexture ? null : this.texture ?? textures.values.elementAt(index);
    Color color = this.color ?? colors.values.elementAt(index);

    final SlidableController slidableController = SlidableController();

    return ShowUp(
      direction: ShowUpFrom.bottom,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
        child: Slidable(
          controller: slidableController,
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.2,
          actions: isSharePage
              ? null
              : <Widget>[
                  slidableActionButton(
                    margin: EdgeInsets.only(right: 8.0),
                    context: context,
                    caption: 'Reset',
                    icon: LineAwesomeIcons.refresh,
                    color: kBrightnessAwareColor(context,
                        lightColor: Colors.red[800],
                        darkColor: Colors.red[500]),
                    onTap: () => onResetPressed(context),
                  ),
                ],
          secondaryActions: isSharePage
              ? null
              : <Widget>[
                  slidableActionButton(
                    margin: EdgeInsets.only(left: 8.0),
                    context: context,
                    caption: 'Copy',
                    icon: LineAwesomeIcons.copy,
                    color: kBrightnessAwareColor(context,
                        lightColor: Colors.green[800],
                        darkColor: Colors.green[500]),
                    onTap: () => onCopyPressed(context),
                  ),
                  slidableActionButton(
                    margin: EdgeInsets.only(left: 8.0),
                    context: context,
                    caption: 'Paste',
                    icon: LineAwesomeIcons.paste,
                    color: kBrightnessAwareColor(context,
                        lightColor: Colors.blue[800],
                        darkColor: Colors.blue[500]),
                    onTap: () => onPastePressed(context),
                    isEnabled: Provider.of<CustomizationProvider>(context)
                        .isCustomizationCopied,
                  ),
                ],
          child: ElevatedCard(
            child: ListTile(
              title: Text(title ?? colors.keys.elementAt(index),
                  style: kTitleTextStyle),
              subtitle: Text(
                noTexture
                    ? 'Color: #${kGetColorString(color)}'
                    : texture.asset == null
                        ? 'Color: #${kGetColorString(color)}'
                        : 'Texture: ${kGetTextureName(texture.asset)}',
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  color: kBrightnessAwareColor(context,
                      lightColor: Colors.black54, darkColor: Colors.white54),
                ),
              ),
              trailing: CustomizationIndicator(
                color: color,
                texture: noTexture ? null : texture.asset,
                textureBlendColor: noTexture ? null : texture.blendColor,
                textureBlendMode: noTexture
                    ? null
                    : kGetTextureBlendMode(texture.blendModeIndex),
              ),
              onTap: () => onTilePressed(context),
            ),
          ),
        ),
      ),
    );
  }

  ElevatedCard slidableActionButton({
    BuildContext context,
    String caption,
    IconData icon,
    Color color,
    EdgeInsetsGeometry margin,
    Function onTap,
    bool isEnabled = true,
  }) {
    return ElevatedCard(
      margin: margin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: IconSlideAction(
          onTap: isEnabled ? onTap : null,
          caption: caption,
          icon: icon,
          color: Colors.transparent,
          foregroundColor: isEnabled
              ? color
              : kBrightnessAwareColor(context,
                  lightColor: Colors.grey[400], darkColor: Colors.grey[600]),
        ),
      ),
    );
  }

  void onTilePressed(BuildContext context) {
    Provider.of<CustomizationProvider>(context).isSharePage = false;
    Provider.of<CustomizationProvider>(context).selectedTexture = null;
    Provider.of<CustomizationProvider>(context).changeCopyStatus(false);
    Provider.of<CustomizationProvider>(context).setCurrentSide(index);
    Provider.of<CustomizationProvider>(context).getCurrentColor(index);
    Provider.of<CustomizationProvider>(context).resetSelectedValues();

    if (!noTexture)
      Provider.of<CustomizationProvider>(context)
          .getCurrentSideTextureDetails(i: index);

    int initIndex() {
      if (noTexture) {
        return 0;
      } else {
        if (Provider.of<CustomizationProvider>(context).currentTexture != null)
          return 1;
      }
      return 0;
    }

    showDialog<Widget>(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: CustomizationPickerDialog(
          noTexture: noTexture,
          initPickerModeIndex: initIndex(),
        ),
      ),
    );
  }

  void onResetPressed(BuildContext context) {
    Provider.of<CustomizationProvider>(context).setCurrentSide(index);
    Provider.of<CustomizationProvider>(context).setTempValues(noTexture);
    Provider.of<CustomizationProvider>(context).resetCustomization(noTexture);
    CustomSnackBar.showSnackBar(
      context,
      noTexture: noTexture,
      undo: true,
      text:
          '${Provider.of<CustomizationProvider>(context).currentSide} customization reset',
    );
  }

  void onCopyPressed(BuildContext context) {
    Provider.of<CustomizationProvider>(context).setCurrentSide(index);
    Provider.of<CustomizationProvider>(context).setPreviousSide();
    Provider.of<CustomizationProvider>(context).copyCustomization(noTexture);
    CustomSnackBar.showSnackBar(
      context,
      noTexture: noTexture,
      text:
          '${Provider.of<CustomizationProvider>(context).currentSide} customization copied',
    );
  }

  void onPastePressed(BuildContext context) {
    String previousSide =
        Provider.of<CustomizationProvider>(context).previousSide;
    Provider.of<CustomizationProvider>(context).setCurrentSide(index);
    Provider.of<CustomizationProvider>(context).setTempValues(noTexture);
    try {
      Provider.of<CustomizationProvider>(context).pasteCustomization(noTexture);
      CustomSnackBar.showSnackBar(
        context,
        noTexture: noTexture,
        undo: true,
        text:
            '$previousSide customization pasted to ${Provider.of<CustomizationProvider>(context).currentSide}',
      );
    } catch (e) {
      CustomSnackBar.showSnackBar(
        context,
        noTexture: noTexture,
        text: 'Cannot apply texture here',
      );
    }
  }
}
