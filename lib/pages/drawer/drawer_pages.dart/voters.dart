import 'package:flutter/material.dart';

class VoterData {
  final String area;
  final int totalVoters;
  final int maleVoters;
  final int femaleVoters;

  VoterData({
    required this.area,
    required this.totalVoters,
    required this.maleVoters,
    required this.femaleVoters,
  });
}

class VotersBasic extends StatefulWidget {
  const VotersBasic({super.key});

  @override
  State<VotersBasic> createState() => _VotersBasicState();
}

class _VotersBasicState extends State<VotersBasic> {
  final List<String> areas = [
    "Andheri",
    "Borivali",
    "Thane",
    "Dadar",
    "Nashik",
  ];

  final Map<String, VoterData> voterDataMap = {
    "Andheri": VoterData(
      area: "Andheri",
      totalVoters: 485000,
      maleVoters: 252000,
      femaleVoters: 233000,
    ),
    "Borivali": VoterData(
      area: "Borivali",
      totalVoters: 320000,
      maleVoters: 165000,
      femaleVoters: 155000,
    ),
    "Thane": VoterData(
      area: "Thane",
      totalVoters: 580000,
      maleVoters: 298000,
      femaleVoters: 282000,
    ),
    "Dadar": VoterData(
      area: "Dadar",
      totalVoters: 275000,
      maleVoters: 142000,
      femaleVoters: 133000,
    ),
    "Nashik": VoterData(
      area: "Nashik",
      totalVoters: 425000,
      maleVoters: 220000,
      femaleVoters: 205000,
    ),
  };

  String? selectedArea;

  @override
  Widget build(BuildContext context) {
    VoterData? selectedData = selectedArea != null
        ? voterDataMap[selectedArea]
        : null;

    return Scaffold(
      appBar: AppBar(title: const Text("Voter Statistics (Basic)")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dropdown
            DropdownButton<String>(
              value: selectedArea,
              hint: const Text("Select Area"),
              isExpanded: true,
              items: areas.map((area) {
                return DropdownMenuItem(value: area, child: Text(area));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedArea = value;
                });
              },
            ),
            const SizedBox(height: 20),

            // Show voter data if area is selected
            if (selectedData != null)
              Column(
                children: [
                  _buildStatBox(
                    "Total Voters",
                    selectedData.totalVoters,
                    Colors.purple,
                  ),
                  const SizedBox(height: 10),
                  _buildStatBox(
                    "Male Voters",
                    selectedData.maleVoters,
                    Colors.blue,
                  ),
                  const SizedBox(height: 10),
                  _buildStatBox(
                    "Female Voters",
                    selectedData.femaleVoters,
                    Colors.pink,
                  ),
                ],
              )
            else
              const Center(
                child: Text("Please select an area to view voter data"),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatBox(String title, int value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            value.toString(),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
