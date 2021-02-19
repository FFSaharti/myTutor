class Rate {
  String _review;
  double _teachingSkills;
  double _communicationSkills;
  double _creativity;
  double _friendliness;

  Rate(this._review, this._teachingSkills, this._friendliness,
      this._communicationSkills, this._creativity);

  String get review => _review;

  set review(String value) {
    _review = value;
  }

  double get teachingSkills => _teachingSkills;

  set teachingSkills(double value) {
    _teachingSkills = value;
  }

  double get communicationSkills => _communicationSkills;

  set communicationSkills(double value) {
    _communicationSkills = value;
  }

  double get creativity => _creativity;

  set creativity(double value) {
    _creativity = value;
  }

  double get friendliness => _friendliness;

  set friendliness(double value) {
    _friendliness = value;
  }
}
