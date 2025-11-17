# Database Persistence Guide - Docker Volumes

## 🎯 Câu trả lời: Database KHÔNG bị mất khi rebuild!

### **Lý do:**

Trong `docker-compose.yml`:

```yaml
postgres:
    volumes:
        - postgres_data:/var/lib/postgresql/data  # ✅ Named volume

volumes:
    postgres_data:
        driver: local  # ✅ Persistent storage
```

**Named volume** lưu data **bên ngoài container**, nên rebuild không ảnh hưởng!

---

## 📊 Các trường hợp cụ thể

### ✅ Data KHÔNG mất

| Command | Mô tả | Data |
|---------|-------|------|
| `docker-compose build` | Rebuild images | ✅ Giữ nguyên |
| `docker-compose restart` | Restart containers | ✅ Giữ nguyên |
| `docker-compose stop` + `up` | Stop và start lại | ✅ Giữ nguyên |
| `docker-compose down` | Stop và remove containers | ✅ Giữ nguyên |
| `docker-compose rm` | Remove containers | ✅ Giữ nguyên |
| `docker-compose up -d --build` | Rebuild và start | ✅ Giữ nguyên |

### ❌ Data BỊ MẤT

| Command | Mô tả | Data |
|---------|-------|------|
| `docker-compose down -v` | Stop và XÓA volumes | ❌ MẤT HẾT |
| `docker volume rm postgres_data` | Xóa volume | ❌ MẤT HẾT |
| `docker volume prune` | Xóa unused volumes | ❌ MẤT HẾT |

---

## 🔍 Kiểm tra Volumes

```bash
# List volumes
docker volume ls

# Expected output:
# DRIVER    VOLUME NAME
# local     server_postgres_data
# local     server_redis_data

# Inspect volume
docker volume inspect server_postgres_data

# Output:
# [
#     {
#         "Name": "server_postgres_data",
#         "Driver": "local",
#         "Mountpoint": "/var/lib/docker/volumes/server_postgres_data/_data",
#         "Labels": {...},
#         "Scope": "local"
#     }
# ]
```

---

## 💾 Backup & Restore

### Backup Database

```bash
# Method 1: SQL dump (Recommended)
docker-compose exec postgres pg_dump -U postgres card_words > backup_$(date +%Y%m%d_%H%M%S).sql

# Method 2: Backup volume
docker run --rm \
  -v server_postgres_data:/data \
  -v ${PWD}:/backup \
  alpine tar czf /backup/postgres_backup.tar.gz /data
```

### Restore Database

```bash
# Method 1: From SQL dump
docker-compose exec -T postgres psql -U postgres card_words < backup_20241116_120000.sql

# Method 2: Restore volume
docker run --rm \
  -v server_postgres_data:/data \
  -v ${PWD}:/backup \
  alpine tar xzf /backup/postgres_backup.tar.gz -C /
```

---

## 🛡️ Best Practices

### 1. Regular Backups

```bash
# Daily backup script
#!/bin/bash
DATE=$(date +%Y%m%d)
docker-compose exec postgres pg_dump -U postgres card_words > backups/db_$DATE.sql

# Keep last 7 days
find backups/ -name "db_*.sql" -mtime +7 -delete
```

### 2. Before Major Changes

```bash
# Backup before rebuild
docker-compose exec postgres pg_dump -U postgres card_words > backup_before_rebuild.sql

# Then rebuild safely
docker-compose build
docker-compose up -d
```

### 3. Never Use -v Flag

```bash
# ✅ SAFE - Keeps volumes
docker-compose down

# ❌ DANGEROUS - Deletes volumes
docker-compose down -v
```

### 4. Test Restore Process

```bash
# Test restore to verify backups work
docker-compose exec -T postgres psql -U postgres card_words < backup_test.sql
```

---

## 🔄 Safe Rebuild Process

```bash
# Step 1: Backup (optional but recommended)
docker-compose exec postgres pg_dump -U postgres card_words > backup.sql

# Step 2: Stop services
docker-compose stop

# Step 3: Rebuild
docker-compose build

# Step 4: Start services
docker-compose up -d

# Step 5: Verify data
docker-compose exec postgres psql -U postgres card_words -c "SELECT COUNT(*) FROM users;"
```

---

## 📝 Summary

### ✅ Your database is SAFE because:

1. Using **named volumes** (`postgres_data`)
2. Volumes stored **outside containers**
3. Rebuild only affects **container**, not **volume**
4. Data persists across rebuilds

### ⚠️ Data only lost if:

1. You explicitly delete volume: `docker-compose down -v`
2. You manually remove volume: `docker volume rm postgres_data`
3. You run: `docker volume prune`

### 🛡️ To be extra safe:

1. ✅ Regular backups
2. ✅ Never use `-v` flag
3. ✅ Test restore process
4. ✅ Keep backups in multiple locations

---

**Conclusion:** Yên tâm rebuild! Database của bạn an toàn! 🚀
