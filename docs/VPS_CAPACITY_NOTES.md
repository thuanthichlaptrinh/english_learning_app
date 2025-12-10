# Ghi chú dung lượng VPS (3 vCPU / 3GB RAM / 60GB SSD, IOPS 21k Read / 7k Write, Network 100Mbps)

## Ước lượng tải chịu được (sơ bộ)

-   Phù hợp quy mô nhỏ: ~80–200 người dùng đồng thời với truy vấn nhẹ/đọc nhiều, tương đương ~3–4k request/phút nếu cache Redis tốt, DB không nghẽn và không có batch nặng.
-   3 vCPU giúp dư địa hơn so với 1–2 vCPU, nhưng vẫn cần giới hạn thread/pool để tránh context switch/GC quá tải.
-   IOPS 21k/7k đủ tốt cho workload đọc nhiều, ghi vừa phải; nếu ghi tăng đột biến, cần theo dõi latency DB.

## Điểm giới hạn chính

-   RAM 3GB: JVM + Spring Boot + Postgres + Redis client dùng ~1.5–2GB; đặt `-Xmx` thấp (1–1.2GB) và pool nhỏ để còn RAM cho OS, DB, Redis.
-   CPU 3 vCore: đủ cho workload nhẹ, nhưng GC/bùng nổ request vẫn có thể nghẽn nếu thread quá nhiều.
-   I/O: SSD 60GB với IOPS 21k/7k phù hợp đọc nhiều, ghi vừa; tránh batch ghi lớn hoặc VACUUM dài.

## Khuyến nghị cấu hình

-   JVM: `-Xms512m -Xmx1024m` (tối đa ~1200m), G1GC; hạn chế thread worker.
-   Hikari pool: 10–20; Redis pool: nhỏ gọn (10–20), timeout rõ ràng.
-   Web thread: Tomcat/Netty max-threads khoảng 100 hoặc thấp hơn nếu CPU bị áp.
-   Cache (Redis): cache nóng vocab/topic/config; tránh cache-thundering; key TTL hợp lý; giám sát hit/miss.
-   HTTP: bật gzip, keep-alive; giảm payload JSON, phân trang.
-   DB: đảm bảo index theo user_id, cefr, topic_id, created_at; hạn chế query nặng, phân trang.
-   Batch/AI: không chạy huấn luyện hay batch nặng trên VPS này; tách sang service khác.
-   Logging/metrics: Micrometer/Prometheus để theo dõi CPU, GC, pool, query time; log ở INFO/ERROR.

## Kế hoạch kiểm thử tải

-   Dùng k6/JMeter mô phỏng luồng thực tế (login, học từ, lưu tiến trình); chạy ngay trên VPS để có số liệu thật.
-   Theo dõi throughput/latency, CPU, GC, connection pool, hit/miss Redis, query time Postgres.
-   Điều chỉnh `-Xmx`, pool, thread, TTL cache theo kết quả benchmark.
