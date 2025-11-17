package com.thuanthichlaptrinh.card_words.core.usecase.admin;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.thuanthichlaptrinh.card_words.common.exceptions.ErrorException;
import com.thuanthichlaptrinh.card_words.common.utils.PasswordGenerator;
import com.thuanthichlaptrinh.card_words.core.domain.Game;
import com.thuanthichlaptrinh.card_words.core.domain.Role;
import com.thuanthichlaptrinh.card_words.core.domain.Token;
import com.thuanthichlaptrinh.card_words.core.domain.User;
import com.thuanthichlaptrinh.card_words.core.mapper.UserAdminMapper;
import com.thuanthichlaptrinh.card_words.dataprovider.repository.GameSessionRepository;
import com.thuanthichlaptrinh.card_words.dataprovider.repository.RoleRepository;
import com.thuanthichlaptrinh.card_words.dataprovider.repository.UserRepository;
import com.thuanthichlaptrinh.card_words.dataprovider.repository.UserVocabProgressRepository;
import com.thuanthichlaptrinh.card_words.dataprovider.repository.VocabRepository;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.request.user.UpdateRolesRequest;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.admin.AdminDashboardResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.admin.DashboardStats;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.admin.GameStatsSummary;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.admin.ResetPasswordResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.admin.SystemOverviewResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.admin.TopLearner;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.admin.UserRegistrationData;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.user.UserAdminResponse;
import com.thuanthichlaptrinh.card_words.entrypoint.dto.response.user.UserStatisticsResponse;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
public class UserAdminService {

    private final UserRepository userRepository;
    private final RoleRepository roleRepository;
    private final UserAdminMapper userMapper;
    private final VocabRepository vocabRepository;
    private final UserVocabProgressRepository userVocabProgressRepository;
    private final GameSessionRepository gameSessionRepository;
    private final com.thuanthichlaptrinh.card_words.dataprovider.repository.TopicRepository topicRepository;
    private final com.thuanthichlaptrinh.card_words.dataprovider.repository.GameRepository gameRepository;
    private final com.thuanthichlaptrinh.card_words.dataprovider.repository.TokenRepository tokenRepository;
    private final org.springframework.security.crypto.password.PasswordEncoder passwordEncoder;
    private final com.thuanthichlaptrinh.card_words.core.usecase.user.EmailService emailService;

    public Page<UserAdminResponse> getAllUsers(int page, int size, String sortBy, String sortDir) {
        log.info("Admin: Lấy danh sách người dùng - page: {}, size: {}, sortBy: {}, sortDir: {}",
                page, size, sortBy, sortDir);

        Sort sort = sortDir.equalsIgnoreCase("desc")
                ? Sort.by(sortBy).descending()
                : Sort.by(sortBy).ascending();
        Pageable pageable = PageRequest.of(page, size, sort);

        Page<User> users = userRepository.findAll(pageable);
        return users.map(userMapper::toUserAdminResponse);
    }

    public UserAdminResponse getUserById(UUID id) {
        log.info("Admin: Lấy thông tin người dùng theo ID: {}", id);

        User user = userRepository.findById(id)
                .orElseThrow(() -> new ErrorException("Không tìm thấy người dùng với ID: " + id));

        return userMapper.toUserAdminResponse(user);
    }

    public UserAdminResponse getUserByEmail(String email) {
        log.info("Admin: Lấy thông tin người dùng theo email: {}", email);

        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new ErrorException("Không tìm thấy người dùng với email: " + email));

