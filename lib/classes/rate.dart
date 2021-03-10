class Rate {
  String _review;
  double _teachingSkills;
  double _communicationSkills;
  double _creativity;
  double _friendliness;
  String _sessionTitle;

  String get sessionTitle => _sessionTitle;

  set sessionTitle(String value) {
    _sessionTitle = value;
  }

  DateTime _date;


  DateTime get date => _date;

  set date(DateTime value) {
    _date = value;
  }

  Rate(this._review, this._teachingSkills, this._friendliness,
      this._communicationSkills, this._creativity,this._date,this._sessionTitle);

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

  // ignore: missing_return
  static double getAverageRate(List<Rate> totalRates){

    double sum = 0;

    for(int i = 0 ; i < totalRates.length ; i++){
      sum += totalRates.elementAt(i).creativity+totalRates.elementAt(i).friendliness+totalRates.elementAt(i).communicationSkills+totalRates.elementAt(i).teachingSkills;
    }
    return sum/ (totalRates.length * 4);


  }
}
