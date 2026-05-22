import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:dio/dio.dart';
import '../../data/services/storage_service.dart';
import '../../core/constants/app_constants.dart';

class AdvancedStatisticsScreen extends StatefulWidget {
  const AdvancedStatisticsScreen({super.key});

  @override
  State<AdvancedStatisticsScreen> createState() =>
      _AdvancedStatisticsScreenState();
}

class _AdvancedStatisticsScreenState extends State<AdvancedStatisticsScreen> {
  bool _isLoading = true;
  Map<String, dynamic>? _statsData;
  late Dio _dio;

  @override
  void initState() {
    super.initState();
    _initializeAndLoadData();
  }

  Future<void> _initializeAndLoadData() async {
    final storageService = StorageService();
    final token = await storageService.getToken();

    _dio = Dio();
    _dio.options.headers['Authorization'] = 'Bearer $token';
    _dio.options.headers['Accept'] = 'application/json';

    await _loadAdvancedStats();
  }

  Future<void> _loadAdvancedStats() async {
    setState(() => _isLoading = true);

    try {
      final response = await _dio.get(
        '${AppConstants.baseUrl}/admin/dashboard/advanced-stats',
      );

      if (response.data['success']) {
        setState(() {
          _statsData = response.data['data'];
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Statistik Lanjutan'), elevation: 0),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadAdvancedStats,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildAbsensiPerHariChart(),
                    const SizedBox(height: 24),
                    _buildUserStatsChart(),
                    const SizedBox(height: 24),
                    _buildTopMataKuliahChart(),
                    const SizedBox(height: 24),
                    _buildPersentaseKehadiranList(),
                    const SizedBox(height: 24),
                    _buildRecentActivities(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildAbsensiPerHariChart() {
    if (_statsData == null || _statsData!['absensi_per_hari'] == null) {
      return const SizedBox();
    }

    final data = _statsData!['absensi_per_hari'] as List;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Absensi 7 Hari Terakhir',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 10,
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= 0 &&
                              value.toInt() < data.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                data[value.toInt()]['day'],
                                style: const TextStyle(fontSize: 10),
                              ),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: data.asMap().entries.map((entry) {
                        final count = entry.value['count'];
                        final countValue = count is int
                            ? count.toDouble()
                            : (count as double);
                        return FlSpot(entry.key.toDouble(), countValue);
                      }).toList(),
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 3,
                      dotData: const FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.blue.withValues(alpha: 0.1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserStatsChart() {
    if (_statsData == null || _statsData!['user_stats'] == null) {
      return const SizedBox();
    }

    final userStats = _statsData!['user_stats'] as Map<String, dynamic>;
    final admin = userStats['admin'] ?? 0;
    final dosen = userStats['dosen'] ?? 0;
    final mahasiswa = userStats['mahasiswa'] ?? 0;
    final total = admin + dosen + mahasiswa;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Distribusi User',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: PieChart(
                      PieChartData(
                        sectionsSpace: 2,
                        centerSpaceRadius: 40,
                        sections: [
                          PieChartSectionData(
                            value: admin.toDouble(),
                            title: '$admin',
                            color: Colors.purple,
                            radius: 50,
                            titleStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          PieChartSectionData(
                            value: dosen.toDouble(),
                            title: '$dosen',
                            color: Colors.green,
                            radius: 50,
                            titleStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          PieChartSectionData(
                            value: mahasiswa.toDouble(),
                            title: '$mahasiswa',
                            color: Colors.blue,
                            radius: 50,
                            titleStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLegendItem('Admin', Colors.purple, admin, total),
                        const SizedBox(height: 8),
                        _buildLegendItem('Dosen', Colors.green, dosen, total),
                        const SizedBox(height: 8),
                        _buildLegendItem(
                          'Mahasiswa',
                          Colors.blue,
                          mahasiswa,
                          total,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color, int value, int total) {
    final percentage = total > 0
        ? (value / total * 100).toStringAsFixed(1)
        : '0.0';
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '$percentage%',
                style: TextStyle(fontSize: 10, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTopMataKuliahChart() {
    if (_statsData == null || _statsData!['absensi_per_mata_kuliah'] == null) {
      return const SizedBox();
    }

    final data = _statsData!['absensi_per_mata_kuliah'] as List;
    if (data.isEmpty) return const SizedBox();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Top 5 Mata Kuliah (Absensi Terbanyak)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 250,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: (data.isNotEmpty
                      ? (data[0]['total'] as int).toDouble() * 1.2
                      : 100),
                  barTouchData: BarTouchData(enabled: true),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 60,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= 0 &&
                              value.toInt() < data.length) {
                            final namaMk =
                                data[value.toInt()]['nama_mk'] as String;
                            final words = namaMk.split(' ');
                            final shortName = words.length > 2
                                ? '${words[0]} ${words[1]}...'
                                : namaMk;
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                shortName,
                                style: const TextStyle(fontSize: 9),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(show: true, drawVerticalLine: false),
                  barGroups: data.asMap().entries.map((entry) {
                    return BarChartGroupData(
                      x: entry.key,
                      barRods: [
                        BarChartRodData(
                          toY: (entry.value['total'] is int
                              ? (entry.value['total'] as int).toDouble()
                              : entry.value['total'] as double),
                          color: Colors.blue,
                          width: 20,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(4),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPersentaseKehadiranList() {
    if (_statsData == null ||
        _statsData!['persentase_per_mata_kuliah'] == null) {
      return const SizedBox();
    }

    final data = _statsData!['persentase_per_mata_kuliah'] as List;
    if (data.isEmpty) return const SizedBox();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Persentase Kehadiran per Mata Kuliah',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...data.take(10).map((item) {
              final persentaseValue = item['persentase_kehadiran'];
              final persentase = persentaseValue is int
                  ? persentaseValue.toDouble()
                  : persentaseValue as double;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            item['mata_kuliah'],
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Text(
                          '${persentase.toStringAsFixed(1)}%',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: _getPersentaseColor(persentase),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: persentase / 100,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _getPersentaseColor(persentase),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Dosen: ${item['dosen']} • Peserta: ${item['total_peserta']} • Pertemuan: ${item['total_pertemuan']}',
                      style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Color _getPersentaseColor(double persentase) {
    if (persentase >= 80) return Colors.green;
    if (persentase >= 60) return Colors.orange;
    return Colors.red;
  }

  Widget _buildRecentActivities() {
    if (_statsData == null || _statsData!['recent_activities'] == null) {
      return const SizedBox();
    }

    final activities = _statsData!['recent_activities'] as List;
    if (activities.isEmpty) return const SizedBox();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Aktivitas Terbaru',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...activities.take(10).map((activity) {
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  backgroundColor: Colors.blue.withValues(alpha: 0.1),
                  child: const Icon(
                    Icons.check_circle,
                    color: Colors.blue,
                    size: 20,
                  ),
                ),
                title: Text(
                  activity['user'],
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  activity['mata_kuliah'],
                  style: const TextStyle(fontSize: 12),
                ),
                trailing: Text(
                  activity['time_ago'],
                  style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
