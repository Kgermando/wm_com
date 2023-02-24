import 'dart:io';
import 'dart:typed_data';
import 'package:wm_commercial/src/api/auth/auth_api.dart';
import 'package:wm_commercial/src/helpers/monnaire_storage.dart';
import 'package:wm_commercial/src/models/commercial/achat_model.dart';
import 'package:wm_commercial/src/models/commercial/vente_cart_model.dart';
import 'package:wm_commercial/src/models/users/user_model.dart';
import 'package:wm_commercial/src/utils/info_system.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';

// Local import
import 'package:wm_commercial/src/helpers/save_file_mobile_pdf.dart'
    if (dart.library.html) 'src/helpers/save_file_web.dart' as helper;

class AchatPdf {
  static Future<void> generate(AchatModel data, UserModel user,
      List<VenteCartModel> venteCartList, MonnaieStorage monnaieStorage) async {
    final pdf = Document();

    final user = await AuthApi().getUserId();
    pdf.addPage(MultiPage(
      build: (context) => [
        buildHeader(data, user),
        SizedBox(height: 2 * PdfPageFormat.cm),
        buildTitle(data),
        Divider(),
        buildBody(data, user, venteCartList, monnaieStorage)
      ],
      footer: (context) => buildFooter(user),
    ));
    final dateTime = DateTime.now();
    final date = DateFormat("dd-MM-yy_HH-mm").format(dateTime);
    final Uint8List bytes = await pdf.save();
    return helper.saveAndLaunchFilePdf(bytes, 'stock-$date.pdf');
  }

