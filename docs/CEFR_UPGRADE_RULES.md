# Quy tắc nâng cấp CEFR (đang áp dụng trong code)

Tài liệu này mô tả các quy tắc trong `CEFRUpgradeService` để quyết định khi nào user được lên cấp CEFR kế tiếp.

## Ngưỡng hiện tại (theo code)

-   **Số từ tối thiểu ở level hiện tại** (đếm tổng số từ bạn đã học/ôn ở level đó, không yêu cầu tất cả phải mastered)
    -   A1: 30
    -   A2: 50
    -   B1: 70
    -   B2: 90
    -   C1: 110
-   **Tỷ lệ mastery ở level hiện tại**: ít nhất 70% số từ **đã học ở level hiện tại** phải ở trạng thái `MASTERED`.
-   **Accuracy ở level hiện tại (đúng / tổng lượt)**
    -   A1: ≥ 75%
    -   A2: ≥ 75%
    -   B1: ≥ 78%
    -   B2: ≥ 80%
    -   C1: ≥ 82%
    -   Cách tính: lấy tổng lượt trả lời đúng của các từ thuộc level đó chia cho (đúng + sai) của cùng nhóm từ. Ví dụ A1: `accuracy = (tổng đúng A1) / (tổng đúng A1 + tổng sai A1)` và cần ≥ 75% để đủ điều kiện.
-   **Số từ đã “khám phá” ở level kế tiếp (đã bắt đầu học ở level sau)**
    -   A1→A2, A2→B1, B1→B2: ≥ 10 từ
    -   B2→C1: ≥ 15 từ
    -   C1→C2: ≥ 20 từ
-   **Accuracy ở level kế tiếp (trên nhóm từ đã khám phá)**
    -   A1→A2, A2→B1, B1→B2: ≥ 60%
    -   B2→C1: ≥ 65%
    -   C1→C2: ≥ 70%

## Làm rõ về “số từ tối thiểu”

-   “Min words” là **tổng số từ đã học ở level hiện tại**, không yêu cầu tất cả phải `MASTERED`.
-   Điều kiện mastery nằm ở quy tắc **tỷ lệ mastery ≥ 70%**. Ví dụ A1:
    -   Cần tối thiểu **30 từ** đã học ở A1.
    -   Trong đó ít nhất **70% (21 từ)** ở trạng thái `MASTERED`.
    -   Cần thêm **accuracy A1 ≥ 75%**.
    -   Đồng thời đạt điều kiện khám phá + accuracy cho level kế tiếp.

## Checklist nâng cấp (code kiểm tra tuần tự)

1. `totalLearned` ở level hiện tại ≥ số từ tối thiểu của level đó.
2. `masteryRate` ở level hiện tại ≥ 70% (mastered / totalLearned).
3. `accuracy` ở level hiện tại ≥ ngưỡng accuracy của level đó.
4. `totalLearned` ở level kế tiếp ≥ ngưỡng khám phá.
5. `accuracy` ở level kế tiếp ≥ ngưỡng accuracy của level kế tiếp.
6. Nếu thỏa tất cả, nâng `currentLevel` lên level CEFR kế tiếp và gửi thông báo.

## Tóm tắt cách lên level (dễ hiểu)

-   Đang ở level L, muốn lên level L+1 cần:
    1. **Số từ đã học ở L**: đạt min (A1:30, A2:50, B1:70, B2:90, C1:110).
    2. **Từ MASTERED ở L**: ít nhất 70% số từ đã học ở L phải ở trạng thái `MASTERED`.
    3. **Độ chính xác ở L**: đạt ngưỡng của L (A1/ A2: 75%, B1: 78%, B2: 80%, C1: 82%).
    4. **Khám phá L+1**: đã học tối thiểu (A1→A2/A2→B1/B1→B2: 10 từ; B2→C1: 15; C1→C2: 20).
    5. **Độ chính xác ở L+1** (trên nhóm từ đã khám phá): đạt ngưỡng (A1→A2/A2→B1/B1→B2: 60%; B2→C1: 65%; C1→C2: 70%).
-   Khi 1–5 đều đạt, hệ thống tự nâng level và gửi thông báo.

## Nguồn

-   Logic nằm ở `src/main/java/com/thuanthichlaptrinh/card_words/core/usecase/user/CEFRUpgradeService.java`.
