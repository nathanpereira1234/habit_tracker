Future<void> _loadWeeklyData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Get the selected habits from the map
    String? selectedHabitsMapString = prefs.getString('selectedHabitsMap');
    if (selectedHabitsMapString != null) {
      Map<String, dynamic> selectedHabitsMap =
          jsonDecode(selectedHabitsMapString);
      selectedHabits = selectedHabitsMap.keys.toList();
    } else {
      selectedHabits = [];
    }

    // If no habits are selected, reset weeklyData
    if (selectedHabits.isEmpty) {
      setState(() {
        weeklyData = {};
      });
      return;
    }

    // Load the data from shared preferences or generate random mixed data if none exists
    String? storedData = prefs.getString('weeklyData');
    if (storedData == null) {
      Map<String, List<int>> mixedData = {
        for (var habit in selectedHabits)
          habit: List.generate(
              7,
              (_) =>
                  Random().nextBool() ? 1 : 0), // Generate a mix of 0s and 1s
      };
      await prefs.setString('weeklyData', jsonEncode(mixedData));
      storedData = jsonEncode(mixedData);
    }

    // Decode and set weekly data
    setState(() {
      Map<String, dynamic> decodedData = jsonDecode(storedData!);
      weeklyData = decodedData.map((key, value) => MapEntry(
            key,
            List<int>.from(value),
          ));
    });
  }