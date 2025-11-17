# Hướng Dẫn Lấy Google ID Token Để Test

## Phương Pháp 1: Sử Dụng Google OAuth 2.0 Playground (Khuyến Nghị)

### Bước 1: Truy Cập OAuth Playground

-   Mở trình duyệt và truy cập: https://developers.google.com/oauthplayground/

### Bước 2: Cấu Hình OAuth Client

1. Click vào icon ⚙️ (Settings) ở góc trên bên phải
2. Tích vào checkbox **"Use your own OAuth credentials"**
3. Nhập thông tin Client:
    - **OAuth Client ID**: `YOUR_GOOGLE_CLIENT_ID` (Lấy từ file .env)
    - **OAuth Client secret**: `YOUR_GOOGLE_CLIENT_SECRET` (Lấy từ file .env)
4. Click **Close**

### Bước 3: Chọn Scopes

1. Trong **Step 1: Select & authorize APIs**
2. Tìm và mở rộng **Google OAuth2 API v2**
3. Chọn các scopes sau:
    - `https://www.googleapis.com/auth/userinfo.email`
    - `https://www.googleapis.com/auth/userinfo.profile`
    - `openid`
4. Click button **Authorize APIs**

### Bước 4: Đăng Nhập Google

1. Chọn tài khoản Google của bạn
2. Cho phép quyền truy cập khi được yêu cầu
3. Bạn sẽ được redirect về OAuth Playground

### Bước 5: Exchange Authorization Code

1. Sau khi authorize, bạn sẽ thấy **Step 2: Exchange authorization code for tokens**
2. Click button **Exchange authorization code for tokens**
3. Bạn sẽ nhận được response chứa:
    ```json
    {
        "access_token": "ya29...",
        "expires_in": 3599,
        "refresh_token": "1//...",
        "scope": "openid ...",
        "token_type": "Bearer",
        "id_token": "eyJhbGciOiJSUzI1NiIsImtpZCI6IjU5MmU1NWY3MDUwNTk5Mzk0ODkxYmE1Y2M0MzkyMTE5NjFhNTFiYTUiLCJ0eXAiOiJKV1QifQ..."
    }
    ```

### Bước 6: Copy ID Token

1. Tìm field **`id_token`** trong response
2. Copy toàn bộ giá trị của `id_token` (chuỗi rất dài, bắt đầu với `eyJ...`)
3. Đây chính là **Google ID Token** bạn cần để test API

---

## Phương Pháp 2: Sử Dụng Postman

### Bước 1: Tạo Request Mới

1. Mở Postman
2. Tạo request mới với method **GET**
3. URL: `https://accounts.google.com/o/oauth2/v2/auth`

### Bước 2: Cấu Hình Authorization

1. Chọn tab **Authorization**
2. Type: **OAuth 2.0**
3. Click **Get New Access Token**
4. Nhập thông tin:
    - **Token Name**: Google OAuth Test
    - **Grant Type**: Implicit
    - **Callback URL**: `http://localhost:8080/api/v1/auth/google/callback`
    - **Auth URL**: `https://accounts.google.com/o/oauth2/v2/auth`
    - **Client ID**: `YOUR_GOOGLE_CLIENT_ID` (Lấy từ file .env)
    - **Scope**: `openid email profile`
    - **State**: `random_string`
5. Click **Request Token**
6. Đăng nhập với tài khoản Google
7. Copy **id_token** từ response

---

## Test API Với ID Token

### Sử Dụng PowerShell

```powershell
$idToken = "eyJhbGciOiJSUzI1NiIsImtpZCI6IjU5MmU1NWY3MDUwNTk5Mzk0ODkxYmE1Y2M0MzkyMTE5NjFhNTFiYTUiLCJ0eXAiOiJKV1QifQ..."  # Thay bằng token thực

$body = @{
    idToken = $idToken
} | ConvertTo-Json

Invoke-WebRequest -Uri "http://localhost:8080/api/v1/auth/google" `
    -Method POST `
    -Headers @{
        "Content-Type" = "application/json"
    } `
    -Body $body
```

### Sử Dụng cURL

```bash
curl -X POST http://localhost:8080/api/v1/auth/google \
  -H "Content-Type: application/json" \
  -d '{
    "idToken": "eyJhbGciOiJSUzI1NiIsImtpZCI6IjU5MmU1NWY3MDUwNTk5Mzk0ODkxYmE1Y2M0MzkyMTE5NjFhNTFiYTUiLCJ0eXAiOiJKV1QifQ..."
  }'
```

### Sử Dụng Postman

1. Method: **POST**
2. URL: `http://localhost:8080/api/v1/auth/google`
3. Headers:
    - `Content-Type`: `application/json`
4. Body (raw JSON):
    ```json
    {
        "idToken": "eyJhbGciOiJSUzI1NiIsImtpZCI6IjU5MmU1NWY3MDUwNTk5Mzk0ODkxYmE1Y2M0MzkyMTE5NjFhNTFiYTUiLCJ0eXAiOiJKV1QifQ..."
    }
    ```

---

## Kiểm Tra Logs Sau Khi Test

Sau khi gửi request, kiểm tra Docker logs để xem thông tin debug:

```powershell
docker-compose logs app --tail=50 | Select-String -Pattern "🔍|🔑|📏|📝|Google"
```

Bạn sẽ thấy các log như:

-   🔍 Verifying Google ID token...
-   🔑 Google Client ID configured: 157814544933-...
-   📏 ID Token length: 1234
-   📝 ID Token first 50 chars: eyJhbGci...

---

## Lưu Ý Quan Trọng

⚠️ **ID Token có thời hạn ngắn (thường 1 giờ)**

-   Nếu token hết hạn, bạn cần lấy token mới
-   Token hết hạn sẽ báo lỗi "Token Google không hợp lệ"

⚠️ **Client ID phải khớp**

-   Token được tạo cho Client ID nào thì phải verify với Client ID đó
-   Đảm bảo Client ID trong application.yml khớp với Client ID dùng để tạo token

⚠️ **Token phải nguyên vẹn**

-   Không được cắt bớt hoặc thêm ký tự
-   Không được có khoảng trắng hoặc line breaks
-   Copy toàn bộ chuỗi từ đầu đến cuối

---

## Troubleshooting

### Lỗi: "Token Google không đúng định dạng"

-   Token bị cắt hoặc không đầy đủ
-   Token có chứa ký tự đặc biệt không mong muốn
-   Kiểm tra lại copy/paste

### Lỗi: "Token Google không hợp lệ"

-   Token đã hết hạn
-   Client ID không khớp
-   Token không được tạo từ Google OAuth
-   Token đã được sử dụng hoặc bị revoke

### Lỗi: "Redirect URI mismatch"

-   Redirect URI trong Google Console không khớp với request
-   Thêm URI vào Google Console: https://console.cloud.google.com/

---

## Tham Khảo

-   Google OAuth 2.0 Playground: https://developers.google.com/oauthplayground/
-   Google Identity Documentation: https://developers.google.com/identity/protocols/oauth2
-   JWT Decoder (để xem nội dung token): https://jwt.io/
