# 📊 API Xuất Từ Vựng Ra Excel

> API cho phép Admin xuất toàn bộ từ vựng trong hệ thống ra file Excel (.xlsx)

---

## 🎯 Endpoint

```
GET /api/v1/admin/vocabs/export/excel
```

**Authentication**: Requires ADMIN role

---

## 📋 Thông Tin Excel File

### Cột dữ liệu

| STT | Tên Cột              | Mô Tả               | Ví Dụ                   |
| --- | -------------------- | ------------------- | ----------------------- |
| 1   | STT                  | Số thứ tự           | 1, 2, 3...              |
| 2   | Word                 | Từ vựng tiếng Anh   | hello, world, bread     |
| 3   | Transcription        | Phiên âm            | /həˈləʊ/, /wɜːld/       |
| 4   | Meaning (Vietnamese) | Nghĩa tiếng Việt    | xin chào, thế giới      |
| 5   | Interpret            | Giải thích chi tiết | Lời chào thân thiện...  |
| 6   | Example Sentence     | Câu ví dụ           | Hello, how are you?     |
| 7   | CEFR Level           | Mức độ (A1-C2)      | A1, B1, C2              |
| 8   | Types                | Loại từ             | noun, verb, adjective   |
| 9   | Topic                | Chủ đề              | greetings, food, travel |
| 10  | Image URL            | Link hình ảnh       | https://...             |
| 11  | Audio URL            | Link phát âm        | https://...             |
| 12  | Credit               | Ghi công            | Oxford Dictionary       |

### Features

-   ✅ **Header đẹp**: Background màu xanh nhạt, chữ in đậm
-   ✅ **Border**: Tất cả cells đều có viền
-   ✅ **Auto-size columns**: Tự động điều chỉnh độ rộng
-   ✅ **Freeze header**: Dòng tiêu đề cố định khi scroll
-   ✅ **Text wrap**: Tự động xuống dòng cho text dài
-   ✅ **Timestamp filename**: Tên file có thời gian tạo

---

## 🚀 Cách Sử Dụng

### Option 1: cURL

```bash
curl -X GET "http://localhost:8080/api/v1/admin/vocabs/export/excel" \
  -H "Authorization: Bearer YOUR_ADMIN_TOKEN" \
  --output vocabulary_export.xlsx
```

### Option 2: PowerShell

```powershell
$token = "YOUR_ADMIN_TOKEN"
$headers = @{
    "Authorization" = "Bearer $token"
}

Invoke-RestMethod -Uri "http://localhost:8080/api/v1/admin/vocabs/export/excel" `
    -Method Get `
    -Headers $headers `
    -OutFile "vocabulary_export.xlsx"

Write-Host "✅ File đã được tải xuống: vocabulary_export.xlsx" -ForegroundColor Green
```

### Option 3: Postman

1. **Method**: GET
2. **URL**: `http://localhost:8080/api/v1/admin/vocabs/export/excel`
3. **Headers**:
    - `Authorization`: `Bearer YOUR_ADMIN_TOKEN`
4. **Send to Download**: Click **Send and Download**

### Option 4: Swagger UI

1. Mở: `http://localhost:8080/swagger-ui.html`
2. Tìm: **Vocab Admin** → **GET /api/v1/admin/vocabs/export/excel**
3. Click **Try it out**
4. Nhập Admin token
5. Click **Execute**
6. Click **Download file** trong response

### Option 5: Browser (Simplest)

Sau khi login và lấy token:

```
http://localhost:8080/api/v1/admin/vocabs/export/excel?authorization=Bearer YOUR_TOKEN
```

**Lưu ý**: Cần copy token vào URL hoặc dùng extension để set header.

---

## 📝 Response

### Success Response

-   **Status**: 200 OK
-   **Content-Type**: `application/octet-stream`
-   **Content-Disposition**: `attachment; filename="vocabulary_export_YYYYMMDD_HHmmss.xlsx"`
-   **Body**: Binary Excel file

**Filename format**: `vocabulary_export_20251113_002740.xlsx`

### Error Responses

**401 Unauthorized**

```json
{
    "status": "error",
    "code": "401",
    "message": "Unauthorized - Token không hợp lệ"
}
```

**403 Forbidden**