        return userMapper.toUserAdminResponse(user);
    }

    public Page<UserAdminResponse> searchUsers(String keyword, int page, int size) {
        log.info("Admin: Tìm kiếm người dùng với keyword: {}", keyword);

        Pageable pageable = PageRequest.of(page, size, Sort.by("createdAt").descending());
        Page<User> users = userRepository.findByNameContainingIgnoreCaseOrEmailContainingIgnoreCase(
                keyword, keyword, pageable);

        return users.map(userMapper::toUserAdminResponse);
    }

    @Transactional
    public UserAdminResponse toggleBanUser(UUID id, boolean banned) {
        log.info("Admin: {} tài khoản người dùng ID: {}", banned ? "Khóa" : "Mở khóa", id);

        User user = userRepository.findById(id)
                .orElseThrow(() -> new ErrorException("Không tìm thấy người dùng"));

        user.setBanned(banned);
        user = userRepository.save(user);

        return userMapper.toUserAdminResponse(user);
    }

    @Transactional
    public UserAdminResponse toggleActivateUser(UUID id, boolean activated) {
        log.info("Admin: {} tài khoản người dùng ID: {}", activated ? "Kích hoạt" : "Vô hiệu hóa", id);

        User user = userRepository.findById(id)
                .orElseThrow(() -> new ErrorException("Không tìm thấy người dùng"));

        user.setActivated(activated);
        user = userRepository.save(user);

        return userMapper.toUserAdminResponse(user);
    }

    @Transactional
    public UserAdminResponse updateUserRoles(UUID id, UpdateRolesRequest request) {
        log.info("Admin: Cập nhật role cho người dùng ID: {}", id);

        User user = userRepository.findById(id)
                .orElseThrow(() -> new ErrorException("Không tìm thấy người dùng"));

        user.getRoles().clear();

        for (String roleName : request.getRoleNames()) {
            Role role = roleRepository.findByName(roleName)
                    .orElseThrow(() -> new ErrorException("Không tìm thấy role: " + roleName));
            user.getRoles().add(role);
        }

        user = userRepository.save(user);

        return userMapper.toUserAdminResponse(user);
    }

    @Transactional
    public void deleteUser(UUID id) {
        log.info("Admin: Xóa người dùng ID: {}", id);

        if (!userRepository.existsById(id)) {
            throw new ErrorException("Không tìm thấy người dùng");
        }

        userRepository.deleteById(id);
    }

    public UserStatisticsResponse getUserStatistics() {
        log.info("Admin: Lấy thống kê người dùng");

        long totalUsers = userRepository.count();
        long activatedUsers = userRepository.countByActivated(true);
        long bannedUsers = userRepository.countByBanned(true);
        long adminUsers = userRepository.countByRoles_Name("ROLE_ADMIN");

        return UserStatisticsResponse.builder()
                .totalUsers(totalUsers)
                .activatedUsers(activatedUsers)
                .bannedUsers(bannedUsers)
                .adminUsers(adminUsers)
                .normalUsers(totalUsers - adminUsers)
                .build();
    }

    public AdminDashboardResponse getUserRegistrationChartWithTopLearners(int days) {
        log.info("Admin: Lấy biểu đồ đăng ký người dùng cho {} ngày gần nhất", days);

        // 1. Thống kê tổng quan
        long totalUsers = userRepository.count();
        long totalVocabs = vocabRepository.count();
        long totalNotifications = 0; // Placeholder - update if you have notification repository
        long totalLearningSession = gameSessionRepository.countByFinishedAtIsNotNull();

        DashboardStats stats = DashboardStats.builder()
                .totalUsers(totalUsers)
                .totalVocabs(totalVocabs)
                .totalNotifications(totalNotifications)
                .totalLearningSession(totalLearningSession)
                .build();

        // 2. Biểu đồ đăng ký người dùng theo ngày
        LocalDateTime startDate = LocalDateTime.now().minusDays(days);
        List<Object[]> registrationData = userRepository.countUserRegistrationsByDate(startDate);

        List<UserRegistrationData> userRegistrationChart = registrationData.stream()
                .map(row -> UserRegistrationData.builder()
                        .date(row[0].toString())
                        .count((Long) row[1])
                        .build())
                .collect(Collectors.toList());

        // Fill missing dates with 0 count
        userRegistrationChart = fillMissingDates(userRegistrationChart, days);

        // 3. Top học viên giỏi
        Pageable topLearnersPageable = PageRequest.of(0, 10);
        Page<User> topUsersPage = userRepository.findTopLearners(topLearnersPageable);

        List<TopLearner> topLearners = topUsersPage.getContent().stream()
                .map(user -> {
                    long wordsLearned = userVocabProgressRepository.countLearnedVocabs(user.getId());
                    Integer totalScore = calculateTotalScore(user.getId());

                    return TopLearner.builder()
                            .userId(user.getId())
                            .name(user.getName())
                            .email(user.getEmail())
                            .avatarUrl(user.getAvatar())
                            .totalWordsLearned(wordsLearned)
                            .currentStreak(user.getCurrentStreak() != null ? user.getCurrentStreak() : 0)
                            .totalScore(totalScore != null ? totalScore : 0)
                            .build();
                })
                .collect(Collectors.toList());

        return AdminDashboardResponse.builder()
                .stats(stats)
                .userRegistrationChart(userRegistrationChart)
                .topLearners(topLearners)
                .build();
    }

    private List<UserRegistrationData> fillMissingDates(List<UserRegistrationData> data, int days) {
        List<UserRegistrationData> result = new ArrayList<>();
        LocalDate endDate = LocalDate.now();
        LocalDate startDate = endDate.minusDays(days - 1);

        for (LocalDate date = startDate; !date.isAfter(endDate); date = date.plusDays(1)) {
            String dateStr = date.toString();
            UserRegistrationData found = data.stream()
                    .filter(d -> d.getDate().equals(dateStr))
                    .findFirst()
                    .orElse(null);

            if (found != null) {
                result.add(found);
            } else {
                result.add(UserRegistrationData.builder()
                        .date(dateStr)
                        .count(0L)
                        .build());
            }
        }

        return result;
    }

    private Integer calculateTotalScore(UUID userId) {
        // Calculate total score from all game sessions
        List<Integer> scores = gameSessionRepository.findByUserIdOrderByStartedAtDesc(userId)
                .stream()
                .filter(session -> session.getScore() != null)
                .map(session -> session.getScore())
                .collect(Collectors.toList());

        return scores.stream().mapToInt(Integer::intValue).sum();
    }

    public SystemOverviewResponse getSystemOverview() {
        log.info("Admin: Lấy tổng quan hệ thống");

        long totalUsers = userRepository.count();
        long totalVocabs = vocabRepository.count();
        long totalTopics = topicRepository.count();
        long totalGameSessions = gameSessionRepository.count();
        long completedGameSessions = gameSessionRepository.countByFinishedAtIsNotNull();

        Double avgScore = gameSessionRepository.findOverallAverageScore();
        Integer highestScore = gameSessionRepository.findOverallHighestScore();

        long totalWordsLearned = userVocabProgressRepository.count();

        // Count active users today (users who have game sessions or vocab progress
        // today)
        LocalDate today = LocalDate.now();
        long activeUsersToday = userRepository.findAll().stream()
                .filter(user -> {
                    LocalDate lastActivity = user.getLastActivityDate();
                    return lastActivity != null && lastActivity.equals(today);
                })
                .count();

        return SystemOverviewResponse.builder()
                .totalUsers(totalUsers)
                .activeUsersToday(activeUsersToday)
                .totalVocabs(totalVocabs)
                .totalTopics(totalTopics)
                .totalGameSessions(totalGameSessions)
                .completedGameSessions(completedGameSessions)
                .averageScore(avgScore != null ? avgScore : 0.0)
                .highestScore(highestScore != null ? highestScore : 0)
                .totalWordsLearned(totalWordsLearned)
                .build();
    }

    public List<GameStatsSummary> getGameStatsSummary() {
        log.info("Admin: Lấy thống kê tổng hợp các game");

        List<Game> games = gameRepository.findAll();

        return games.stream()
                .map(game -> {
                    long totalSessions = gameSessionRepository.countByGameId(game.getId());
                    long completedSessions = gameSessionRepository.countByGameIdAndFinishedAtIsNotNull(game.getId());

                    Double avgScore = gameSessionRepository.findAverageScoreByGameId(game.getId());
                    Integer highestScore = gameSessionRepository.findHighestScoreByGameId(game.getId());
                    Double avgAccuracy = gameSessionRepository.findAverageAccuracyByGameId(game.getId());

                    return GameStatsSummary.builder()
                            .gameId(game.getId())
                            .gameName(game.getName())
                            .totalSessions(totalSessions)
                            .completedSessions(completedSessions)
                            .averageScore(avgScore != null ? avgScore : 0.0)
                            .highestScore(highestScore != null ? highestScore : 0)
                            .averageAccuracy(avgAccuracy != null ? avgAccuracy : 0.0)
                            .build();
                })
                .collect(Collectors.toList());
    }

    @Transactional
    public ResetPasswordResponse resetUserPassword(
            UUID userId) {
        log.info("Admin: Reset mật khẩu cho user ID: {}", userId);

        User user = userRepository.findById(userId)
                .orElseThrow(() -> new ErrorException("Không tìm thấy người dùng"));

        // Tạo mật khẩu mới
        String newPassword = PasswordGenerator.generatePassword();

        // Cập nhật mật khẩu
        user.setPassword(passwordEncoder.encode(newPassword));
        user = userRepository.save(user);

        // Thu hồi tất cả token của user
        List<Token> tokens = tokenRepository.findAllByUserId(userId);
        if (!tokens.isEmpty()) {
            tokens.forEach(token -> {
                token.setExpired(true);
                token.setRevoked(true);
            });
            tokenRepository.saveAll(tokens);
        }

        // Gửi email thông báo
        try {
            emailService.sendNewPasswordEmail(user.getEmail(), user.getName(), newPassword);
            log.info("Đã gửi mật khẩu mới về email: {}", user.getEmail());
        } catch (Exception e) {
            log.warn("Không thể gửi email, nhưng mật khẩu đã được reset: {}", e.getMessage());
        }

        return ResetPasswordResponse.builder()
                .userId(user.getId())
                .email(user.getEmail())
                .name(user.getName())
                .newPassword(newPassword)
                .message("Mật khẩu đã được reset và gửi về email người dùng")
                .build();
    }
}
