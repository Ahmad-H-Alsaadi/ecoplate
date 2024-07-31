import 'package:ecoplate/app/detect_food_waste/controller/food_survey_controller.dart';
import 'package:ecoplate/app/products/model/products_model.dart';
import 'package:ecoplate/core/constants/color_constants.dart';
import 'package:ecoplate/core/constants/decorations.dart';
import 'package:ecoplate/core/controllers/navigation_controller.dart';
import 'package:ecoplate/core/views/base_view.dart';
import 'package:flutter/material.dart';

class FoodSurveyView extends StatefulWidget {
  final NavigationController navigationController;

  const FoodSurveyView({Key? key, required this.navigationController}) : super(key: key);

  @override
  _FoodSurveyViewState createState() => _FoodSurveyViewState();
}

class _FoodSurveyViewState extends State<FoodSurveyView> {
  late FoodSurveyController controller;

  @override
  void initState() {
    super.initState();
    controller = FoodSurveyController(widget.navigationController);
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: 'Food Waste Survey',
      navigationController: widget.navigationController,
      body: SingleChildScrollView(
        padding: Insets.allPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFoodWasteSection(),
            const SizedBox(height: Sizes.largeSize),
            _buildFeedbackSection(),
            const SizedBox(height: Sizes.largeSize),
            Center(
              child: ElevatedButton(
                onPressed: () => controller.submitSurvey(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorConstants.kPrimaryColor,
                  padding: Insets.symmetricPadding,
                  minimumSize: const Size(Sizes.buttonWidth, Sizes.buttonHeight),
                  shape: const RoundedRectangleBorder(borderRadius: Borders.smallBorderRadius),
                ),
                child: const Text('Submit Survey', style: TextStyles.buttonText),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFoodWasteSection() {
    return Container(
      padding: Insets.mediumPadding,
      decoration: Styles.containerDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Food Waste Information', style: TextStyles.heading2),
          const SizedBox(height: Sizes.mediumSize),
          _buildProductDropdown(),
          const SizedBox(height: Sizes.mediumSize),
          const Text('Quantity received', style: TextStyles.bodyText1),
          ...['Small', 'Medium', 'Large'].map((size) => RadioListTile<String>(
                title: Text(size, style: TextStyles.bodyText2),
                value: size,
                groupValue: controller.survey.quantityReceived,
                onChanged: (value) => setState(() => controller.setQuantityReceived(value!)),
                activeColor: ColorConstants.kAccentColor,
              )),
          const SizedBox(height: Sizes.mediumSize),
          const Text('Quantity wasted', style: TextStyles.bodyText1),
          ...['None', 'Less than 25%', '25% - 50%', '50% - 75%', 'More than 75%']
              .map((quantity) => RadioListTile<String>(
                    title: Text(quantity, style: TextStyles.bodyText2),
                    value: quantity,
                    groupValue: controller.survey.quantityWasted,
                    onChanged: (value) => setState(() => controller.setQuantityWasted(value!)),
                    activeColor: ColorConstants.kAccentColor,
                  )),
          const SizedBox(height: Sizes.mediumSize),
          const Text('Reason for waste', style: TextStyles.bodyText1),
          ...[
            'Food spoiled before it could be used',
            'Overestimated the amount needed',
            'Household members did not like the food',
            'Dietary restrictions/allergies',
            'Other'
          ]
              .map((reason) => CheckboxListTile(
                    title: Text(reason, style: TextStyles.bodyText2),
                    value: controller.survey.wasteReasons.contains(reason),
                    onChanged: (bool? value) {
                      setState(() {
                        List<String> newReasons = List.from(controller.survey.wasteReasons);
                        if (value!) {
                          newReasons.add(reason);
                        } else {
                          newReasons.remove(reason);
                        }
                        controller.setWasteReasons(newReasons, controller.survey.otherWasteReason);
                      });
                    },
                    activeColor: ColorConstants.kAccentColor,
                  ))
              .toList(),
          if (controller.survey.wasteReasons.contains('Other'))
            TextFormField(
              decoration: Styles.textFieldDecoration.copyWith(labelText: 'Please specify other reason'),
              onChanged: (value) => controller.setWasteReasons(controller.survey.wasteReasons, value),
            ),
        ],
      ),
    );
  }

  Widget _buildProductDropdown() {
    return StreamBuilder<List<ProductsModel>>(
      stream: controller.productsStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(color: ColorConstants.kAccentColor);
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('No products available', style: TextStyles.bodyText1);
        }
        List<String> productNames = snapshot.data!.map((product) => product.productName).toList();
        productNames.add('Other');
        return Column(
          children: [
            DropdownButtonFormField<String>(
              decoration: Styles.textFieldDecoration.copyWith(labelText: 'Select Product'),
              items: productNames
                  .map((name) => DropdownMenuItem(value: name, child: Text(name, style: TextStyles.bodyText2)))
                  .toList(),
              onChanged: (String? productName) {
                if (productName != null) {
                  setState(() {
                    controller.setProduct(productName, null);
                  });
                }
              },
            ),
            if (controller.survey.productName == 'Other')
              Padding(
                padding: Insets.symmetricPadding,
                child: TextFormField(
                  decoration: Styles.textFieldDecoration.copyWith(labelText: 'Please specify other product'),
                  onChanged: (value) => controller.setProduct('Other', value),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildFeedbackSection() {
    return Container(
      padding: Insets.mediumPadding,
      decoration: Styles.containerDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Feedback', style: TextStyles.heading2),
          const SizedBox(height: Sizes.mediumSize),
          const Text('How satisfied are you with the food assistance you received?', style: TextStyles.bodyText1),
          ...['Very Satisfied', 'Satisfied', 'Neutral', 'Dissatisfied', 'Very Dissatisfied']
              .map((level) => RadioListTile<String>(
                    title: Text(level, style: TextStyles.bodyText2),
                    value: level,
                    groupValue: controller.survey.satisfactionLevel,
                    onChanged: (value) => setState(() => controller.setSatisfactionLevel(value!)),
                    activeColor: ColorConstants.kAccentColor,
                  ))
              .toList(),
          const SizedBox(height: Sizes.mediumSize),
          TextFormField(
            decoration: Styles.textFieldDecoration.copyWith(
              labelText: 'Suggestions for improvement or additional comments',
              alignLabelWithHint: true,
            ),
            maxLines: 3,
            onChanged: (value) => controller.setImprovementSuggestions(value),
          ),
        ],
      ),
    );
  }
}
