import 'package:flutter/material.dart';

void main() {
  runApp(const StudioApp());
}

const _ink = Color(0xFF20221F);
const _muted = Color(0xFF85877F);
const _canvas = Color(0xFFF7F7F2);
const _line = Color(0xFFE9E9E2);
const _green = Color(0xFFB7E36A);
const _purple = Color(0xFFE9E4FF);
const _peach = Color(0xFFFFE5D8);
const _blue = Color(0xFFDCEEFF);

class StudioApp extends StatelessWidget {
  const StudioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Forma Studio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: _canvas,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF597D39),
          surface: _canvas,
        ),
        fontFamily: 'Arial',
      ),
      home: const WorkspaceShell(),
    );
  }
}

class StudioTask {
  StudioTask({
    required this.title,
    required this.project,
    required this.due,
    required this.color,
    this.done = false,
  });

  final String title;
  final String project;
  final String due;
  final Color color;
  bool done;
}

class WorkspaceShell extends StatefulWidget {
  const WorkspaceShell({super.key});

  @override
  State<WorkspaceShell> createState() => _WorkspaceShellState();
}

class _WorkspaceShellState extends State<WorkspaceShell> {
  String _page = 'Overview';
  String _filter = 'All tasks';
  String _query = '';
  final List<StudioTask> _tasks = [
    StudioTask(
      title: 'Finalize homepage wireframes',
      project: 'Website redesign',
      due: 'Today',
      color: _purple,
    ),
    StudioTask(
      title: 'Review first-round concepts',
      project: 'Brand refresh',
      due: 'Today',
      color: _peach,
    ),
    StudioTask(
      title: 'Prepare moodboard presentation',
      project: 'Summer campaign',
      due: 'Tomorrow',
      color: _blue,
    ),
    StudioTask(
      title: 'Collect feedback from the team',
      project: 'Website redesign',
      due: 'Fri, Nov 13',
      color: const Color(0xFFE4F1D5),
    ),
  ];

  List<StudioTask> get _visibleTasks {
    return _tasks.where((task) {
      final matchesFilter = _filter == 'All tasks' ||
          (_filter == 'Today' && task.due == 'Today') ||
          (_filter == 'Upcoming' && task.due != 'Today');
      final value = _query.trim().toLowerCase();
      final matchesSearch = value.isEmpty ||
          task.title.toLowerCase().contains(value) ||
          task.project.toLowerCase().contains(value);
      return matchesFilter && matchesSearch;
    }).toList();
  }

  void _selectPage(String page) {
    setState(() => _page = page);
  }

