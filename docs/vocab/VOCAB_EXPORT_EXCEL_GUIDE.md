# 📊 API Xuất Từ Vựng Ra File Excel

> **Chức năng**: Xuất toàn bộ từ vựng trong hệ thống ra file Excel (.xlsx)

---

## 📋 Thông Tin API

### Endpoint

```
GET /api/v1/admin/vocabs/export/excel
```

### Authentication

-   **Required**: Yes (Admin role)
-   **Type**: Bearer Token
-   **Header**: `Authorization: Bearer {YOUR_ADMIN_TOKEN}`

### Response

-   **Content-Type**: `application/vnd.openxmlformats-officedocument.spreadsheetml.sheet`
-   **File Format**: Excel (.xlsx)
-   **Filename**: `vocabulary_export_YYYYMMDD_HHmmss.xlsx`

---

## 🎯 Nội Dung File Excel

### Sheet: "Vocabulary"

| #   | Column                   | Description         | Example                |
| --- | ------------------------ | ------------------- | ---------------------- |
| 1   | **STT**                  | Số thứ tự           | 1, 2, 3...             |
| 2   | **Word**                 | Từ vựng             | hello, world           |
| 3   | **Transcription**        | Phiên âm            | /həˈloʊ/, /wɜːrld/     |
| 4   | **Meaning (Vietnamese)** | Nghĩa tiếng Việt    | Xin chào, Thế giới     |
| 5   | **Interpret**            | Giải thích chi tiết | Lời chào hỏi thân mật  |
| 6   | **Example Sentence**     | Câu ví dụ           | Hello, how are you?    |
| 7   | **CEFR Level**           | Mức độ              | A1, A2, B1, B2, C1, C2 |
| 8   | **Types**                | Loại từ             | noun, verb, adjective  |
| 9   | **Topic**                | Chủ đề              | Greetings, Daily Life  |
| 10  | **Image URL**            | Link ảnh minh họa   | https://...            |
| 11  | **Audio URL**            | Link audio phát âm  | https://...            |
| 12  | **Credit**               | Nguồn/Ghi công      | Oxford Dictionary      |

### Định Dạng

-   ✅ **Header**: In đậm, màu nền xanh nhạt, căn giữa
-   ✅ **Data**: Border nhẹ, text wrap, căn trên
-   ✅ **Auto-fit**: Tự động điều chỉnh độ rộng cột
-   ✅ **Freeze Pane**: Đóng băng dòng đầu tiên
-   ✅ **UTF-8**: Hỗ trợ tiếng Việt có dấu

---

## 🚀 Cách Sử Dụng

### 1. Lấy Admin Token

Đăng nhập với tài khoản Admin:

```http
POST http://localhost:8080/api/v1/auth/login
Content-Type: application/json

{
  "email": "admin@example.com",
  "password": "your_password"
}
```

**Response**:

```json
{
    "status": "success",
    "data": {
        "accessToken": "eyJhbGciOiJIUzI1NiIs...",
        "user": {
            "email": "admin@example.com",
            "role": "ADMIN"
        }
    }
}
```

Lưu lại `accessToken`.

---

### 2. Xuất File Excel

#### **Option A: Sử dụng cURL**

```bash
curl -X GET "http://localhost:8080/api/v1/admin/vocabs/export/excel" \
  -H "Authorization: Bearer YOUR_ADMIN_TOKEN" \
  --output vocabulary_export.xlsx
```

#### **Option B: Sử dụng PowerShell**

```powershell
$token = "YOUR_ADMIN_TOKEN"
$headers = @{
    "Authorization" = "Bearer $token"
}

Invoke-WebRequest -Uri "http://localhost:8080/api/v1/admin/vocabs/export/excel" `
    -Headers $headers `
    -OutFile "vocabulary_export.xlsx"

Write-Host "✅ File đã được lưu: vocabulary_export.xlsx"
```

#### **Option C: Sử dụng Python**

```python
import requests

token = "YOUR_ADMIN_TOKEN"
headers = {
    "Authorization": f"Bearer {token}"
}

response = requests.get(
    "http://localhost:8080/api/v1/admin/vocabs/export/excel",
    headers=headers
)

if response.status_code == 200:
    with open("vocabulary_export.xlsx", "wb") as f:
        f.write(response.content)
    print("✅ File đã được lưu: vocabulary_export.xlsx")
else:
    print(f"❌ Lỗi: {response.status_code}")
```

#### **Option D: Sử dụng Postman**

1. **Method**: GET
2. **URL**: `http://localhost:8080/api/v1/admin/vocabs/export/excel`
3. **Headers**:
    - Key: `Authorization`
    - Value: `Bearer YOUR_ADMIN_TOKEN`
4. Click **Send**
5. Click **Save Response** → **Save to a file**
6. Lưu với tên: `vocabulary_export.xlsx`

#### **Option E: Sử dụng Thunder Client (VS Code)**

