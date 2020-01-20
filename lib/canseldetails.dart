class CanselDetails {
  int canselDetailsId;
  String canselDetail;
  String canselDetail2;

  CanselDetails({this.canselDetailsId, this.canselDetail, this.canselDetail2});

  static List<CanselDetails> getUsers() {
    return <CanselDetails>[
      CanselDetails(canselDetailsId: 1, canselDetail: "Mechanic Late", canselDetail2: "Machanic get late for you"),
      CanselDetails(canselDetailsId: 2, canselDetail: "Not Answer your call", canselDetail2: "Mechanic not answering your phone call some time"),
      CanselDetails(canselDetailsId: 3, canselDetail: "Fake Mechanic", canselDetail2: "If you are think this is a fake Mechanic"),
      CanselDetails(canselDetailsId: 4, canselDetail: "Mechanic so far", canselDetail2: "Mechanic is in long distance"),
      CanselDetails(canselDetailsId: 5, canselDetail: "Other", canselDetail2: "Your Mind is change"),
    ];
  }
}
