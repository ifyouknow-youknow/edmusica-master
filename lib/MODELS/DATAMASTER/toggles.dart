// toggles.dart
part of 'datamaster.dart';

mixin _DataMasterToggles {
  bool _toggleLoading = false;
  bool _toggleAlert = false;
  bool _togglePopup = false;

  bool get toggleLoading => _toggleLoading;
  bool get toggleAlert => _toggleAlert;
  bool get togglePopup => _togglePopup;

  void setToggleLoading(bool value) => _toggleLoading = value;
  void setToggleAlert(bool value) => _toggleAlert = value;
  void setTogglePopup(bool value) => _togglePopup = value;
}
