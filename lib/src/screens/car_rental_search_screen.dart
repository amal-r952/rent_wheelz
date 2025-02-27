import 'package:flutter/material.dart';
import 'package:rent_wheelz/src/screens/location_picker_screen.dart';
import 'package:rent_wheelz/src/utils/app_colors.dart';
import 'package:rent_wheelz/src/utils/app_toast.dart';
import 'package:rent_wheelz/src/utils/utils.dart';
import 'package:rent_wheelz/src/widgets/build_custom_appbar_widget.dart';
import 'package:rent_wheelz/src/widgets/build_elevated_button.dart';
import 'package:rent_wheelz/src/widgets/build_single_day_picker.dart';
import 'package:rent_wheelz/src/widgets/build_textfield_widget.dart';

class CarRentalSearchScreen extends StatefulWidget {
  const CarRentalSearchScreen({super.key});

  @override
  State<CarRentalSearchScreen> createState() => _CarRentalSearchScreenState();
}

class _CarRentalSearchScreenState extends State<CarRentalSearchScreen> {
  TextEditingController pickupLocationController = TextEditingController();
  TextEditingController dropOffLocationController = TextEditingController();
  TextEditingController pickUpDateController = TextEditingController();
  TextEditingController dropOffDateController = TextEditingController();

  void _pickDate(BuildContext context, TextEditingController controller) async {
    DateTime? pickedDate = await showDialog<DateTime>(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(16.0), // Optional: rounded corners
        ),
        child: SizedBox(
          width:
              MediaQuery.of(context).size.width * 0.8, // Set width (optional)
          height: 400, // Adjust the height as needed
          child: BuildSingleDayPicker(),
        ),
      ),
    );

    if (pickedDate != null) {
      setState(() {
        controller.text = "${pickedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BuildCustomAppBarWidget(
        centerTitle: false,
        title: "Search for a car",
        showBackButton: false,
        preferredHeight: 70,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ' Pickup location',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
              ),
              const SizedBox(height: 10),
              BuildTextField(
                fillColor: Theme.of(context).cardColor,
                textColor: Theme.of(context).dividerColor,
                textEditingController: pickupLocationController,
                enable: true,
                hintText: 'City, State, Country',
                showBorder: true,
                showAlwaysErrorBorder: false,
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: BuildElevatedButton(
                  backgroundColor: AppColors.primaryColorOrange,
                  width: screenWidth(context, dividedBy: 2.5),
                  height: screenHeight(context, dividedBy: 20),
                  child: null,
                  txt: "Pick from map",
                  onTap: () async {
                    final result =
                        await push(context, const LocationPickerScreen());
                    if (result != null) {
                      setState(() {
                        pickupLocationController.text = result['pickedAddress'];
                      });
                    }
                  },
                ),
              ),
              const SizedBox(height: 20),
              Text(
                ' Drop-Off location',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
              ),
              const SizedBox(height: 10),
              BuildTextField(
                fillColor: Theme.of(context).cardColor,
                textColor: Theme.of(context).dividerColor,
                textEditingController: dropOffLocationController,
                enable: true,
                hintText: 'City, State, Country',
                showBorder: true,
                showAlwaysErrorBorder: false,
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: BuildElevatedButton(
                  backgroundColor: AppColors.primaryColorOrange,
                  width: screenWidth(context, dividedBy: 2.5),
                  height: screenHeight(context, dividedBy: 20),
                  child: null,
                  txt: "Pick from map",
                  onTap: () async {
                    final result =
                        await push(context, const LocationPickerScreen());
                    if (result != null) {
                      setState(() {
                        dropOffLocationController.text =
                            result['pickedAddress'];
                      });
                    }
                  },
                ),
              ),
              const SizedBox(height: 20),
              Text(
                ' Pickup Date',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () => _pickDate(context, pickUpDateController),
                child: Container(
                  width: screenWidth(context),
                  height: screenHeight(context, dividedBy: 16),
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      pickUpDateController.text.isEmpty
                          ? "Select pickup date"
                          : pickUpDateController.text,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 14,
                            color: pickUpDateController.text.isEmpty
                                ? AppColors.textFieldHintColor
                                : Theme.of(context).dividerColor,
                            fontWeight: FontWeight.w400,
                          ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                ' Drop-Off Date',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () => _pickDate(context, dropOffDateController),
                child: Container(
                  width: screenWidth(context),
                  height: screenHeight(context, dividedBy: 16),
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      dropOffDateController.text.isEmpty
                          ? "Select drop-off date"
                          : dropOffDateController.text,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 14,
                            color: dropOffDateController.text.isEmpty
                                ? AppColors.textFieldHintColor
                                : Theme.of(context).dividerColor,
                            fontWeight: FontWeight.w400,
                          ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: BuildElevatedButton(
          backgroundColor: AppColors.primaryColorOrange,
          width: screenWidth(
            context,
          ),
          height: screenHeight(context, dividedBy: 18),
          child: null,
          txt: "Search",
          onTap: () async {
            String pickupLocation = pickupLocationController.text
                .trim()
                .replaceAllMapped(RegExp(r'(\s+)|,\s*'),
                    (match) => match.group(1) != null ? '-' : ',');

            String dropOffLocation = dropOffLocationController.text
                .trim()
                .replaceAllMapped(RegExp(r'(\s+)|,\s*'),
                    (match) => match.group(1) != null ? '-' : ',');

            String pickUpDate = pickUpDateController.text.trim();
            String dropOffDate = dropOffDateController.text.trim();

            if (pickupLocation.isNotEmpty &&
                dropOffLocation.isNotEmpty &&
                pickUpDate.isNotEmpty &&
                dropOffDate.isNotEmpty) {
              String url =
                  "https://www.kayak.com/cars/$pickupLocation/$dropOffLocation/$pickUpDate/$dropOffDate";

              print(url);
              AppToasts.showSuccessToastTop(
                  context, "URL GENERATED SUCCESSFULLY");

              lauchUrl(url: url);
            } else {
              AppToasts.showErrorToastTop(
                  context, "Please fill all the fields!");
            }
          },
        ),
      ),
    );
  }
}
