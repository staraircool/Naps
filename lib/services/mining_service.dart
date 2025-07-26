import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class MiningService {
  static final MiningService _instance = MiningService._internal();
  static MiningService get instance => _instance;
  MiningService._internal();

  static const double _baseMiningRate = 4.33333; // NAP per hour
  static const double _referralBonus = 1.33333; // NAP per hour per referral
  static const int _sessionDurationHours = 12;

  SharedPreferences? _prefs;
  Timer? _updateTimer;

  // Mining state
  bool _isMining = false;
  DateTime? _miningStartTime;
  double _currentBalance = 0.0;
  double _miningRate = _baseMiningRate;
  int _referralCount = 0;
  String? _referralCode;
  List<String> _referredUsers = [];

  // Getters
  bool get isMining => _isMining;
  DateTime? get miningStartTime => _miningStartTime;
  double get currentBalance => _currentBalance;
  double get miningRate => _miningRate;
  int get referralCount => _referralCount;
  String get referralCode => _referralCode ?? '';
  List<String> get referredUsers => _referredUsers;

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    await _loadData();
    _startUpdateTimer();
  }

  Future<void> _loadData() async {
    if (_prefs == null) return;

    // Load mining state
    _isMining = _prefs!.getBool('is_mining') ?? false;
    final startTimeMs = _prefs!.getInt('mining_start_time');
    if (startTimeMs != null) {
      _miningStartTime = DateTime.fromMillisecondsSinceEpoch(startTimeMs);
    }

    // Load balance and referrals
    _currentBalance = _prefs!.getDouble('current_balance') ?? 0.0;
    _referralCount = _prefs!.getInt('referral_count') ?? 0;
    _referralCode = _prefs!.getString('referral_code');
    _referredUsers = _prefs!.getStringList('referred_users') ?? [];

    // Generate referral code if not exists
    if (_referralCode == null) {
      _referralCode = _generateReferralCode();
      await _prefs!.setString('referral_code', _referralCode!);
    }

    // Calculate current mining rate
    _miningRate = _baseMiningRate + (_referralCount * _referralBonus);

    // Update balance if mining
    if (_isMining && _miningStartTime != null) {
      _updateBalance();
    }
  }

  String _generateReferralCode() {
    const uuid = Uuid();
    return 'NAP${uuid.v4().substring(0, 8).toUpperCase()}';
  }

  void _startUpdateTimer() {
    _updateTimer?.cancel();
    _updateTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isMining) {
        _updateBalance();
      }
    });
  }

  void _updateBalance() {
    if (_miningStartTime == null) return;

    final now = DateTime.now();
    final elapsedHours = now.difference(_miningStartTime!).inMilliseconds / (1000 * 60 * 60);
    
    // Cap at session duration
    final cappedHours = elapsedHours > _sessionDurationHours ? _sessionDurationHours : elapsedHours;
    
    final earnedTokens = cappedHours * _miningRate;
    _currentBalance = (_prefs!.getDouble('session_start_balance') ?? 0.0) + earnedTokens;
    
    // Save updated balance
    _prefs!.setDouble('current_balance', _currentBalance);

    // Stop mining if session is complete
    if (elapsedHours >= _sessionDurationHours) {
      stopMining();
    }
  }

  Future<void> startMining() async {
    if (_prefs == null || _isMining) return;

    _isMining = true;
    _miningStartTime = DateTime.now();
    
    await _prefs!.setBool('is_mining', true);
    await _prefs!.setInt('mining_start_time', _miningStartTime!.millisecondsSinceEpoch);
    await _prefs!.setDouble('session_start_balance', _currentBalance);
  }

  Future<void> stopMining() async {
    if (_prefs == null || !_isMining) return;

    _isMining = false;
    _miningStartTime = null;
    
    await _prefs!.setBool('is_mining', false);
    await _prefs!.remove('mining_start_time');
    await _prefs!.remove('session_start_balance');
  }

  Duration? getRemainingTime() {
    if (!_isMining || _miningStartTime == null) return null;

    final now = DateTime.now();
    final elapsed = now.difference(_miningStartTime!);
    final sessionDuration = Duration(hours: _sessionDurationHours);
    
    if (elapsed >= sessionDuration) return Duration.zero;
    
    return sessionDuration - elapsed;
  }

  Future<bool> addReferral(String referralCode) async {
    if (_prefs == null || _referredUsers.contains(referralCode)) return false;

    _referredUsers.add(referralCode);
    _referralCount = _referredUsers.length;
    _miningRate = _baseMiningRate + (_referralCount * _referralBonus);

    await _prefs!.setStringList('referred_users', _referredUsers);
    await _prefs!.setInt('referral_count', _referralCount);

    return true;
  }

  String getReferralLink() {
    return 'https://napcoin.app/invite?code=$_referralCode';
  }

  void dispose() {
    _updateTimer?.cancel();
  }
}

