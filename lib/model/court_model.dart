class Court {
  final String courtName;
  final String state;
  

  Court({
    required this.courtName,
    required this.state,
  
  });

  factory Court.fromCsv(List<String> csvRow) {
    return Court(
      courtName: csvRow[0].trim(),
      state: csvRow[1].trim(),
     
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'courtName': courtName,
      'state': state,
      
    };
  }

  factory Court.fromJson(Map<String, dynamic> json) {
    return Court(
      courtName: json['courtName'] ?? '',
      state: json['state'] ?? '',
      
    );
  }

  
 

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Court &&
        other.courtName == courtName &&
        other.state == state;
       
  }

  
} 