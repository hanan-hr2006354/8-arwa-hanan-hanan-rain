import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  double screenWidth = 0;
  int columns = 1;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    screenWidth = MediaQuery.of(context).size.width;
    columns = switch (screenWidth) {
      < 840 => 1,
      >= 840 && < 1150 => 2,
      _ => 3,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFEFFF7),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height / 7.5,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/background.PNG'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'YalaPay Dashboard',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF915050),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Summary of invoices and cheques by status',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF915050).withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height / 7,
            left: 0,
            right: 0,
            child: Container(
              color: Color(0xFFFEFFF7),
              padding: EdgeInsets.all(20),
              child: GridView.count(
                crossAxisCount: columns,
                childAspectRatio: 2,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true, //
                children: [
                  _buildSummaryCard(
                    'Invoices',
                    [
                      _buildSummaryRow('All:', '99.99 QR',
                          const Color.fromARGB(255, 137, 204, 118)),
                      _buildSummaryRow('Due Date in 30 days:', '33.33 QR',
                          const Color.fromARGB(255, 134, 184, 224)),
                      _buildSummaryRow('Due Date in 60 days:', '66.66 QR',
                          const Color.fromARGB(255, 223, 128, 121)),
                    ],
                    Icons.receipt,
                  ),
                  _buildSummaryCard(
                    'Cheques',
                    [
                      _buildSummaryRow('Awaiting:', '99.99 QR',
                          const Color.fromARGB(255, 232, 192, 130)),
                      _buildSummaryRow('Deposited:', '22.22 QR',
                          const Color.fromARGB(255, 123, 185, 237)),
                      _buildSummaryRow('Cashed:', '44.44 QR',
                          const Color.fromARGB(255, 137, 204, 118)),
                      _buildSummaryRow('Returned:', '11.11 QR',
                          const Color.fromARGB(255, 223, 128, 121)),
                    ],
                    Icons.check,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, List<Widget> rows, IconData icon) {
    return Card(
      color: Color(0xFFF9F2EA),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF54514A),
                  ),
                ),
                SizedBox(height: 10),
                Column(children: rows),
              ],
            ),
            Positioned(
              top: 3,
              right: 3,
              child: Icon(
                icon,
                color: Color(0xFF54514A),
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, Color valueColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: Color.fromARGB(255, 105, 60, 60).withOpacity(0.8),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}