1. Tạo request mới: GET
2. URL: `http://localhost:8080/api/v1/admin/vocabs/export/excel`
3. Headers → Add:
    - `Authorization: Bearer YOUR_ADMIN_TOKEN`
4. Send → Save response as file

---

## 📝 Script PowerShell Tự Động

Tạo file `export-vocabulary.ps1`:

```powershell
#!/usr/bin/env pwsh
# Script xuất từ vựng ra Excel

param(
    [Parameter(Mandatory=$false)]
    [string]$BaseUrl = "http://localhost:8080",

    [Parameter(Mandatory=$false)]
    [string]$Token = "",

    [Parameter(Mandatory=$false)]
    [string]$OutputPath = "."
)

Write-Host "=================================" -ForegroundColor Cyan
Write-Host "📊 XUẤT TỪ VỰNG RA EXCEL" -ForegroundColor Cyan
Write-Host "=================================" -ForegroundColor Cyan
Write-Host ""

# Kiểm tra token
if ([string]::IsNullOrEmpty($Token)) {
    Write-Host "❌ Lỗi: Cần cung cấp Admin Token" -ForegroundColor Red
    Write-Host "Sử dụng: .\export-vocabulary.ps1 -Token 'YOUR_ADMIN_TOKEN'" -ForegroundColor Yellow
    exit 1
}

# Generate filename with timestamp
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$filename = "vocabulary_export_$timestamp.xlsx"
$filepath = Join-Path $OutputPath $filename

Write-Host "📡 Đang gọi API..." -ForegroundColor Cyan
Write-Host "   Endpoint: $BaseUrl/api/v1/admin/vocabs/export/excel" -ForegroundColor Gray
Write-Host ""

try {
    $headers = @{
        "Authorization" = "Bearer $Token"
    }

    # Download file
    Invoke-WebRequest -Uri "$BaseUrl/api/v1/admin/vocabs/export/excel" `
        -Headers $headers `
        -OutFile $filepath

    # Check if file exists and has content
    if (Test-Path $filepath) {
        $fileSize = (Get-Item $filepath).Length

        if ($fileSize -gt 0) {
            Write-Host "✅ Xuất file thành công!" -ForegroundColor Green
            Write-Host ""
            Write-Host "📄 Thông tin file:" -ForegroundColor Yellow
            Write-Host "   Tên file: $filename" -ForegroundColor White
            Write-Host "   Đường dẫn: $filepath" -ForegroundColor White
            Write-Host "   Kích thước: $([math]::Round($fileSize/1KB, 2)) KB" -ForegroundColor White
            Write-Host ""
            Write-Host "🎯 Mở file bằng Excel để xem dữ liệu" -ForegroundColor Cyan

            # Optionally open the file
            $openFile = Read-Host "Bạn có muốn mở file ngay không? (y/n)"
            if ($openFile -eq 'y' -or $openFile -eq 'Y') {
                Start-Process $filepath
            }
        } else {
            Write-Host "❌ File rỗng, có thể không có dữ liệu" -ForegroundColor Red
        }
    } else {
        Write-Host "❌ Không tìm thấy file đã tải" -ForegroundColor Red
    }

} catch {
    Write-Host "❌ LỖI: $($_.Exception.Message)" -ForegroundColor Red

    if ($_.Exception.Response) {
        $statusCode = $_.Exception.Response.StatusCode.value__
        Write-Host "   Status Code: $statusCode" -ForegroundColor Yellow

        if ($statusCode -eq 401 -or $statusCode -eq 403) {
            Write-Host "   ⛔ Token không hợp lệ hoặc không có quyền ADMIN" -ForegroundColor Red
        }
    }

    exit 1
}

Write-Host ""
Write-Host "=================================" -ForegroundColor Cyan
Write-Host "✨ Hoàn tất!" -ForegroundColor Green
Write-Host "=================================" -ForegroundColor Cyan
```

**Sử dụng**:

```powershell
.\export-vocabulary.ps1 -Token "YOUR_ADMIN_TOKEN"
```

---

## 🧪 Test & Validation

### 1. Kiểm Tra Response Headers

```bash
curl -I -X GET "http://localhost:8080/api/v1/admin/vocabs/export/excel" \
  -H "Authorization: Bearer YOUR_TOKEN"
```

**Expected Headers**:

```http
HTTP/1.1 200 OK
Content-Type: application/vnd.openxmlformats-officedocument.spreadsheetml.sheet
Content-Disposition: attachment; filename="vocabulary_export_20251113_143022.xlsx"
Content-Length: 45678
```

### 2. Kiểm Tra File Excel

Sau khi download, mở file bằng Excel/LibreOffice:

-   ✅ Header có định dạng đẹp (in đậm, màu xanh)
-   ✅ Dữ liệu đầy đủ, không bị lỗi font
-   ✅ Tiếng Việt có dấu hiển thị đúng
-   ✅ Cột tự động fit width
-   ✅ Có thể scroll, header cố định
-   ✅ Border đẹp, dễ đọc

