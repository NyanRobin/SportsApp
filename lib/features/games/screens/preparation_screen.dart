import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';

class PreparationScreen extends StatefulWidget {
  const PreparationScreen({super.key});

  @override
  State<PreparationScreen> createState() => _PreparationScreenState();
}

class _PreparationScreenState extends State<PreparationScreen> {
  // Sample upcoming game data
  final Map<String, dynamic> _upcomingGame = {
    'teamA': 'Daehan High',
    'teamB': 'Seoul High',
    'date': '2025-05-20',
    'day': '(Tue)',
    'time': '16:00',
    'location': 'Daehan High School Field',
    'daysLeft': 'D-2',
  };

  // Sample preparation categories
  final List<Map<String, dynamic>> _preparationCategories = [
    {
      'title': 'Diet Management',
      'description': 'Nutrition guide for optimal game performance',
      'icon': Icons.restaurant,
      'color': Colors.green,
      'image': 'assets/images/nutrition.jpg',
    },
    {
      'title': 'Equipment',
      'description': 'Equipment checklist and condition check',
      'icon': Icons.sports_soccer,
      'color': Colors.blue,
      'image': 'assets/images/equipment.jpg',
    },
    {
      'title': 'Warm-up/Cool-down',
      'description': 'Essential routines before and after the game',
      'icon': Icons.fitness_center,
      'color': Colors.purple,
      'image': 'assets/images/warmup.jpg',
    },
    {
      'title': 'Condition Management',
      'description': 'Condition management for optimal performance',
      'icon': Icons.monitor_heart,
      'color': Colors.red,
      'image': 'assets/images/condition.jpg',
    },
  ];

  // Sample schedule data
  final List<Map<String, dynamic>> _morningSchedule = [
    {
      'time': '07:00 - 08:00',
      'activities': [
        {'name': 'Breakfast 1st', 'description': '(Carbohydrates)'},
        {'name': 'Light Jogging', 'description': '(15 min)'},
        {'name': 'Visualization Training', 'description': '(Image Training)'},
        {'name': 'Nutritional Supplements', 'description': '(Coach check required)'},
      ],
    },
  ];

  final List<Map<String, dynamic>> _afternoonSchedule = [
    {
      'time': '12:00 - 13:00',
      'activities': [
        {'name': 'Lunch', 'description': '(Protein, Fiber)'},
        {'name': 'Game Strategy Review', 'description': '(With Coach)'},
        {'name': 'Team Meeting', 'description': '(Game, Tactics Check)'},
      ],
    },
  ];

  final List<Map<String, dynamic>> _eveningSchedule = [
    {
      'time': '18:00 - 19:00',
      'activities': [
        {'name': 'Dinner', 'description': '(Carbs, Omega-3)'},
        {'name': 'Stretching Routine', 'description': '(Lower Body Focus)'},
        {'name': 'Hydration', 'description': '(1.5L Target)'},
      ],
    },
  ];

  // Sample checklist data
  final List<Map<String, dynamic>> _checklistsByDay = [
    {
      'day': 'Monday (05-17)',
      'status': 'Completed',
      'items': [
        {'name': 'Uniform Washing', 'checked': true},
        {'name': 'Team Bibs Washing', 'checked': true},
        {'name': 'Equipment Check', 'checked': true},
      ],
    },
    {
      'day': 'Tuesday (05-18 ~ Today)',
      'status': 'In Progress',
      'items': [
        {'name': 'Personal Items Check', 'checked': true},
        {'name': 'Team Meeting Materials', 'checked': false},
      ],
    },
    {
      'day': 'Wednesday (05-19)',
      'status': 'Scheduled',
      'items': [
        {'name': 'Light Running', 'checked': false},
        {'name': 'Stretching Routine', 'checked': false},
        {'name': 'Tactical Meeting Attendance', 'checked': false},
      ],
    },
  ];

