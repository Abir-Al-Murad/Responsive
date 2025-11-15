import 'package:flutter/material.dart';

void main() => runApp(ResponsiveApp());

class ResponsiveApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Responsive Design',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Responsive Examples')),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _buildCard(context, 'Before & After', BeforeAfterPage()),
          _buildCard(context, 'Overflow Fixes', OverflowFixesPage()),
          _buildCard(context, 'Responsive Layout', ResponsiveLayoutPage()),
          _buildCard(context, 'Adaptive UI', AdaptiveUIPage()),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, String title, Widget page) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(title),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        ),
      ),
    );
  }
}

// ==================== RESPONSIVE HELPER CLASS ====================

class Responsive {
  // Check if mobile
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;

  // Check if tablet
  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600 &&
      MediaQuery.of(context).size.width < 900;

  // Check if desktop
  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 900;

  // Get screen width
  static double width(BuildContext context) =>
      MediaQuery.of(context).size.width;

  // Get screen height
  static double height(BuildContext context) =>
      MediaQuery.of(context).size.height;

  // Get responsive value
  static T value<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    if (isDesktop(context) && desktop != null) return desktop;
    if (isTablet(context) && tablet != null) return tablet;
    return mobile;
  }
}

// ==================== 1. BEFORE & AFTER ====================

class BeforeAfterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Before & After'),
          bottom: TabBar(
            tabs: [
              Tab(text: '❌ Before (Wrong)'),
              Tab(text: '✅ After (Fixed)'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildBefore(),
            _buildAfter(context),
          ],
        ),
      ),
    );
  }

  // ❌ WRONG - Causes overflow
  Widget _buildBefore() {
    return Column(
      children: [
        // Fixed size container - too big for small screens
        Container(
          width: 500,
          height: 300,
          color: Colors.blue,
          child: Center(
            child: Text(
              'Fixed 500x300',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ),
        
        SizedBox(height: 16),
        
        // Row without Expanded - will overflow
        Row(
          children: [
            Container(width: 200, height: 100, color: Colors.red),
            Container(width: 200, height: 100, color: Colors.green),
            Container(width: 200, height: 100, color: Colors.orange),
          ],
        ),
        
        SizedBox(height: 16),
        
        // Long text without handling
        Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'This is a very long text that will definitely overflow on small screens because it has no maxLines or overflow handling',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }

  // ✅ CORRECT - Responsive
  Widget _buildAfter(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Responsive container
          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.3,
            color: Colors.blue,
            child: Center(
              child: Text(
                '90% x 30%',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
          
          SizedBox(height: 16),
          
          // Row with Expanded
          Row(
            children: [
              Expanded(child: Container(height: 100, color: Colors.red)),
              Expanded(child: Container(height: 100, color: Colors.green)),
              Expanded(child: Container(height: 100, color: Colors.orange)),
            ],
          ),
          
          SizedBox(height: 16),
          
          // Text with overflow handling
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'This is a very long text that will definitely overflow on small screens because it has no maxLines or overflow handling',
              style: TextStyle(fontSize: 16),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== 2. OVERFLOW FIXES ====================

class OverflowFixesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Overflow Fixes')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Fix 1: Expanded in Row
            _buildSection('1. Row Overflow Fix'),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 80,
                    color: Colors.blue,
                    child: Center(child: Text('Flex 1')),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: Container(
                    height: 80,
                    color: Colors.green,
                    child: Center(child: Text('Flex 2')),
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 24),
            
            // Fix 2: Text overflow
            _buildSection('2. Text Overflow Fix'),
            Container(
              padding: EdgeInsets.all(16),
              color: Colors.grey[200],
              child: Text(
                'This is a very long text that would normally overflow but now it has maxLines and ellipsis handling',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 16),
              ),
            ),
            
            SizedBox(height: 24),
            
            // Fix 3: Wrap instead of Row
            _buildSection('3. Wrap (Auto-wrap overflow)'),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(
                10,
                (index) => Chip(label: Text('Tag ${index + 1}')),
              ),
            ),
            
            SizedBox(height: 24),
            
            // Fix 4: ListView with Expanded
            _buildSection('4. ListView in Column'),
            Container(
              height: 200,
              child: Column(
                children: [
                  Text('Header'),
                  SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                      itemCount: 20,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text('Item $index'),
                          tileColor: index % 2 == 0 
                              ? Colors.blue[50] 
                              : Colors.white,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 24),
            
            // Fix 5: Constrained Box
            _buildSection('5. Max Width Constraint'),
            Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 400),
                child: Container(
                  padding: EdgeInsets.all(16),
                  color: Colors.purple[100],
                  child: Text(
                    'This container will never exceed 400px width, '
                    'even on large screens',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

// ==================== 3. RESPONSIVE LAYOUT ====================

class ResponsiveLayoutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Responsive Layout'),
        actions: [
          Padding(
            padding: EdgeInsets.all(8),
            child: Chip(
              label: Text(
                Responsive.isMobile(context)
                    ? 'Mobile'
                    : Responsive.isTablet(context)
                        ? 'Tablet'
                        : 'Desktop',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.green,
            ),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Desktop: 3 columns
          if (constraints.maxWidth > 900) {
            return Row(
              children: [
                Expanded(child: _buildCard('Column 1', Colors.red)),
                SizedBox(width: 16),
                Expanded(child: _buildCard('Column 2', Colors.green)),
                SizedBox(width: 16),
                Expanded(child: _buildCard('Column 3', Colors.blue)),
              ],
            );
          }
          
          // Tablet: 2 columns
          else if (constraints.maxWidth > 600) {
            return Row(
              children: [
                Expanded(child: _buildCard('Column 1', Colors.red)),
                SizedBox(width: 16),
                Expanded(child: _buildCard('Column 2', Colors.green)),
              ],
            );
          }
          
          // Mobile: 1 column
          else {
            return SingleChildScrollView(
              child: Column(
                children: [
                  _buildCard('Column 1', Colors.red),
                  SizedBox(height: 16),
                  _buildCard('Column 2', Colors.green),
                  SizedBox(height: 16),
                  _buildCard('Column 3', Colors.blue),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildCard(String title, Color color) {
    return Container(
      height: 200,
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 2),
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ),
    );
  }
}

// ==================== 4. ADAPTIVE UI ====================

class AdaptiveUIPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Adaptive UI')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Adaptive Font Size
            Text(
              'Adaptive Font Size',
              style: TextStyle(
                fontSize: Responsive.value(
                  context,
                  mobile: 20,
                  tablet: 24,
                  desktop: 28,
                ),
                fontWeight: FontWeight.bold,
              ),
            ),
            
            SizedBox(height: 16),
            
            // Adaptive Padding
            Container(
              padding: EdgeInsets.all(
                Responsive.value(
                  context,
                  mobile: 12.0,
                  tablet: 16.0,
                  desktop: 24.0,
                ),
              ),
              color: Colors.blue[100],
              child: Text('Padding adapts to screen size'),
            ),
            
            SizedBox(height: 16),
            
            // Adaptive Grid
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: Responsive.value(
                  context,
                  mobile: 2,
                  tablet: 3,
                  desktop: 4,
                ),
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: 8,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.primaries[index % Colors.primaries.length],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
            
            SizedBox(height: 16),
            
            // Show screen info
            _buildInfoCard(context),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Screen Info',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12),
            _buildInfoRow('Width', '${Responsive.width(context).toInt()}px'),
            _buildInfoRow('Height', '${Responsive.height(context).toInt()}px'),
            _buildInfoRow(
              'Device Type',
              Responsive.isMobile(context)
                  ? 'Mobile'
                  : Responsive.isTablet(context)
                      ? 'Tablet'
                      : 'Desktop',
            ),
            _buildInfoRow(
              'Orientation',
              MediaQuery.of(context).orientation == Orientation.portrait
                  ? 'Portrait'
                  : 'Landscape',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.w500)),
          Text(value, style: TextStyle(color: Colors.blue)),
        ],
      ),
    );
  }
}

// ==================== YOUR EDULINK APP EXAMPLE ====================

class EduLinkResponsiveExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('EduLink - Responsive')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Header Container - Responsive
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(
                Responsive.isMobile(context) ? 16 : 24,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.purple],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: Responsive.isMobile(context) ? 40 : 60,
                    child: Icon(Icons.school, size: 40),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'My Classes',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: Responsive.isMobile(context) ? 20 : 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 24),
            
            // Tasks Grid - Responsive columns
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: Responsive.isMobile(context) ? 1 : 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 3,
              ),
              itemCount: 4,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: Icon(Icons.task_alt),
                    title: Text('Task ${index + 1}'),
                    subtitle: Text('Due: 2 days'),
                    trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== COMMON PATTERN: RESPONSIVE CARD ====================

class ResponsiveCard extends StatelessWidget {
  final Widget child;

  ResponsiveCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: Responsive.isMobile(context) ? double.infinity : 600,
        ),
        child: Card(
          margin: EdgeInsets.all(16),
          child: Padding(
            padding: EdgeInsets.all(
              Responsive.isMobile(context) ? 16 : 24,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}