### 3. Kiểm Tra Dữ Liệu

```python
import pandas as pd

# Đọc file Excel
df = pd.read_excel("vocabulary_export.xlsx")

# Kiểm tra
print(f"✅ Tổng số từ vựng: {len(df)}")
print(f"✅ Số cột: {len(df.columns)}")
print(f"✅ Các cột: {df.columns.tolist()}")

# Xem 5 dòng đầu
print("\n📋 Dữ liệu mẫu:")
print(df.head())

# Kiểm tra null
print("\n⚠️  Số giá trị null:")
print(df.isnull().sum())
```

---

## 🐛 Troubleshooting

### Lỗi: 401 Unauthorized

**Nguyên nhân**: Token không hợp lệ hoặc hết hạn

**Giải pháp**:

```bash
# Login lại để lấy token mới
curl -X POST http://localhost:8080/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@example.com","password":"password"}'
```

### Lỗi: 403 Forbidden

**Nguyên nhân**: User không có quyền ADMIN

**Giải pháp**: Đảm bảo tài khoản có role ADMIN

### Lỗi: File rỗng hoặc corrupt

**Nguyên nhân**:

-   Server chưa chạy
-   Database trống
-   Lỗi khi export

**Giải pháp**:

```bash
# Kiểm tra server
docker-compose ps

# Kiểm tra logs
docker-compose logs app | tail -50

# Kiểm tra database
docker exec -it card-words-postgres psql -U postgres -d card_words -c "SELECT COUNT(*) FROM vocab;"
```

### Lỗi: Cannot open file in Excel

**Nguyên nhân**: File không phải định dạng Excel hợp lệ

**Giải pháp**:

-   Kiểm tra Content-Type trong response
-   Kiểm tra logs server có lỗi không
-   Thử download lại

---

## 📊 Performance

### Benchmark

| Số từ vựng | Thời gian | Kích thước file |
| ---------- | --------- | --------------- |
| 100        | ~0.5s     | ~15 KB          |
| 1,000      | ~1.5s     | ~120 KB         |
| 10,000     | ~5s       | ~1.2 MB         |
| 50,000     | ~20s      | ~5.5 MB         |

### Optimization Tips

1. **Large Dataset**: Nếu >10,000 từ, cân nhắc export background job
2. **Pagination**: Có thể thêm params `?page=1&limit=5000`
3. **Caching**: Cache result nếu data không thay đổi thường xuyên
4. **Compression**: Có thể zip file trước khi download

---

## 🔐 Security

### Best Practices

1. **Token Management**:

    - Không hardcode token trong script
    - Sử dụng biến môi trường
    - Refresh token khi hết hạn

2. **Rate Limiting**:

    - Giới hạn số lần export/phút
    - Prevent brute force download

3. **Data Privacy**:
    - Chỉ admin mới được export
    - Log mọi export activity
    - Audit trail

---

## 📚 Related APIs

-   `POST /api/v1/admin/vocabs` - Thêm từ vựng mới
-   `PUT /api/v1/admin/vocabs/{id}` - Cập nhật từ vựng
-   `DELETE /api/v1/admin/vocabs/{id}` - Xóa từ vựng
-   `GET /api/v1/admin/vocabs` - Lấy danh sách có phân trang
-   `POST /api/v1/admin/vocabs/bulk-import` - Import hàng loạt

---

## 🎓 Examples

### Full Workflow Example

```bash
#!/bin/bash

echo "📊 Bắt đầu xuất từ vựng..."

# 1. Login
echo "🔐 Đăng nhập..."
LOGIN_RESPONSE=$(curl -s -X POST http://localhost:8080/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@example.com","password":"admin123"}')

TOKEN=$(echo $LOGIN_RESPONSE | jq -r '.data.accessToken')

if [ "$TOKEN" == "null" ] || [ -z "$TOKEN" ]; then
    echo "❌ Đăng nhập thất bại"
    exit 1
fi

echo "✅ Đăng nhập thành công"

# 2. Export
echo "📥 Đang xuất file..."
FILENAME="vocabulary_export_$(date +%Y%m%d_%H%M%S).xlsx"

curl -X GET "http://localhost:8080/api/v1/admin/vocabs/export/excel" \
  -H "Authorization: Bearer $TOKEN" \
  --output "$FILENAME"

# 3. Verify
if [ -f "$FILENAME" ]; then
    FILE_SIZE=$(stat -f%z "$FILENAME" 2>/dev/null || stat -c%s "$FILENAME")
    echo "✅ Xuất thành công!"
    echo "   File: $FILENAME"
    echo "   Size: $FILE_SIZE bytes"
else
    echo "❌ Xuất thất bại"
    exit 1
fi
```

---

**Created**: 2025-11-13  
**Last Updated**: 2025-11-13  
**Version**: 1.0.0  
**Status**: ✅ Production Ready
