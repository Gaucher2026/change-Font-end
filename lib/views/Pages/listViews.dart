import 'package:echange/views/Widgets/approvisionement/approvisionement.dart';
import 'package:echange/views/Widgets/compte/compte.dart';
import 'package:echange/views/Widgets/devise/devise.dart';
import 'package:echange/views/Widgets/historique/historiques.dart';
import 'package:echange/views/Widgets/operation/operation.dart';
import 'package:echange/views/Widgets/taux/taux.dart';
import 'package:echange/views/Widgets/versement/versement.dart';

List widgets = [
  Compte(),
  Approvisionement(),
  Versement(),
  Operation(),
  Historique(),
  Taux(),
  Devise(),
];