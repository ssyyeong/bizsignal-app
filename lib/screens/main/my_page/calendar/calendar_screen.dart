import 'package:bizsignal_app/constants/app_colors.dart';
import 'package:bizsignal_app/widgets/app_bar_widget.dart';
import 'package:bizsignal_app/widgets/empty_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _selectedDate = DateTime.now();
  DateTime _currentMonth = DateTime.now();
  int _selectedFilterIndex = 0; // 0: 전체, 1: 다가오는 일정, 2: 종료 일정

  // 색상 정의 (이미지 참고)
  static const Color meetingColor = Color(0xFF24C780); // 모임 - 초록색
  static const Color oneOnOneColor = Color(0xFFA95CDD); // 1:1 만남 - 보라색
  static const Color sundayColor = Color(0xFFFF5959); // 일요일 - 빨간색
  static const Color saturdayColor = Color(0xFF59A6FF); // 토요일 - 파란색

  // TODO: 실제 이벤트 데이터로 교체
  final Map<String, List<String>> _events = {};

  // TODO: 실제 이벤트 리스트 데이터로 교체
  final List<Map<String, dynamic>> _eventList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBarWidget(title: '비즈 캘린더', isBackButton: true),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildCalendarHeader(),
                  _buildCalendar(),
                  _buildFilterTabs(),
                  _buildEventList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        children: [
          // 월/년도 선택 및 범례
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => _showMonthPicker(),
                    child: Row(
                      children: [
                        Text(
                          '${_currentMonth.month}월',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.gray900,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.keyboard_arrow_down,
                          size: 20,
                          color: AppColors.gray900,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () => _showYearPicker(),
                    child: Row(
                      children: [
                        Text(
                          '${_currentMonth.year}년',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.gray900,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.keyboard_arrow_down,
                          size: 20,
                          color: AppColors.gray900,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // 범례
              Row(
                children: [
                  _buildLegendItem(meetingColor, '모임'),
                  const SizedBox(width: 12),
                  _buildLegendItem(oneOnOneColor, '1:1 만남'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label, style: TextStyle(fontSize: 12, color: color)),
      ],
    );
  }

  Widget _buildCalendar() {
    // 선택된 날짜를 기준으로 해당 주의 일요일 찾기
    int selectedWeekday =
        _selectedDate.weekday == 7 ? 0 : _selectedDate.weekday;
    DateTime firstDayOfWeek = _selectedDate.subtract(
      Duration(days: selectedWeekday),
    );

    // 2주 (14일)의 날짜 리스트 생성
    List<DateTime> twoWeeks = [];
    for (int i = 0; i < 14; i++) {
      twoWeeks.add(firstDayOfWeek.add(Duration(days: i)));
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.gray50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 왼쪽 화살표 (세로 중앙 정렬)
          GestureDetector(
            onTap: () => _previousWeek(),
            child: Container(
              width: 24,
              height: 63,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.gray200),
              ),
              child: const Icon(
                Icons.chevron_left,
                size: 16,
                color: AppColors.gray700,
              ),
            ),
          ),
          const SizedBox(width: 8),
          // 캘린더 컨텐츠 (요일 헤더 + 날짜 그리드)
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 요일 헤더
                Row(
                  children:
                      ['일', '월', '화', '수', '목', '금', '토'].map((day) {
                        Color dayColor;
                        if (day == '일') {
                          dayColor = sundayColor; // 빨간색
                        } else if (day == '토') {
                          dayColor = saturdayColor; // 파란색
                        } else {
                          dayColor = AppColors.gray900; // 검정색
                        }

                        return Expanded(
                          child: Center(
                            child: Text(
                              day,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: dayColor,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                ),
                const SizedBox(height: 4),
                // 캘린더 그리드 (2주)
                SizedBox(
                  height: 117, // 높이 조정 (오버플로우 방지)
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 7,
                          childAspectRatio: 0.85,
                          mainAxisSpacing: 4,
                          crossAxisSpacing: 4,
                        ),
                    itemCount: 14,
                    itemBuilder: (context, index) {
                      final date = twoWeeks[index];
                      final isCurrentMonth =
                          date.year == _currentMonth.year &&
                          date.month == _currentMonth.month;
                      return _buildDayCell(
                        date.day,
                        !isCurrentMonth,
                        date: date,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // 오른쪽 화살표 (세로 중앙 정렬)
          GestureDetector(
            onTap: () => _nextWeek(),
            child: Container(
              width: 24,
              height: 63,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.gray200),
              ),
              child: const Icon(
                Icons.chevron_right,
                size: 16,
                color: AppColors.gray700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayCell(int day, bool isOtherMonth, {DateTime? date}) {
    bool isSelected = false;
    List<String>? events;

    if (!isOtherMonth && date != null) {
      isSelected =
          date.year == _selectedDate.year &&
          date.month == _selectedDate.month &&
          date.day == _selectedDate.day;

      final dateKey = DateFormat('yyyy-MM-dd').format(date);
      events = _events[dateKey];
    }

    final weekday = date?.weekday ?? DateTime.now().weekday;
    final isSunday = weekday == 7; // DateTime.weekday에서 7이 일요일
    final isSaturday = weekday == 6; // DateTime.weekday에서 6이 토요일

    // 날짜 텍스트 색상 결정
    Color dateTextColor;
    if (isSelected) {
      dateTextColor = AppColors.white; // 선택된 날짜는 흰색
    } else if (isOtherMonth) {
      dateTextColor = AppColors.gray400; // 다른 달은 회색
    } else if (isSunday) {
      dateTextColor = sundayColor; // 일요일은 빨간색
    } else if (isSaturday) {
      dateTextColor = saturdayColor; // 토요일은 파란색
    } else {
      dateTextColor = AppColors.gray900; // 평일은 검정색
    }

    return GestureDetector(
      onTap:
          date != null && !isOtherMonth
              ? () {
                setState(() {
                  _selectedDate = date;
                });
              }
              : null,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  day.toString(),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: dateTextColor,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 1),
          // 이벤트 표시 점
          if (events != null && events.isNotEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children:
                  events.map((eventType) {
                    return Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color:
                            eventType == 'meeting'
                                ? meetingColor
                                : oneOnOneColor,
                        shape: BoxShape.circle,
                      ),
                    );
                  }).toList(),
            ),
        ],
      ),
    );
  }

  void _previousWeek() {
    setState(() {
      _selectedDate = _selectedDate.subtract(const Duration(days: 14));
      // 선택된 날짜가 다른 달로 넘어가면 _currentMonth도 업데이트
      if (_selectedDate.month != _currentMonth.month ||
          _selectedDate.year != _currentMonth.year) {
        _currentMonth = DateTime(_selectedDate.year, _selectedDate.month);
      }
    });
  }

  void _nextWeek() {
    setState(() {
      _selectedDate = _selectedDate.add(const Duration(days: 14));
      // 선택된 날짜가 다른 달로 넘어가면 _currentMonth도 업데이트
      if (_selectedDate.month != _currentMonth.month ||
          _selectedDate.year != _currentMonth.year) {
        _currentMonth = DateTime(_selectedDate.year, _selectedDate.month);
      }
    });
  }

  void _showMonthPicker() {
    // 월 선택 다이얼로그 표시 (간단한 버전)
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('월 선택'),
            content: SingleChildScrollView(
              child: Column(
                children: List.generate(12, (index) {
                  final month = index + 1;
                  return ListTile(
                    title: Text('$month월'),
                    onTap: () {
                      setState(() {
                        _currentMonth = DateTime(_currentMonth.year, month);
                        // 선택된 날짜를 같은 달의 같은 날짜로 업데이트 (있는 경우)
                        final lastDayOfMonth =
                            DateTime(_currentMonth.year, month + 1, 0).day;
                        final newDay =
                            _selectedDate.day > lastDayOfMonth
                                ? lastDayOfMonth
                                : _selectedDate.day;
                        _selectedDate = DateTime(
                          _currentMonth.year,
                          month,
                          newDay,
                        );
                      });
                      Navigator.pop(context);
                    },
                  );
                }),
              ),
            ),
          ),
    );
  }

  void _showYearPicker() {
    // 년도 선택 다이얼로그 표시 (현재 연도 기준 앞뒤 2년)
    final currentYear = _currentMonth.year;
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('년도 선택'),
            content: SingleChildScrollView(
              child: Column(
                children: List.generate(5, (index) {
                  final year = currentYear - 2 + index; // 현재 연도 기준 -2 ~ +2년
                  return ListTile(
                    title: Text('$year년'),
                    onTap: () {
                      setState(() {
                        _currentMonth = DateTime(year, _currentMonth.month);
                        // 선택된 날짜도 같은 년도로 업데이트
                        final lastDayOfMonth =
                            DateTime(year, _currentMonth.month + 1, 0).day;
                        final newDay =
                            _selectedDate.day > lastDayOfMonth
                                ? lastDayOfMonth
                                : _selectedDate.day;
                        _selectedDate = DateTime(
                          year,
                          _currentMonth.month,
                          newDay,
                        );
                      });
                      Navigator.pop(context);
                    },
                  );
                }),
              ),
            ),
          ),
    );
  }

  Widget _buildFilterTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildFilterTab('전체', 0),
          const SizedBox(width: 8),
          _buildFilterTab('다가오는 일정', 1),
          const SizedBox(width: 8),
          _buildFilterTab('종료 일정', 2),
        ],
      ),
    );
  }

  Widget _buildFilterTab(String text, int index) {
    final isSelected = _selectedFilterIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilterIndex = index;
        });
      },
      child: Container(
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 11),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.gray900 : AppColors.white,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: isSelected ? AppColors.gray900 : AppColors.gray200,
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: isSelected ? AppColors.white : AppColors.gray700,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEventList() {
    // 필터에 따라 이벤트 필터링
    List<Map<String, dynamic>> filteredEvents = _eventList;
    final now = DateTime.now();

    if (_selectedFilterIndex == 1) {
      // 다가오는 일정
      filteredEvents =
          _eventList.where((event) => event['date'].isAfter(now)).toList();
    } else if (_selectedFilterIndex == 2) {
      // 종료 일정
      filteredEvents =
          _eventList
              .where(
                (event) => event['date'].isBefore(now) || event['isCompleted'],
              )
              .toList();
    }

    if (filteredEvents.isEmpty) {
      String title;
      if (_selectedFilterIndex == 1) {
        title = '다가오는 일정이 없습니다';
      } else if (_selectedFilterIndex == 2) {
        title = '종료된 일정이 없습니다';
      } else {
        title = '일정이 없습니다';
      }

      return EmptyState(
        title: title,
        description: '새로운 일정이 추가되면\n여기에 표시됩니다',
        icon: Icons.calendar_today_outlined,
      );
    }

    // 날짜별로 그룹화
    Map<String, List<Map<String, dynamic>>> groupedEvents = {};
    for (var event in filteredEvents) {
      final dateKey = DateFormat('yyyy-MM-dd').format(event['date']);
      if (!groupedEvents.containsKey(dateKey)) {
        groupedEvents[dateKey] = [];
      }
      groupedEvents[dateKey]!.add(event);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          groupedEvents.entries.map((entry) {
            final events = entry.value;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 날짜 헤더
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16, top: 12),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          'assets/images/icon/calendar_empty.svg',
                          width: 20,
                          height: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _formatEventDate(events[0]['date']),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.gray900,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // 이벤트 카드들
                  ...events.map((event) => _buildEventCard(event)),
                ],
              ),
            );
          }).toList(),
    );
  }

  Widget _buildEventCard(Map<String, dynamic> event) {
    final isMeeting = event['type'] == 'meeting';

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gray200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 상태 및 우측 정보
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 체크 아이콘 및 상태
              Row(
                children: [
                  Icon(
                    Icons.check,
                    size: 16,
                    color: AppColors.primary300, // 빨간색 체크
                  ),
                  const SizedBox(width: 6),
                  Text(
                    event['status'],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary300,
                    ),
                  ),
                ],
              ),
              // 우측: 사람 아이콘 + 인원 + 상태 태그
              Row(
                children: [
                  SvgPicture.asset(
                    'assets/images/icon/people_orange.svg',
                    width: 16,
                    height: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    event['participants'],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.gray700,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    height: 21,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary300,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      event['statusTag'],
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          // 제목
          Text(
            event['title'],
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.gray900,
            ),
          ),
          const SizedBox(height: 8),
          // 태그들
          Wrap(
            spacing: 4,
            runSpacing: 4,
            children:
                (event['tags'] as List<String>)
                    .map(
                      (tag) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          tag,
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.gray700,
                          ),
                        ),
                      ),
                    )
                    .toList(),
          ),
          const SizedBox(height: 12),
          // 버튼들
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    // 채팅방 이동
                  },
                  child: Container(
                    height: 28,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        isMeeting ? '모임 채팅방' : '1:1 채팅방',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    // 상세 보기
                  },
                  child: Container(
                    height: 28,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      border: Border.all(color: AppColors.gray200),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        '상세',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: AppColors.gray900,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatEventDate(DateTime date) {
    final weekdayNames = ['일', '월', '화', '수', '목', '금', '토'];
    final weekday = date.weekday == 7 ? 0 : date.weekday;
    final period = date.hour < 12 ? '오전' : '오후';
    int hour;
    if (date.hour == 0) {
      hour = 12; // 자정은 오전 12시
    } else if (date.hour == 12) {
      hour = 12; // 정오는 오후 12시
    } else if (date.hour > 12) {
      hour = date.hour - 12; // 오후 1시부터
    } else {
      hour = date.hour; // 오전 1시부터 11시까지
    }
    final minute = date.minute.toString().padLeft(2, '0');

    return '${date.year}년 ${date.month.toString().padLeft(2, '0')}월 ${date.day.toString().padLeft(2, '0')}일 (${weekdayNames[weekday]}) $period ${hour.toString().padLeft(2, '0')}:$minute';
  }
}