  // Sample performance metrics
  final List<Map<String, dynamic>> _performanceMetrics = [
    {'name': 'Sleep Time', 'value': 7.5, 'unit': 'hours', 'max': 10, 'color': Colors.blue},
    {'name': 'Fatigue Level', 'value': 3, 'unit': 'low', 'max': 10, 'color': Colors.yellow},
    {'name': 'Hydration', 'value': 1.8, 'unit': 'L/day', 'max': 3, 'color': Colors.green},
    {'name': 'Stress Level', 'value': 4, 'unit': 'medium', 'max': 10, 'color': Colors.red},
  ];

  // Sample coach comment
  final Map<String, dynamic> _coachComment = {
    'name': 'Coach Kim Jisoo',
    'position': 'Head Coach / Physical Training',
    'comment': 'The next game is expected to require a lot of physical endurance. Especially before this week\'s game, it\'s important to maintain adequate hydration and a carbohydrate-focused diet. On game day, it\'s necessary to arrive early and conduct sufficient warm-up.',
    'additionalComment': 'Make sure to check your personal equipment checklist, and note that equipment preparation may vary depending on weather conditions, so please check the coaching staff\'s guidance.',
  };

  // Checklist for equipment
  final List<Map<String, dynamic>> _equipmentChecklist = [
    {'name': 'Soccer Shoes (Check Studs)', 'checked': true},
    {'name': 'Uniform (Home)', 'checked': true},
    {'name': 'Socks', 'checked': true},
    {'name': 'Shin Guards', 'checked': false},
    {'name': 'Personal Water Bottle', 'checked': true},
    {'name': 'Sports Bag', 'checked': true},
    {'name': 'Towel', 'checked': true},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            context.go('/');
          },
        ),
        title: Text(
          'logo',
          style: TextStyle(
            color: AppTheme.primaryColor,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_outlined, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                'Game Preparations',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Systematic preparation guide for optimal performance',
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey,
                ),
              ),
            ),
            
            const SizedBox(height: 16.0),
            
            // Upcoming Game Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _buildUpcomingGameCard(),
            ),
            
            const SizedBox(height: 24.0),
            
            // Preparation Categories
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _buildPreparationCategories(),
            ),
            
            const SizedBox(height: 24.0),
            
            // Schedule
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _buildScheduleSection(),
            ),
            
            const SizedBox(height: 24.0),
            
            // Checklist
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _buildChecklistSection(),
            ),
            
            const SizedBox(height: 24.0),
            
            // Equipment Checklist
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _buildEquipmentChecklistSection(),
            ),
            
            const SizedBox(height: 24.0),
            
            // Performance Metrics
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _buildPerformanceMetricsSection(),
            ),
            
            const SizedBox(height: 24.0),
            
            // Coach Comment
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _buildCoachCommentSection(),
            ),
            
            const SizedBox(height: 32.0),
          ],
        ),
      ),
    );
  }
  
  Widget _buildUpcomingGameCard() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        children: [
          Container(
            width: 40.0,
            height: 40.0,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text(
                'D',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Upcoming Game',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  '${_upcomingGame['teamA']} vs ${_upcomingGame['teamB']}',
                  style: const TextStyle(
                    fontSize: 14.0,
                  ),
                ),
                const SizedBox(height: 2.0),
                Text(
                  '${_upcomingGame['date']} ${_upcomingGame['day']} ${_upcomingGame['time']}',
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 2.0),
                Text(
                  _upcomingGame['location'],
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Text(
              _upcomingGame['daysLeft'],
              style: TextStyle(
                color: Colors.blue.shade800,
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildPreparationCategories() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Preparation Categories',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16.0),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            childAspectRatio: 1.1,
          ),
          itemCount: _preparationCategories.length,
          itemBuilder: (context, index) {
            final category = _preparationCategories[index];
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10.0,
                    spreadRadius: 1.0,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12.0),
                      topRight: Radius.circular(12.0),
                    ),
                    child: Container(
                      height: 80.0,
                      width: double.infinity,
                      color: Colors.grey.shade200,
                      child: Center(
                        child: Icon(
                          category['icon'],
                          size: 40.0,
                          color: category['color'],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category['title'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          category['description'],
                          style: TextStyle(
                            fontSize: 12.0,
                            color: Colors.grey.shade600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
  
  Widget _buildScheduleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Today\'s Schedule',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                'View All',
                style: TextStyle(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16.0),
        _buildScheduleItem('Morning', _morningSchedule[0]),
        const SizedBox(height: 16.0),
        _buildScheduleItem('Afternoon', _afternoonSchedule[0]),
        const SizedBox(height: 16.0),
        _buildScheduleItem('Evening', _eveningSchedule[0]),
      ],
    );
  }
  
  Widget _buildScheduleItem(String title, Map<String, dynamic> schedule) {
    final activities = schedule['activities'] as List<Map<String, dynamic>>;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$title (${schedule['time']})',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14.0,
          ),
        ),
        const SizedBox(height: 8.0),
        ...activities.map((activity) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              children: [
                Container(
                  width: 8.0,
                  height: 8.0,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12.0),
                Text(
                  activity['name'],
                  style: const TextStyle(
                    fontSize: 14.0,
                  ),
                ),
                const SizedBox(width: 4.0),
                Text(
                  activity['description'],
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }
  
  Widget _buildChecklistSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'This Week\'s Preparation Plan',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16.0),
        ..._checklistsByDay.map((dayChecklist) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    dayChecklist['day'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      color: dayChecklist['status'] == 'Completed'
                          ? Colors.green.shade100
                          : dayChecklist['status'] == 'In Progress'
                              ? Colors.yellow.shade100
                              : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Text(
                      dayChecklist['status'],
                      style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500,
                        color: dayChecklist['status'] == 'Completed'
                            ? Colors.green.shade800
                            : dayChecklist['status'] == 'In Progress'
                                ? Colors.orange.shade800
                                : Colors.grey.shade800,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              ...((dayChecklist['items'] as List<Map<String, dynamic>>).map((item) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 24.0,
                        height: 24.0,
                        child: Checkbox(
                          value: item['checked'],
                          onChanged: (value) {
                            setState(() {
                              item['checked'] = value;
                            });
                          },
                          activeColor: AppTheme.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12.0),
                      Text(
                        item['name'],
                        style: TextStyle(
                          fontSize: 14.0,
                          decoration: item['checked'] ? TextDecoration.lineThrough : null,
                          color: item['checked'] ? Colors.grey : Colors.black,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList()),
              const SizedBox(height: 16.0),
            ],
          );
        }).toList(),
      ],
    );
  }
  
  Widget _buildEquipmentChecklistSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Equipment Checklist',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                'View All',
                style: TextStyle(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16.0),
        Wrap(
          spacing: 12.0,
          runSpacing: 12.0,
          children: _equipmentChecklist.map((item) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              decoration: BoxDecoration(
                color: item['checked'] ? AppTheme.primaryColor.withOpacity(0.1) : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(
                  color: item['checked'] ? AppTheme.primaryColor : Colors.grey.shade300,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 20.0,
                    height: 20.0,
                    child: Checkbox(
                      value: item['checked'],
                      onChanged: (value) {
                        setState(() {
                          item['checked'] = value;
                        });
                      },
                      activeColor: AppTheme.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Text(
                    item['name'],
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: item['checked'] ? FontWeight.bold : FontWeight.normal,
                      color: item['checked'] ? AppTheme.primaryColor : Colors.black,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
  
  Widget _buildPerformanceMetricsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Condition Check Points',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16.0),
        ..._performanceMetrics.map((metric) {
          final double percentage = (metric['value'] / metric['max']) * 100;
          
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      metric['name'],
                      style: const TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '${metric['value']} ${metric['unit']}',
                      style: const TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4.0),
                  child: LinearProgressIndicator(
                    value: percentage / 100,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(metric['color']),
                    minHeight: 8.0,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }
  
  Widget _buildCoachCommentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Coach Advice',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16.0),
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40.0,
                    height: 40.0,
                    decoration: const BoxDecoration(
                      color: Colors.grey,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _coachComment['name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      Text(
                        _coachComment['position'],
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Text(
                _coachComment['comment'],
                style: const TextStyle(
                  fontSize: 14.0,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 12.0),
              Text(
                _coachComment['additionalComment'],
                style: const TextStyle(
                  fontSize: 14.0,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
