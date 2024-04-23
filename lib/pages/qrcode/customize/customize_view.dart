import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:qrlingz_app/constants/color_const.dart';
import 'package:qrlingz_app/extensions/number_exten.dart';
import 'package:qrlingz_app/extensions/string_exten.dart';
import 'package:qrlingz_app/pages/qrcode/customize/customize_viewmodel.dart';
import 'package:qrlingz_app/widgets/styled_button.dart';

class CustomizeView extends StatefulWidget {
  final String data;
  const CustomizeView({super.key, required this.data});

  @override
  State<CustomizeView> createState() => _CustomizeViewState();
}

class _CustomizeViewState extends State<CustomizeView> {
  late CustomizeViewModel _viewModel;

  @override
  void initState() {
    _viewModel = CustomizeViewModel();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Customize QR"),
        centerTitle: false,
        actions: [
          SizedBox(
            width: 90, height: 36,
            child: StyledButton(
              onClick: (){}, text: "SAVE"),
          ),
          16.w()
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: Container(
              padding: const EdgeInsets.all(32),
              alignment: Alignment.center,
              color: Colors.grey,
              child: Container(
                height: 200,
                color: Colors.white,
                padding: const EdgeInsets.all(16),
                child: PrettyQrView.data(
                  data: widget.data
                ),
              ),
            )),
          Expanded(
            flex: 6,
            child: GridView.builder(
              itemCount: _viewModel.options.length,
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 16,
                crossAxisSpacing: 8,
                childAspectRatio: 1
              ),
              itemBuilder: (_, idx){
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: ColorConst.primary,
                        borderRadius: BorderRadius.circular(6)
                      ),
                      child: Icon(_viewModel.options[idx]["icon"] as IconData, color: Colors.white),
                    ),
                    16.h(),
                    "${_viewModel.options[idx]["name"]}".ts(context)
                  ],
                );
              },
            ),
          )
        ],
      ),
    );
  }
}