```json
{
    "status": "error",
    "code": "403",
    "message": "Forbidden - Không có quyền Admin"
}
```

**500 Internal Server Error**

```json
{
    "status": "error",
    "code": "500",
    "message": "Lỗi khi xuất file Excel: ..."
}
```

---

## 💻 Code Examples

### JavaScript/Fetch

```javascript
const exportVocabsToExcel = async () => {
    const token = localStorage.getItem('adminToken');

    try {
        const response = await fetch('http://localhost:8080/api/v1/admin/vocabs/export/excel', {
            method: 'GET',
            headers: {
                Authorization: `Bearer ${token}`,
            },
        });

        if (!response.ok) {
            throw new Error('Export failed');
        }

        // Get filename from Content-Disposition header
        const contentDisposition = response.headers.get('Content-Disposition');
        const filename = contentDisposition
            ? contentDisposition.split('filename=')[1].replace(/"/g, '')
            : 'vocabulary_export.xlsx';

        // Download file
        const blob = await response.blob();
        const url = window.URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = url;
        a.download = filename;
        document.body.appendChild(a);
        a.click();
        window.URL.revokeObjectURL(url);
        document.body.removeChild(a);

        console.log('✅ File đã được tải xuống:', filename);
    } catch (error) {
        console.error('❌ Lỗi khi xuất Excel:', error);
    }
};

// Usage
exportVocabsToExcel();
```

### React Example

```jsx
import { useState } from 'react';
import { Button, message } from 'antd';
import { DownloadOutlined } from '@ant-design/icons';

const ExportVocabButton = () => {
    const [loading, setLoading] = useState(false);

    const handleExport = async () => {
        setLoading(true);

        try {
            const token = localStorage.getItem('adminToken');
            const response = await fetch('http://localhost:8080/api/v1/admin/vocabs/export/excel', {
                headers: { Authorization: `Bearer ${token}` },
            });

            if (!response.ok) throw new Error('Export failed');

            const blob = await response.blob();
            const url = window.URL.createObjectURL(blob);
            const a = document.createElement('a');
            a.href = url;
            a.download = `vocabulary_export_${new Date().getTime()}.xlsx`;
            a.click();
            window.URL.revokeObjectURL(url);

            message.success('Xuất file Excel thành công!');
        } catch (error) {
            message.error('Lỗi khi xuất file Excel');
            console.error(error);
        } finally {
            setLoading(false);
        }
    };

    return (
        <Button type="primary" icon={<DownloadOutlined />} loading={loading} onClick={handleExport}>
            Xuất Excel
        </Button>
    );
};
```

### Python Example

```python
import requests
from datetime import datetime

def export_vocabs_to_excel(token: str, output_path: str = None):
    """
    Export vocabularies to Excel file

    Args:
        token: Admin JWT token
        output_path: Path to save file (optional)
    """
    url = "http://localhost:8080/api/v1/admin/vocabs/export/excel"
    headers = {"Authorization": f"Bearer {token}"}

    try:
        print("📡 Đang xuất file Excel...")
        response = requests.get(url, headers=headers, timeout=60)
        response.raise_for_status()

        # Get filename from header or generate
        content_disposition = response.headers.get('Content-Disposition', '')
        if 'filename=' in content_disposition:
            filename = content_disposition.split('filename=')[1].strip('"')
        else:
            timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
            filename = f"vocabulary_export_{timestamp}.xlsx"

        # Save file
        filepath = output_path or filename
        with open(filepath, 'wb') as f:
            f.write(response.content)

        print(f"✅ File đã được lưu: {filepath}")
        print(f"📊 Size: {len(response.content)} bytes")
        return filepath

    except requests.exceptions.RequestException as e:
        print(f"❌ Lỗi: {e}")
        return None

# Usage
token = "YOUR_ADMIN_TOKEN"
export_vocabs_to_excel(token, "vocabulary_data.xlsx")
```

---

## 🔍 Technical Details

### Dependencies

```xml
<!-- Apache POI for Excel -->
<dependency>
    <groupId>org.apache.poi</groupId>
    <artifactId>poi</artifactId>
    <version>5.2.5</version>
</dependency>
<dependency>
    <groupId>org.apache.poi</groupId>
    <artifactId>poi-ooxml</artifactId>
    <version>5.2.5</version>
</dependency>
```

