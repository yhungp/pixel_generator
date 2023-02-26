epochToTimeText(int value, {bool notMillis = false}) {
  int hours = 0;
  int minutes = 0;
  int seconds = 0;
  int millis = 0;
  int rest = 0;

  String txt = "";

  hours = value / 60 / 60 ~/ 1000;
  rest = (value - hours * 60 * 60 * 1000).toInt();
  minutes = rest / 60 ~/ 1000;

  rest = (rest - minutes * 60 * 1000).toInt();

  seconds = rest ~/ 1000;
  millis = (rest - seconds * 1000);

  String hoursLabel = "$hours";
  hoursLabel = hoursLabel.length == 1 ? "0$hours" : hoursLabel;

  String minutesLabel = "$minutes";
  minutesLabel = minutesLabel.length == 1 ? "0$minutesLabel" : minutesLabel;

  String secondsLabel = "$seconds";
  secondsLabel = secondsLabel.length == 1 ? "0$secondsLabel" : secondsLabel;

  String millisLabel = "$millis";
  millisLabel = "0" * (3 - millisLabel.length) + millisLabel;

  txt = "$hoursLabel:$minutesLabel:$secondsLabel.$millisLabel";

  return txt;
}
