import 'package:get/get.dart';
import 'package:wm_commercial/src/constants/app_theme.dart';
import 'package:wm_commercial/src/helpers/monnaire_storage.dart';
import 'package:wm_commercial/src/models/commercial/ardoise_model.dart';
import 'package:wm_commercial/src/models/commercial/cart_model.dart';
import 'package:davi/davi.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wm_commercial/src/pages/commercial/controller/ardoise/ardoise_controller.dart';
import 'package:wm_commercial/src/pages/commercial/controller/cart/cart_controller.dart';
import 'package:wm_commercial/src/widgets/loading.dart';

class TableArdoiseCart extends StatefulWidget {
  const TableArdoiseCart(
      {Key? key, required this.cartList, required this.ardoiseModel})
      : super(key: key);
  final List<dynamic> cartList;
  final ArdoiseModel ardoiseModel;

  @override
  State<TableArdoiseCart> createState() => _TableArdoiseCartState();
}

class _TableArdoiseCartState extends State<TableArdoiseCart> {
  final MonnaieStorage monnaieStorage = Get.put(MonnaieStorage());
  final ArdoiseController controller = Get.put(ArdoiseController());
  final CartController cartController = Get.find();
  DaviModel<CartModel>? _model;
  List<CartModel> cartItemList = [];

  @override
  void initState() {
    super.initState();

    for (var element in widget.cartList) {
      cartItemList.add(CartModel.fromJson(element));
    }

    List<CartModel> rows =
        List.generate(cartItemList.length, (index) => cartItemList[index]);
    _model = DaviModel<CartModel>(
        rows: rows,
        columns: [
          DaviColumn(
              name: 'Quantité',
              headerAlignment: Alignment.center,
              cellAlignment: Alignment.center,
              width: 200,
              stringValue: (row) =>
                  "${NumberFormat.decimalPattern('fr').format(double.parse(row.quantityCart))} ${row.unite}"),
          DaviColumn(
              name: 'Designation',
              width: 300,
              stringValue: (row) => row.idProductCart),
          DaviColumn(
              name: 'Prix de Vente ou Remise',
              headerAlignment: Alignment.center,
              cellAlignment: Alignment.center,
              width: 200,
              stringValue: (row) {
                return (double.parse(row.quantityCart) >=
                        double.parse(row.qtyRemise))
                    ? "${NumberFormat.decimalPattern('fr').format(double.parse(row.remise))} ${monnaieStorage.monney}"
                    : "${NumberFormat.decimalPattern('fr').format(double.parse(row.priceCart))} ${monnaieStorage.monney}";
              }),
          DaviColumn(
              name: 'Total',
              width: 200,
              headerAlignment: Alignment.center,
              cellAlignment: Alignment.center,
              cellTextStyle: TextStyle(color: Colors.green[700]!),
              cellBackground: (data) => Colors.green[50],
              stringValue: (row) {
                double total = 0;
                var qtyRemise = double.parse(row.qtyRemise);
                var quantity = double.parse(row.quantityCart);
                if (quantity >= qtyRemise) {
                  total +=
                      double.parse(row.remise) * double.parse(row.quantityCart);
                } else {
                  total += double.parse(row.priceCart) *
                      double.parse(row.quantityCart);
                }
                return "${NumberFormat.decimalPattern('fr').format(total)} ${monnaieStorage.monney}";
              }),
          DaviColumn(
              name: 'TVA',
              headerAlignment: Alignment.center,
              cellAlignment: Alignment.center,
              stringValue: (row) => "${row.tva} %"),
          DaviColumn(
            name: 'Retirer',
            headerAlignment: Alignment.center,
            cellAlignment: Alignment.center,
            iconValue: (data) {
              return CellIcon(icon: Icons.close, color: Colors.red);
            },
          ),
        ],
        multiSortEnabled: true);
  }

  Future<ArdoiseModel> refresh() async {
    final ArdoiseModel dataItem =
        await controller.detailView(widget.ardoiseModel.id!);
    return dataItem;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(p10),
        child: SizedBox(
          height: 500,
          child: Davi<CartModel>(
            _model,
            columnWidthBehavior: ColumnWidthBehavior.scrollable,
            onRowDoubleTap: (data) {
              showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: Text('Ëtre-vous sûr de retirer cet element ?',
                      style: TextStyle(color: Colors.red.shade700)),
                  content: SizedBox(
                    height: 100,
                    width: 100,
                    child: Obx(() => controller.isLoading
                        ? loading()
                        : const Text(
                            'Cette action permet de supprimer ce produit de la liste.')),
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'Cancel'),
                      child: Text('Annuler',
                          style: TextStyle(color: Colors.red.shade700)),
                    ),
                    TextButton(
                      onPressed: () {
                        cartItemList.removeWhere(
                            (element) => element.created == data.created);
                        controller.tableUpdateData(
                            widget.ardoiseModel, cartItemList);
                        controller.insertDataCart(data);
                        // Navigator.pop(context, 'ok');
                      },
                      child: Text('OK',
                          style: TextStyle(color: Colors.red.shade700)),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