  static Widget buildHeader(AchatModel data, UserModel user) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // SizedBox(height: 1 * PdfPageFormat.cm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildHeaderLogo(user),
              Container(
                height: 50,
                width: 50,
                child: BarcodeWidget(
                    barcode: Barcode.qrCode(), data: InfoSystem().name()),
              ),
            ],
          ),
          // SizedBox(height: 1 * PdfPageFormat.cm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildCompanyAddress(user),
              buildCompagnyInfo(data, user),
            ],
          ),
        ],
      );

  static Widget buildHeaderLogo(UserModel user) {
    final image = pw.MemoryImage(
      File(InfoSystem().logo()).readAsBytesSync(),
    );
    return Column(
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        pw.SizedBox(
          width: 80,
          height: 80,
          child: pw.Image(image),
        ),
        pw.Text(InfoSystem().namelong()),
        pw.Text(InfoSystem().name(),
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
      ],
    );
  }

  static Widget buildCompanyAddress(UserModel user) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 200,
            child: Text(InfoSystem().nameAdress(),
                style: const TextStyle(fontSize: 10)),
          )
        ],
      );

  static Widget buildCompagnyInfo(AchatModel data, UserModel user) {
    final titles = <String>['RCCM:', 'N° Impôt:', 'ID Nat.:', 'Crée le:'];
    final datas = <String>[
      InfoSystem().rccm(),
      InfoSystem().nImpot(),
      InfoSystem().iDNat(),
      DateFormat("dd/MM/yy HH:mm").format(data.created.toDateTime())
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(titles.length, (index) {
        final title = titles[index];
        final value = datas[index];

        return buildText(title: title, value: value, width: 200);
      }),
    );
  }

  static Widget buildTitle(AchatModel data) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data.idProduct.toUpperCase(),
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      );

  static Widget buildBody(AchatModel data, UserModel user,
      List<VenteCartModel> venteCartList, MonnaieStorage monnaieStorage) {
    return pw.Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      headerTitle(data),
      SizedBox(
        height: 20,
      ),
      achatTitle(),
      achats(data, user, monnaieStorage),
      SizedBox(
        height: 20,
      ),
      ventetitle(),
      ventes(data, venteCartList, monnaieStorage),
      SizedBox(
        height: 20,
      ),
      benficesTitle(),
      benfices(data, monnaieStorage),
      SizedBox(
        height: 30,
      ),
    ]);
  }

  static Widget headerTitle(AchatModel data) {
    return SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(data.idProduct,
              style: TextStyle(fontWeight: pw.FontWeight.bold)),
        ));
  }

  static Widget achatTitle() {
    return SizedBox(
        width: double.infinity,
        child: Text(
          'ACHATS',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
        ));
  }

  static Widget achats(
      AchatModel data, UserModel user, MonnaieStorage monnaieStorage) {
    var roleAgent = int.parse(user.role) <= 3;

    var prixAchatTotal =
        double.parse(data.priceAchatUnit) * double.parse(data.quantityAchat);
    var margeBenifice =
        double.parse(data.prixVenteUnit) - double.parse(data.priceAchatUnit);
    var margeBenificeTotal = margeBenifice * double.parse(data.quantityAchat);

    var margeBenificeRemise =
        double.parse(data.remise) - double.parse(data.priceAchatUnit);
    var margeBenificeTotalRemise =
        margeBenificeRemise * double.parse(data.quantityAchat);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Quantités entrant',
                  style: TextStyle(fontWeight: pw.FontWeight.bold)),
              Spacer(),
              Text(
                '${NumberFormat.decimalPattern('fr').format(double.parse(double.parse(data.qtyLivre).toStringAsFixed(2)))} ${data.unite}',
              ),
            ],
          ),
          if (roleAgent)
            Divider(
              color: PdfColors.amber,
            ),
          if (roleAgent)
            Row(
              children: [
                Text('Prix d\'achats unitaire',
                    style: TextStyle(fontWeight: pw.FontWeight.bold)),
                Spacer(),
                Text(
                  '${NumberFormat.decimalPattern('fr').format(double.parse(double.parse(data.priceAchatUnit).toStringAsFixed(2)))} ${monnaieStorage.monney}',
                ),
              ],
            ),
          if (roleAgent)
            Divider(
              color: PdfColors.amber,
            ),
          if (roleAgent)
            Row(
              children: [
                Text('Prix d\'achats total',
                    style: TextStyle(fontWeight: pw.FontWeight.bold)),
                Spacer(),
                Text(
                  '${NumberFormat.decimalPattern('fr').format(double.parse(prixAchatTotal.toStringAsFixed(2)))} ${monnaieStorage.monney}',
                ),
              ],
            ),
          Divider(
            color: PdfColors.amber,
          ),
          Row(
            children: [
              Text('TVA', style: TextStyle(fontWeight: pw.FontWeight.bold)),
              Spacer(),
              Text(
                '${data.tva} %',
              ),
            ],
          ),
          Divider(
            color: PdfColors.amber,
          ),
          Row(
            children: [
              Text('Prix de vente unitaire',
                  style: TextStyle(fontWeight: pw.FontWeight.bold)),
              Spacer(),
              Text(
                '${NumberFormat.decimalPattern('fr').format(double.parse(double.parse(data.prixVenteUnit).toStringAsFixed(2)))} ${monnaieStorage.monney}',
              ),
            ],
          ),
          Divider(
            color: PdfColors.amber,
          ),
          Row(
            children: [
              Text('Prix de Remise',
                  style: TextStyle(fontWeight: pw.FontWeight.bold)),
              Spacer(),
              Text(
                '${double.parse(data.remise).toStringAsFixed(2)} ${monnaieStorage.monney}',
              ),
            ],
          ),
          Divider(
            color: PdfColors.amber,
          ),
          Row(
            children: [
              Text('Qtés pour la remise',
                  style: TextStyle(fontWeight: pw.FontWeight.bold)),
              Spacer(),
              Text(
                '${data.qtyRemise} ${data.unite}',
              ),
            ],
          ),
          if (roleAgent)
            Divider(
              color: PdfColors.amber,
            ),
          if (roleAgent)
            SizedBox(
              height: 20.0,
            ),
          if (roleAgent)
            Row(
              children: [
                Text('Marge bénéficiaire unitaire / Remise',
                    style: TextStyle(fontWeight: pw.FontWeight.bold)),
                Spacer(),
                Text(
                  '${NumberFormat.decimalPattern('fr').format(double.parse(margeBenifice.toStringAsFixed(2)))} ${monnaieStorage.monney} / ${NumberFormat.decimalPattern('fr').format(double.parse(margeBenificeRemise.toStringAsFixed(2)))} ${monnaieStorage.monney}',
                ),
              ],
            ),
          if (roleAgent)
            Divider(
              color: PdfColors.amber,
            ),
          if (roleAgent)
            Row(
              children: [
                Text('Marge bénéficiaire total / Remise',
                    style: TextStyle(fontWeight: pw.FontWeight.bold)),
                Spacer(),
                Text(
                  '${NumberFormat.decimalPattern('fr').format(double.parse(margeBenificeTotal.toStringAsFixed(2)))} ${monnaieStorage.monney} / ${NumberFormat.decimalPattern('fr').format(double.parse(margeBenificeTotalRemise.toStringAsFixed(2)))} ${monnaieStorage.monney}',
                ),
              ],
            )
        ],
      ),
    );
  }

  static Widget ventetitle() {
    return SizedBox(
      width: double.infinity,
      child: Text(
        'VENTES',
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
      ),
    );
  }

  static Widget ventes(AchatModel data, List<VenteCartModel> venteCartList,
      MonnaieStorage monnaieStorage) {
    double qtyVendus = 0;
    double prixTotalVendu = 0;

    var ventesQty = venteCartList
        .where((element) {
          String v1 = element.idProductCart;
          String v2 = data.idProduct;
          int date1 = element.created.millisecondsSinceEpoch;
          int date2 = data.created.millisecondsSinceEpoch;
          return v1 == v2 && date2 >= date1;
        })
        .map((e) => double.parse(e.quantityCart))
        .toList();

    for (var item in ventesQty) {
      qtyVendus += item;
    }

    var ventesPrix = venteCartList
        .where((element) {
          var v1 = element.idProductCart;
          var v2 = data.idProduct;
          var date1 = element.created.millisecondsSinceEpoch;
          var date2 = data.created.millisecondsSinceEpoch;
          return v1 == v2 && date2 >= date1;
        })
        .map((e) => double.parse(e.priceTotalCart))
        .toList();

    for (var item in ventesPrix) {
      prixTotalVendu += item;
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Quantités vendus',
                  style: TextStyle(fontWeight: pw.FontWeight.bold)),
              Text('Montant vendus',
                  style: TextStyle(fontWeight: pw.FontWeight.bold)),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${NumberFormat.decimalPattern('fr').format(double.parse(qtyVendus.toStringAsFixed(0)))} ${data.unite}',
              ),
              Text(
                '${NumberFormat.decimalPattern('fr').format(double.parse(prixTotalVendu.toStringAsFixed(2)))} ${monnaieStorage.monney}',
              ),
            ],
          ),
        ],
      ),
    );
  }

  static Widget benficesTitle() {
    return SizedBox(
      width: double.infinity,
      child: Text(
        'EN STOCKS',
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
      ),
    );
  }

  static Widget benfices(AchatModel data, MonnaieStorage monnaieStorage) {
    var prixTotalRestante =
        double.parse(data.quantity) * double.parse(data.prixVenteUnit);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Restes des ${data.unite}',
                  style: TextStyle(fontWeight: pw.FontWeight.bold)),
              Text('Revenues',
                  style: TextStyle(fontWeight: pw.FontWeight.bold)),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${NumberFormat.decimalPattern('fr').format(double.parse(double.parse(data.quantity).toStringAsFixed(0)))} ${data.unite}',
              ),
              Text(
                '${NumberFormat.decimalPattern('fr').format(double.parse(prixTotalRestante.toStringAsFixed(2)))} ${monnaieStorage.monney}',
              ),
            ],
          ),
        ],
      ),
    );
  }

  static Widget buildFooter(UserModel user) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Divider(),
          SizedBox(height: 2 * PdfPageFormat.mm),
          // buildSimpleText(title: 'Address', value: invoice.supplier.address),
          // SizedBox(height: 1 * PdfPageFormat.mm),
          // buildSimpleText(title: 'Paypal', value: invoice.supplier.paymentInfo),
          pw.Text('Fonds Kasaiens de développement.',
              style: const pw.TextStyle(fontSize: 10))
        ],
      );

  static buildSimpleText({
    required String title,
    required String value,
  }) {
    final style = TextStyle(fontWeight: FontWeight.bold);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        Text(title, style: style),
        SizedBox(width: 2 * PdfPageFormat.mm),
        Text(value),
      ],
    );
  }

  static buildText({
    required String title,
    required String value,
    double width = double.infinity,
    TextStyle? titleStyle,
    bool unite = false,
  }) {
    final style = titleStyle ?? TextStyle(fontWeight: FontWeight.bold);

    return Container(
      width: width,
      child: Row(
        children: [
          Expanded(child: Text(title, style: style)),
          Text(value, style: unite ? style : null),
        ],
      ),
    );
  }
}