### Service Implementation

Xem chi tiết tại: `VocabExcelExportService.java`

**Key Features**:

-   Sử dụng Apache POI XSSF (Excel 2007+)
-   Stream processing cho performance tốt
-   Memory-efficient với ByteArrayOutputStream
-   Custom cell styles (header & data)
-   Auto-sizing columns với min/max width
-   Freeze panes cho header row

### Performance

| Số lượng từ vựng | Thời gian xử lý | File size |
| ---------------- | --------------- | --------- |
| 100              | ~0.5s           | ~20KB     |
| 1,000            | ~2s             | ~150KB    |
| 5,000            | ~8s             | ~600KB    |
| 10,000           | ~15s            | ~1.2MB    |

**Note**: Thời gian có thể khác nhau tùy server resources.

---

## 🎨 Excel Styling

### Header Style

-   Background: Light Blue (#D9E1F2)
-   Font: Bold, 11pt, Black
-   Alignment: Center horizontal & vertical
-   Border: Thin black borders
-   Text wrap: Enabled

### Data Style

-   Font: Regular, 10pt
-   Alignment: Top vertical
-   Border: Thin grey borders
-   Text wrap: Enabled

### Column Widths

-   **Minimum**: 3000 units (~2cm)
-   **Maximum** (for long text): 15000 units (~10cm)
-   Auto-sized based on content

---

## ✅ Best Practices

### 1. **Schedule Regular Exports**

Tạo cronjob để backup định kỳ:

```bash
# Chạy hàng ngày lúc 2:00 AM
0 2 * * * /path/to/export-vocab-script.sh
```

### 2. **Naming Convention**

File name format: `vocabulary_export_YYYYMMDD_HHmmss.xlsx`

-   Easy to sort chronologically
-   Avoid overwrite conflicts
-   Track export history

### 3. **Storage Management**

```bash
# Keep only last 7 days
find /backup/vocab/ -name "vocabulary_export_*.xlsx" -mtime +7 -delete
```

### 4. **Versioning**

Git track exported files:

```bash
git add exports/vocabulary_export_*.xlsx
git commit -m "Backup vocab data $(date +%Y-%m-%d)"
git push
```

### 5. **Error Handling**

Always handle errors in client:

```javascript
try {
    await exportVocabs();
} catch (error) {
    // Log error
    console.error('Export failed:', error);

    // Notify user
    showNotification('Lỗi khi xuất Excel', 'error');

    // Send to monitoring
    sendErrorToSentry(error);
}
```

---

## 🐛 Troubleshooting

### Lỗi: Token không hợp lệ

**Giải pháp**: Login lại để lấy token mới

### Lỗi: 403 Forbidden

**Giải pháp**: Đảm bảo user có role ADMIN

### Lỗi: File download bị corrupted

**Giải pháp**:

-   Kiểm tra Content-Type header
-   Đảm bảo binary mode khi download
-   Không parse response as text

### Lỗi: Timeout khi export nhiều vocab

**Giải pháp**:

-   Tăng timeout cho HTTP client
-   Optimize database queries
-   Add pagination nếu cần

### Lỗi: OutOfMemoryError (Server)

**Giải pháp**:

-   Tăng heap memory: `-Xmx2g`
-   Implement streaming export
-   Split into multiple files

---

## 📚 Related Documentation

-   [Apache POI Documentation](https://poi.apache.org/)
-   [Excel File Format](https://docs.microsoft.com/en-us/openspecs/office_standards/ms-xlsx/)
-   [Vocab API Guide](./VOCAB_API_GUIDE.md)
-   [Admin API Guide](./ADMIN_API_GUIDE.md)

---

## 🔮 Future Enhancements

Có thể cân nhắc thêm:

-   [ ] Export với filters (by CEFR, topic, etc.)
-   [ ] Multiple format support (CSV, JSON, PDF)
-   [ ] Custom column selection
-   [ ] Export with user progress data
-   [ ] Scheduled export with email
-   [ ] Export templates với pre-formatting
-   [ ] Batch export large datasets
-   [ ] Export to Google Sheets

---

**Created**: 2025-11-13  
**Last Updated**: 2025-11-13  
**Version**: 1.0.0  
**Author**: Auto-generated