  Future<void> _addTask() async {
    final taskDetails = await showDialog<(String, String)>(
      context: context,
      builder: (context) => const _CreateTaskDialog(),
    );
    if (taskDetails != null && mounted) {
      setState(() {
        _tasks.insert(
          0,
          StudioTask(
            title: taskDetails.$1,
            project: taskDetails.$2,
            due: 'Today',
            color: _green,
          ),
        );
        _page = 'My tasks';
        _filter = 'All tasks';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 900;
        return Scaffold(
          drawer: isWide
              ? null
              : Drawer(
                  backgroundColor: Colors.white,
                  child: SafeArea(child: _buildSidebar()),
                ),
          body: Row(
            children: [
              if (isWide) _buildSidebar(),
              Expanded(
                child: Column(
                  children: [
                    _buildTopBar(isWide),
                    Expanded(child: _buildPage()),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 248,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: _line)),
      ),
      padding: const EdgeInsets.fromLTRB(22, 26, 18, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: _ink,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: const Icon(Icons.blur_on_rounded,
                    color: _green, size: 23),
              ),
              const SizedBox(width: 10),
              const Text(
                'forma',
                style: TextStyle(
                  color: _ink,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 36),
          const Padding(
            padding: EdgeInsets.only(left: 12, bottom: 10),
            child: Text(
              'WORKSPACE',
              style: TextStyle(
                color: _muted,
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
          ),
          _navItem('Overview', Icons.grid_view_rounded),
          _navItem('My tasks', Icons.check_circle_outline_rounded, badge: '4'),
          _navItem('Projects', Icons.folder_open_outlined),
          const SizedBox(height: 30),
          const Padding(
            padding: EdgeInsets.only(left: 12, bottom: 10),
            child: Text(
              'YOUR PROJECTS',
              style: TextStyle(
                color: _muted,
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
          ),
          _projectLink('Website redesign', const Color(0xFFB7A8F5)),
          _projectLink('Brand refresh', const Color(0xFFF4A77F)),
          _projectLink('Summer campaign', const Color(0xFF77B9E8)),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F5EC),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.auto_awesome_rounded, size: 16, color: _ink),
                    SizedBox(width: 7),
                    Expanded(
                      child: Text(
                        'A little reminder',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Great work takes time. Take a breath between the big ideas.',
                  style: TextStyle(
                    color: _muted,
                    fontSize: 11,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          const Divider(color: _line),
          const SizedBox(height: 10),
          Row(
            children: [
              CircleAvatar(
                radius: 17,
                backgroundColor: const Color(0xFFDCE8D0),
                child: const Text(
                  'JD',
                  style: TextStyle(
                    color: _ink,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Jamie Davis',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w700)),
                    SizedBox(height: 2),
                    Text('Free plan',
                        style: TextStyle(color: _muted, fontSize: 10)),
                  ],
                ),
              ),
              const Icon(Icons.more_horiz, color: _muted, size: 20),
            ],
          ),
        ],
      ),
    );
  }

  Widget _navItem(String label, IconData icon, {String? badge}) {
    final selected = _page == label;
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => _selectPage(label),
        child: Container(
          height: 42,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFF1F3EA) : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Icon(icon, size: 18, color: selected ? _ink : _muted),
              const SizedBox(width: 11),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: selected ? _ink : const Color(0xFF666960),
                    fontSize: 13,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
              if (badge != null)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    color: selected ? _green : const Color(0xFFF0F0EB),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Text(
                    badge,
                    style: const TextStyle(
                        fontSize: 10, fontWeight: FontWeight.w700),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _projectLink(String name, Color color) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, bottom: 15),
      child: InkWell(
        onTap: () => _selectPage('Projects'),
        child: Row(
          children: [
            Container(
              width: 9,
              height: 9,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: _muted, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(bool isWide) {
    return Container(
      height: 76,
      padding: EdgeInsets.symmetric(horizontal: isWide ? 38 : 20),
      decoration: const BoxDecoration(
        color: _canvas,
        border: Border(bottom: BorderSide(color: _line)),
      ),
      child: Row(
        children: [
          if (!isWide)
            Builder(
              builder: (context) => IconButton(
                onPressed: () => Scaffold.of(context).openDrawer(),
                icon: const Icon(Icons.menu_rounded),
                tooltip: 'Open navigation',
              ),
            ),
          if (!isWide) const SizedBox(width: 4),
          Expanded(
            child: Text(
              'Workspace  /  $_page',
              style: const TextStyle(color: _muted, fontSize: 12),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(
            width: isWide ? 230 : 160,
            height: 38,
            child: TextField(
              onChanged: (value) => setState(() => _query = value),
              style: const TextStyle(fontSize: 12),
              decoration: InputDecoration(
                hintText: 'Search tasks...',
                hintStyle: const TextStyle(color: _muted, fontSize: 12),
                prefixIcon: const Icon(Icons.search_rounded, size: 18),
                prefixIconColor: _muted,
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.zero,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: _line),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: _line),
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          IconButton(
            onPressed: () {},
            tooltip: 'Notifications',
            icon: Badge(
              smallSize: 7,
              backgroundColor: const Color(0xFFEB8B67),
              child: const Icon(
                Icons.notifications_none_rounded,
                color: Color(0xFF62645E),
                size: 21,
              ),
            ),
          ),
          const SizedBox(width: 5),
          const CircleAvatar(
            radius: 16,
            backgroundColor: Color(0xFFDCE8D0),
            child: Text('JD',
                style: TextStyle(
                    color: _ink, fontSize: 10, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  Widget _buildPage() {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        MediaQuery.sizeOf(context).width < 700 ? 20 : 38,
        30,
        MediaQuery.sizeOf(context).width < 700 ? 20 : 38,
        40,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1400),
          child: _page == 'Projects'
              ? _buildProjectsPage()
              : _page == 'My tasks'
                  ? _buildTasksPage()
                  : _buildOverviewPage(),
        ),
      ),
    );
  }

  Widget _buildOverviewPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _pageHeading(
          eyebrow: 'TUESDAY, NOVEMBER 10, 2026',
          title: 'Good morning, Jamie ☀',
          subtitle: 'A fresh day for fresh ideas. Here’s your studio at a glance.',
          action: _primaryButton('＋  New task', _addTask),
        ),
        const SizedBox(height: 26),
        LayoutBuilder(
          builder: (context, constraints) {
            final gap = 14.0;
            final columns = constraints.maxWidth > 900
                ? 4
                : constraints.maxWidth > 560
                    ? 2
                    : 1;
            final cardWidth =
                (constraints.maxWidth - gap * (columns - 1)) / columns;
            return Wrap(
              spacing: gap,
              runSpacing: gap,
              children: [
                _statCard(
                  width: cardWidth,
                  label: 'Active projects',
                  value: '06',
                  detail: '2 due this week',
                  icon: Icons.folder_open_rounded,
                  color: _purple,
                ),
                _statCard(
                  width: cardWidth,
                  label: 'Tasks completed',
                  value: '18',
                  detail: '+4 from last week',
                  icon: Icons.check_circle_outline_rounded,
                  color: const Color(0xFFE5F2D5),
                ),
                _statCard(
                  width: cardWidth,
                  label: 'Hours this week',
                  value: '24.5',
                  detail: 'Of 32h weekly goal',
                  icon: Icons.schedule_rounded,
                  color: _peach,
                ),
                _statCard(
                  width: cardWidth,
                  label: 'Team members',
                  value: '04',
                  detail: 'All in sync',
                  icon: Icons.group_outlined,
                  color: _blue,
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 22),
        LayoutBuilder(
          builder: (context, constraints) {
            final stack = constraints.maxWidth < 850;
            final chart = _weeklyProgressCard();
            final project = _featuredProjectCard();
            if (stack) {
              return Column(
                children: [
                  chart,
                  const SizedBox(height: 18),
                  project,
                ],
              );
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 6, child: chart),
                const SizedBox(width: 18),
                Expanded(flex: 4, child: project),
              ],
            );
          },
        ),
        const SizedBox(height: 22),
        LayoutBuilder(
          builder: (context, constraints) {
            final stack = constraints.maxWidth < 850;
            final tasks = _taskListCard(compact: true);
            final activity = _activityCard();
            if (stack) {
              return Column(
                children: [
                  tasks,
                  const SizedBox(height: 18),
                  activity,
                ],
              );
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 6, child: tasks),
                const SizedBox(width: 18),
                Expanded(flex: 4, child: activity),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildTasksPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _pageHeading(
          eyebrow: 'YOUR WORK, ALL IN ONE PLACE',
          title: 'My tasks',
          subtitle: 'Keep your momentum going, one thoughtful step at a time.',
          action: _primaryButton('＋  New task', _addTask),
        ),
        const SizedBox(height: 26),
        _taskListCard(compact: false),
      ],
    );
  }

  Widget _buildProjectsPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _pageHeading(
          eyebrow: 'THE BIG PICTURE',
          title: 'Projects',
          subtitle: 'A little progress adds up to beautiful things.',
          action: _primaryButton('＋  New task', _addTask),
        ),
        const SizedBox(height: 26),
        LayoutBuilder(
          builder: (context, constraints) {
            final gap = 16.0;
            final columns = constraints.maxWidth > 900
                ? 3
                : constraints.maxWidth > 580
                    ? 2
                    : 1;
            final width =
                (constraints.maxWidth - gap * (columns - 1)) / columns;
            return Wrap(
              spacing: gap,
              runSpacing: gap,
              children: [
                _projectCard(
                  width: width,
                  title: 'Website redesign',
                  category: 'DIGITAL PRODUCT',
                  progress: .72,
                  color: _purple,
                  due: 'Due Nov 20',
                  icon: Icons.web_rounded,
                ),
                _projectCard(
                  width: width,
                  title: 'Brand refresh',
                  category: 'BRAND IDENTITY',
                  progress: .48,
                  color: _peach,
                  due: 'Due Nov 24',
                  icon: Icons.palette_outlined,
                ),
                _projectCard(
                  width: width,
                  title: 'Summer campaign',
                  category: 'CAMPAIGN',
                  progress: .31,
                  color: _blue,
                  due: 'Due Dec 02',
                  icon: Icons.wb_sunny_outlined,
                ),
                _projectCard(
                  width: width,
                  title: 'Studio guidelines',
                  category: 'INTERNAL',
                  progress: .86,
                  color: const Color(0xFFE5F2D5),
                  due: 'Due Dec 08',
                  icon: Icons.auto_awesome_outlined,
                ),
                _projectCard(
                  width: width,
                  title: 'Packaging concepts',
                  category: 'PACKAGING',
                  progress: .22,
                  color: const Color(0xFFFFEBC4),
                  due: 'Due Dec 12',
                  icon: Icons.inventory_2_outlined,
                ),
                _projectCard(
                  width: width,
                  title: 'Social templates',
                  category: 'CONTENT',
                  progress: .57,
                  color: const Color(0xFFF5DFE8),
                  due: 'Due Dec 16',
                  icon: Icons.dashboard_customize_outlined,
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _pageHeading({
    required String eyebrow,
    required String title,
    required String subtitle,
    required Widget action,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final narrow = constraints.maxWidth < 640;
        final heading = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              eyebrow,
              style: const TextStyle(
                color: _muted,
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 9),
            Text(
              title,
              style: const TextStyle(
                color: _ink,
                fontSize: 29,
                fontWeight: FontWeight.w700,
                letterSpacing: -.8,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              subtitle,
              style: const TextStyle(
                color: _muted,
                fontSize: 13,
                height: 1.45,
              ),
            ),
          ],
        );
        if (narrow) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              heading,
              const SizedBox(height: 16),
              action,
            ],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: heading),
            action,
          ],
        );
      },
    );
  }

  Widget _primaryButton(String label, VoidCallback onPressed) {
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: _ink,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 13),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
      ),
      child: Text(label),
    );
  }

  Widget _statCard({
    required double width,
    required String label,
    required String value,
    required String detail,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: _line),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(label,
                    style: const TextStyle(color: _muted, fontSize: 11)),
              ),
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(icon, size: 16, color: _ink),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              color: _ink,
              fontSize: 27,
              height: 1,
              fontWeight: FontWeight.w700,
              letterSpacing: -.8,
            ),
          ),
          const SizedBox(height: 9),
          Text(detail,
              style: const TextStyle(color: _muted, fontSize: 10)),
        ],
      ),
    );
  }

  Widget _weeklyProgressCard() {
    const values = [0.35, 0.62, 0.48, 0.84, 0.69, 0.9, 0.53];
    const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    return _panel(
      padding: const EdgeInsets.fromLTRB(21, 20, 21, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Weekly focus',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w700)),
                    SizedBox(height: 4),
                    Text('Your creative hours this week',
                        style: TextStyle(color: _muted, fontSize: 10)),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                decoration: BoxDecoration(
                  color: _canvas,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Text('This week',
                        style: TextStyle(fontSize: 10, color: _ink)),
                    SizedBox(width: 5),
                    Icon(Icons.keyboard_arrow_down, size: 14),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 23),
          SizedBox(
            height: 114,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(values.length, (index) {
                final value = values[index];
                final today = index == 1;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 7),
                    child: Column(
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: FractionallySizedBox(
                              heightFactor: value,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: today ? _green : const Color(0xFFEDEFE7),
                                  borderRadius: BorderRadius.circular(7),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          days[index],
                          style: TextStyle(
                            color: today ? _ink : _muted,
                            fontSize: 10,
                            fontWeight:
                                today ? FontWeight.w700 : FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 14),
          const Divider(color: _line, height: 1),
          const SizedBox(height: 12),
          const Row(
            children: [
              Icon(Icons.trending_up_rounded, color: Color(0xFF729A4B), size: 16),
              SizedBox(width: 6),
              Text(
                'You’re 12% more focused than last week',
                style: TextStyle(color: _muted, fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _featuredProjectCard() {
    return _panel(
      padding: const EdgeInsets.all(21),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text('Project spotlight',
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
              ),
              IconButton(
                onPressed: () => _selectPage('Projects'),
                tooltip: 'View projects',
                icon: const Icon(Icons.arrow_forward_rounded, size: 17),
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            height: 112,
            decoration: BoxDecoration(
              color: _purple,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              children: [
                Positioned(
                  left: 18,
                  top: 17,
                  child: Container(
                    width: 94,
                    height: 77,
                    decoration: BoxDecoration(
                      color: const Color(0xFFCFC5FF),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: const Center(
                      child: Icon(Icons.web_rounded, size: 38, color: _ink),
                    ),
                  ),
                ),
                Positioned(
                  right: 20,
                  top: 27,
                  child: Transform.rotate(
                    angle: -.12,
                    child: Container(
                      width: 79,
                      height: 59,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: const [
                          BoxShadow(
                              color: Color(0x18000000),
                              blurRadius: 12,
                              offset: Offset(0, 5)),
                        ],
                      ),
                      child: const Icon(Icons.auto_awesome_rounded,
                          color: Color(0xFF8A78D7), size: 28),
                    ),
                  ),
                ),
                Positioned(
                  right: 18,
                  bottom: 12,
                  child: Container(
                    width: 29,
                    height: 29,
                    decoration: BoxDecoration(
                      color: _green,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child:
                        const Icon(Icons.north_east_rounded, size: 15, color: _ink),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Row(
            children: [
              Expanded(
                child: Text(
                  'Website redesign',
                  style: TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w700, color: _ink),
                ),
              ),
              Text('72%',
                  style: TextStyle(
                      fontSize: 11, fontWeight: FontWeight.w700, color: _ink)),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: const LinearProgressIndicator(
              value: .72,
              minHeight: 6,
              backgroundColor: Color(0xFFF0EFF5),
              color: Color(0xFF8D79D7),
            ),
          ),
          const SizedBox(height: 12),
          const Row(
            children: [
              Icon(Icons.schedule_rounded, size: 14, color: _muted),
              SizedBox(width: 5),
              Text('Due Nov 20', style: TextStyle(color: _muted, fontSize: 10)),
              Spacer(),
              _AvatarStack(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _taskListCard({required bool compact}) {
    final tasks = _visibleTasks;
    return _panel(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(compact ? 'Tasks to focus on' : 'All tasks',
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    Text(
                      '${_tasks.where((task) => !task.done).length} tasks need your attention',
                      style: const TextStyle(color: _muted, fontSize: 10),
                    ),
                  ],
                ),
              ),
              if (compact)
                TextButton(
                  onPressed: () => _selectPage('My tasks'),
                  child: const Text('View all',
                      style: TextStyle(
                          fontSize: 11,
                          color: _ink,
                          fontWeight: FontWeight.w700)),
                ),
            ],
          ),
          const SizedBox(height: 13),
          if (!compact) ...[
            Wrap(
              spacing: 7,
              children: ['All tasks', 'Today', 'Upcoming'].map((filter) {
                final selected = _filter == filter;
                return ChoiceChip(
                  label: Text(filter),
                  selected: selected,
                  onSelected: (_) => setState(() => _filter = filter),
                  labelStyle: TextStyle(
                    fontSize: 10,
                    color: selected ? Colors.white : _muted,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  ),
                  backgroundColor: Colors.white,
                  selectedColor: _ink,
                  side: BorderSide(color: selected ? _ink : _line),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                  visualDensity: VisualDensity.compact,
                  showCheckmark: false,
                );
              }).toList(),
            ),
            const SizedBox(height: 8),
          ],
          if (tasks.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 28),
              child: Center(
                child: Text('No tasks match your search.',
                    style: TextStyle(color: _muted, fontSize: 12)),
              ),
            )
          else
            ...tasks.take(compact ? 4 : tasks.length).map(_taskRow),
        ],
      ),
    );
  }

  Widget _taskRow(StudioTask task) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: _line)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 22,
            height: 22,
            child: Checkbox(
              value: task.done,
              onChanged: (value) => setState(() => task.done = value ?? false),
              activeColor: const Color(0xFF729A4B),
              side: const BorderSide(color: Color(0xFFCBCDC4)),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6)),
              visualDensity: VisualDensity.compact,
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: TextStyle(
                    color: task.done ? _muted : _ink,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    decoration:
                        task.done ? TextDecoration.lineThrough : null,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: task.color,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Flexible(
                      child: Text(
                        task.project,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: _muted, fontSize: 9),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            decoration: BoxDecoration(
              color: task.due == 'Today'
                  ? const Color(0xFFFFF1E9)
                  : const Color(0xFFF3F3EF),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              task.due,
              style: TextStyle(
                color: task.due == 'Today'
                    ? const Color(0xFFB46B47)
                    : _muted,
                fontSize: 9,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _activityCard() {
    return _panel(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Recent activity',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          const Text('The latest from your team',
              style: TextStyle(color: _muted, fontSize: 10)),
          const SizedBox(height: 18),
          _activityRow(
            initials: 'MK',
            color: _peach,
            name: 'Morgan Kim',
            action: 'shared a new moodboard',
            project: 'Brand refresh',
            time: '12 min ago',
          ),
          _activityRow(
            initials: 'AL',
            color: _blue,
            name: 'Alex Lee',
            action: 'completed a task',
            project: 'Summer campaign',
            time: '1 hour ago',
          ),
          _activityRow(
            initials: 'JD',
            color: const Color(0xFFE5F2D5),
            name: 'You',
            action: 'commented on',
            project: 'Website redesign',
            time: '3 hours ago',
          ),
          _activityRow(
            initials: 'SR',
            color: _purple,
            name: 'Sam Rivera',
            action: 'uploaded 3 files to',
            project: 'Studio guidelines',
            time: 'Yesterday',
          ),
        ],
      ),
    );
  }

  Widget _activityRow({
    required String initials,
    required Color color,
    required String name,
    required String action,
    required String project,
    required String time,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: color,
            child: Text(initials,
                style: const TextStyle(
                    color: _ink, fontSize: 9, fontWeight: FontWeight.w700)),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    style: const TextStyle(
                        color: _muted, fontSize: 10, height: 1.5),
                    children: [
                      TextSpan(
                          text: name,
                          style: const TextStyle(
                              color: _ink, fontWeight: FontWeight.w700)),
                      TextSpan(text: ' $action'),
                      TextSpan(
                          text: ' $project',
                          style: const TextStyle(
                              color: _ink, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(time,
                    style: const TextStyle(color: _muted, fontSize: 9)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _projectCard({
    required double width,
    required String title,
    required String category,
    required double progress,
    required Color color,
    required String due,
    required IconData icon,
  }) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(19),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: _line),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                    color: color, borderRadius: BorderRadius.circular(12)),
                child: Icon(icon, color: _ink, size: 21),
              ),
              const Spacer(),
              const Icon(Icons.more_horiz_rounded, color: _muted, size: 21),
            ],
          ),
          const SizedBox(height: 18),
          Text(category,
              style: const TextStyle(
                  color: _muted,
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1)),
          const SizedBox(height: 6),
          Text(title,
              style: const TextStyle(
                  color: _ink,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -.2)),
          const SizedBox(height: 18),
          Row(
            children: [
              const Expanded(
                  child: Text('Progress',
                      style: TextStyle(color: _muted, fontSize: 10))),
              Text('${(progress * 100).round()}%',
                  style: const TextStyle(
                      color: _ink, fontSize: 10, fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: const Color(0xFFF0F0EB),
              color: const Color(0xFF8DAE69),
            ),
          ),
          const SizedBox(height: 17),
          Row(
            children: [
              const _AvatarStack(),
              const Spacer(),
              const Icon(Icons.calendar_today_outlined,
                  size: 12, color: _muted),
              const SizedBox(width: 6),
              Text(due, style: const TextStyle(color: _muted, fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _panel({required Widget child, required EdgeInsets padding}) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: _line),
        borderRadius: BorderRadius.circular(15),
      ),
      child: child,
    );
  }
}

class _CreateTaskDialog extends StatefulWidget {
  const _CreateTaskDialog();

  @override
  State<_CreateTaskDialog> createState() => _CreateTaskDialogState();
}

class _CreateTaskDialogState extends State<_CreateTaskDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _projectController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _projectController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.pop(
      context,
      (
        _titleController.text.trim(),
        _projectController.text.trim().isEmpty
            ? 'Personal'
            : _projectController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: const Text('Create a task'),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: 380,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Task name',
                  hintText: 'What needs to get done?',
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Enter a task name'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _projectController,
                decoration: const InputDecoration(
                  labelText: 'Project',
                  hintText: 'e.g. Website redesign',
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: _ink,
            foregroundColor: Colors.white,
          ),
          onPressed: _submit,
          child: const Text('Add task'),
        ),
      ],
    );
  }
}

class _AvatarStack extends StatelessWidget {
  const _AvatarStack();

  @override
  Widget build(BuildContext context) {
    const colors = [_peach, _blue, _purple];
    const labels = ['MK', 'AL', 'SR'];
    return SizedBox(
      width: 66,
      height: 24,
      child: Stack(
        children: List.generate(3, (index) {
          return Positioned(
            left: index * 19,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: colors[index],
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Center(
                child: Text(
                  labels[index],
                  style: const TextStyle(
                      color: _ink, fontSize: 7, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
