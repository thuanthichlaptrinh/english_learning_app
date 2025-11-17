# 🔐 Hướng Dẫn Chi Tiết Google OAuth2 - Card Words

## 📋 Mục Lục

1. [Google OAuth2 là gì?](#1-google-oauth2-là-gì)
2. [Cách hoạt động](#2-cách-hoạt-động)
3. [Vấn đề hiện tại](#3-vấn-đề-hiện-tại)
4. [Giải pháp](#4-giải-pháp)
5. [Hướng dẫn cấu hình đầy đủ](#5-hướng-dẫn-cấu-hình-đầy-đủ)

---

## 1. Google OAuth2 là gì?

**OAuth2** là một giao thức cho phép ứng dụng của bạn xác thực người dùng thông qua tài khoản Google mà **không cần lưu trữ mật khẩu** của họ.

### Lợi ích:

-   ✅ Đăng nhập nhanh chóng (1 click)
-   ✅ An toàn hơn (Google xử lý bảo mật)
-   ✅ Lấy thông tin user từ Google (email, tên, avatar)
-   ✅ User không cần tạo mật khẩu mới

---

## 2. Cách Hoạt động

```
┌──────────┐      ┌─────────────┐      ┌──────────────┐      ┌──────────┐
│ Frontend │─────▶│   Google    │─────▶│   Backend    │─────▶│ Database │
│  (React) │      │OAuth Server │      │(Spring Boot) │      │(Postgres)│
└──────────┘      └─────────────┘      └──────────────┘      └──────────┘
     │                    │                     │                    │
     │ 1. Click login     │                     │                    │
     │───────────────────▶│                     │                    │
     │                    │                     │                    │
     │ 2. Google login    │                     │                    │
     │◀───────────────────│                     │                    │
     │                    │                     │                    │
     │ 3. User đăng nhập  │                     │                    │
     │───────────────────▶│                     │                    │
     │                    │                     │                    │
     │ 4. Nhận id_token   │                     │                    │
     │◀───────────────────│                     │                    │
     │                    │                     │                    │
     │ 5. POST /auth/google với id_token        │                    │
     │──────────────────────────────────────────▶│                    │
     │                    │                     │                    │
     │                    │ 6. Verify token     │                    │
     │                    │◀────────────────────│                    │
     │                    │                     │                    │
     │                    │ 7. Token OK!        │                    │
     │                    │─────────────────────▶│                    │
     │                    │                     │                    │
     │                    │                     │ 8. Tạo/Update user │
     │                    │                     │───────────────────▶│
     │                    │                     │                    │
     │                    │                     │ 9. User info       │
     │                    │                     │◀───────────────────│
     │                    │                     │                    │
     │ 10. Trả về JWT token (accessToken)       │                    │
     │◀──────────────────────────────────────────│                    │
```

### Chi tiết các bước:

**Bước 1-4: Frontend lấy id_token từ Google**

-   Frontend sử dụng Google Sign-In SDK
-   User đăng nhập với tài khoản Google
-   Google trả về `id_token` (JWT token do Google ký)

**Bước 5: Frontend gửi id_token đến Backend**

```javascript
// Frontend code example
const response = await fetch('/api/v1/auth/google', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ idToken: googleIdToken }),
});
```

**Bước 6-7: Backend verify id_token**

```java
// Backend code
GoogleIdTokenVerifier verifier = new GoogleIdTokenVerifier.Builder(
    new NetHttpTransport(), JSON_FACTORY)
    .setAudience(Collections.singletonList(googleClientId))  // ← QUAN TRỌNG!
    .build();

GoogleIdToken token = verifier.verify(idToken);  // ← Verify với Google
```

**Bước 8-9: Tạo hoặc cập nhật user**

-   Nếu email chưa tồn tại → Tạo user mới
-   Nếu đã tồn tại → Cập nhật thông tin (tên, avatar)

**Bước 10: Trả về JWT token của hệ thống**

-   Backend tạo JWT token riêng của hệ thống
-   Frontend dùng token này cho các request sau

---

## 3. Vấn đề Hiện Tại

### 🔴 Lỗi: "Token Google không hợp lệ"

**Nguyên nhân:** Token được tạo từ một **Google Client ID** khác với Client ID mà backend đang cấu hình.

### Phân tích:

**Token bạn đang dùng có audience (aud):**

```
47787726040-cdt0gqfs72hhdu4bs5mv0qs9hai9trr2.apps.googleusercontent.com
```

**Backend đang config Client ID:**

```
157814544933-v1gn4l8k6jkvn20j45ps885s28slsg66.apps.googleusercontent.com
```

### Giải thích về `audience (aud)`:

Khi Google tạo `id_token`, nó nhúng vào token một trường `aud` (audience) - đây chính là **Client ID** của ứng dụng mà token được tạo cho.

Khi backend verify token, `GoogleIdTokenVerifier` sẽ kiểm tra:

```java
if (token.aud != googleClientId) {
    return null;  // Token không hợp lệ
}
```

**→ Đó là lý do token của bạn bị reject!**

---

## 4. Giải Pháp

### ✅ Giải pháp đúng: Cập nhật Client ID trong backend

**Bước 1: Cập nhật file `.env`**

Thay đổi `GOOGLE_OAUTH_CLIENT_ID` từ:

```env
GOOGLE_OAUTH_CLIENT_ID=157814544933-v1gn4l8k6jkvn20j45ps885s28slsg66.apps.googleusercontent.com
```

Thành:

```env
GOOGLE_OAUTH_CLIENT_ID=47787726040-cdt0gqfs72hhdu4bs5mv0qs9hai9trr2.apps.googleusercontent.com
```

**Bước 2: Lấy Client Secret từ Google Cloud Console**

1. Vào [Google Cloud Console](https://console.cloud.google.com/)
2. Chọn project của bạn
3. Vào **APIs & Services** → **Credentials**
4. Click vào Client ID: `47787726040-cdt0gqfs72hhdu4bs5mv0qs9hai9trr2`
5. Copy **Client Secret** (nút copy bên cạnh giá trị \*\*\*\*xd7p)
6. Cập nhật vào `.env`:

```env
GOOGLE_OAUTH_CLIENT_SECRET=GOCSPX-xxxxxxxxxxxxxxxxxxxx
```

**Bước 3: Cập nhật file `.env.docker`** (nếu deploy bằng Docker)

Làm tương tự như bước 1-2 cho file `.env.docker`

**Bước 4: Restart application**

```bash
# Nếu chạy local
./mvnw spring-boot:run

# Nếu dùng Docker
docker-compose down
docker-compose up -d --build
```

**Bước 5: Test lại**

```powershell
# Chạy script test
.\test-real-google-token.ps1
```

---

## 5. Hướng Dẫn Cấu Hình Đầy Đủ

### 📝 A. Tạo Google OAuth Client (Nếu chưa có)

**Bước 1: Vào Google Cloud Console**

-   Truy cập: https://console.cloud.google.com/
-   Đăng nhập với tài khoản Google

**Bước 2: Tạo hoặc chọn Project**

```
APIs & Services → Credentials → CREATE CREDENTIALS → OAuth client ID
```

**Bước 3: Cấu hình OAuth consent screen**

-   User Type: External (cho phép bất kỳ ai đăng nhập)
-   App name: Card Words
-   User support email: your-email@gmail.com
-   Developer contact: your-email@gmail.com
-   Add scopes:
    -   `userinfo.email`
    -   `userinfo.profile`
    -   `openid`

**Bước 4: Tạo OAuth Client ID**

-   Application type: **Web application**
-   Name: `Spring boot` (hoặc tên bạn muốn)

**Bước 5: Cấu hình Authorized Origins & Redirect URIs**

**Authorized JavaScript origins:**

```
http://localhost:4300      # Frontend development
http://localhost:3000      # Alternative frontend port
https://yourdomain.com     # Production frontend
```

**Authorized redirect URIs:**

```
http://localhost:8080/api/v1/auth/google/callback    # Backend callback
http://localhost:4300                                 # Frontend
```

**Bước 6: Lưu Client ID và Client Secret**

-   Copy **Client ID**: `47787726040-xxxx...`
-   Copy **Client Secret**: `GOCSPX-xxxx...`

### 🔧 B. Cấu hình Backend (Spring Boot)

**File: `.env`**

```env
# Google OAuth2 Configuration
GOOGLE_OAUTH_CLIENT_ID=47787726040-cdt0gqfs72hhdu4bs5mv0qs9hai9trr2.apps.googleusercontent.com
GOOGLE_OAUTH_CLIENT_SECRET=GOCSPX-xxxxxxxxxxxxxxxxxxxx
GOOGLE_OAUTH_REDIRECT_URI=http://localhost:8080/api/v1/auth/google/callback
```

**File: `application.yml`** (đã có sẵn)

```yaml
google:
    oauth2:
        client-id: ${GOOGLE_OAUTH_CLIENT_ID}
        client-secret: ${GOOGLE_OAUTH_CLIENT_SECRET}
        redirect-uri: ${GOOGLE_OAUTH_REDIRECT_URI}
```

**File: `GoogleOAuth2Service.java`** (đã có sẵn)

```java
@Value("${google.oauth2.client-id}")
private String googleClientId;

private GoogleIdToken.Payload verifyGoogleToken(String idToken) {
    GoogleIdTokenVerifier verifier = new GoogleIdTokenVerifier.Builder(
        new NetHttpTransport(), JSON_FACTORY)
        .setAudience(Collections.singletonList(googleClientId))  // ← Đọc từ config
        .build();

    GoogleIdToken token = verifier.verify(idToken);
    return token.getPayload();
}
```

### 🎨 C. Cấu hình Frontend

**1. Cài đặt Google SDK**

```bash
npm install @react-oauth/google
```

**2. Wrap app với GoogleOAuthProvider**

```jsx
// main.jsx hoặc App.jsx
import { GoogleOAuthProvider } from '@react-oauth/google';

const GOOGLE_CLIENT_ID = '47787726040-cdt0gqfs72hhdu4bs5mv0qs9hai9trr2.apps.googleusercontent.com';

function App() {
    return (
        <GoogleOAuthProvider clientId={GOOGLE_CLIENT_ID}>
            <YourAppComponents />
        </GoogleOAuthProvider>
    );
}
```

**3. Thêm Google Login Button**

```jsx
import { GoogleLogin } from '@react-oauth/google';

function LoginPage() {
    const handleGoogleSuccess = async (credentialResponse) => {
        const idToken = credentialResponse.credential; // ← Đây là id_token

        // Gửi đến backend
        const response = await fetch('http://localhost:8080/api/v1/auth/google', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ idToken }),
        });

        const data = await response.json();

        if (response.ok) {
            // Lưu accessToken và refreshToken
            localStorage.setItem('accessToken', data.accessToken);
            localStorage.setItem('refreshToken', data.refreshToken);

            // Redirect to home
            window.location.href = '/home';
        }
    };

    return <GoogleLogin onSuccess={handleGoogleSuccess} onError={() => console.error('Login Failed')} />;
}
```

### 📊 D. Decode và Debug Token

**Để hiểu rõ token của bạn, dùng script này:**

```powershell
# decode-jwt.ps1
$idToken = "eyJhbGci..."  # Token của bạn

$parts = $idToken -split '\.'
$payload = $parts[1]

# Thêm padding
while ($payload.Length % 4 -ne 0) {
    $payload += "="
}

$decodedBytes = [System.Convert]::FromBase64String($payload)
$decodedJson = [System.Text.Encoding]::UTF8.GetString($decodedBytes)
$payloadObj = $decodedJson | ConvertFrom-Json

Write-Host "📋 Token Information:" -ForegroundColor Cyan
$payloadObj | ConvertTo-Json -Depth 10
```

**Output sẽ hiển thị:**

```json
{
  "iss": "https://accounts.google.com",
  "azp": "47787726040-cdt0gqfs72hhdu4bs5mv0qs9hai9trr2...",
  "aud": "47787726040-cdt0gqfs72hhdu4bs5mv0qs9hai9trr2...",  ← QUAN TRỌNG!
  "sub": "106466294849005994435",
  "email": "thuanxinhtrai63@gmail.com",
  "email_verified": true,
  "name": "Ngô Minh Thuận",
  "picture": "https://...",
  "given_name": "Ngô Minh Thuận",
  "iat": 1762970054,
  "exp": 1762973654
}
```

**Kiểm tra:**

-   `aud` (audience) phải **TRÙNG KHỚP** với `GOOGLE_OAUTH_CLIENT_ID` trong backend
-   `exp` (expiration) phải > thời gian hiện tại (token chưa hết hạn)
-   `iss` phải là `https://accounts.google.com`

---

## 6. Troubleshooting

### ❌ Lỗi: "Token Google không hợp lệ"

**Nguyên nhân phổ biến:**

1. ✅ **Client ID không khớp** (đây là lỗi của bạn)
2. Token đã hết hạn (`exp` < thời gian hiện tại)
3. Token không đúng định dạng JWT
4. Network issues khi verify với Google

**Giải pháp:**

```powershell
# Kiểm tra Client ID trong backend
docker-compose exec app env | Select-String -Pattern "GOOGLE"

# Kiểm tra token audience
# Dùng script decode-jwt.ps1 ở trên

# So sánh:
# token.aud == GOOGLE_OAUTH_CLIENT_ID  ← Phải bằng nhau!
```

### ❌ Lỗi: CORS

**Nguyên nhân:** Frontend domain không được phép gọi backend

**Giải pháp:**

```java
// CorsConfig.java (đã có sẵn)
@Configuration
public class CorsConfig implements WebMvcConfigurer {
    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/**")
            .allowedOrigins("http://localhost:4300", "http://localhost:3000")
            .allowedMethods("*");
    }
}
```

### ❌ Lỗi: "redirect_uri_mismatch"

**Nguyên nhân:** Redirect URI không khớp với Google Cloud Console

**Giải pháp:**

1. Vào Google Cloud Console → Credentials
2. Thêm chính xác URL của frontend vào **Authorized redirect URIs**

---

## 7. Testing

### 🧪 Test Script

```powershell
# test-google-oauth.ps1
$idToken = "eyJhbGci..."  # Token từ Google OAuth Playground hoặc frontend

$response = Invoke-WebRequest `
    -Uri "http://localhost:8080/api/v1/auth/google" `
    -Method POST `
    -Headers @{"Content-Type" = "application/json"} `
    -Body (@{idToken = $idToken} | ConvertTo-Json)

$response.Content | ConvertFrom-Json | ConvertTo-Json -Depth 10
```

**Expected Success Response:**

```json
{
    "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "tokenType": "Bearer",
    "expiresIn": 86400,
    "isNewUser": true,
    "user": {
        "id": "1",
        "email": "thuanxinhtrai63@gmail.com",
        "firstName": "Ngô",
        "lastName": "Minh Thuận",
        "avatar": "https://lh3.googleusercontent.com/...",
        "currentLevel": "A1"
    }
}
```

---

## 8. Production Deployment

### 🚀 Chuẩn bị deploy

**1. Cập nhật Authorized Origins trong Google Console:**

```
https://api.yourdomain.com      # Backend domain
https://yourdomain.com           # Frontend domain
```

**2. Cập nhật environment variables:**

```env
# Production .env
GOOGLE_OAUTH_CLIENT_ID=47787726040-cdt0gqfs72hhdu4bs5mv0qs9hai9trr2.apps.googleusercontent.com
GOOGLE_OAUTH_CLIENT_SECRET=GOCSPX-xxxx  # Lấy từ Google Console
GOOGLE_OAUTH_REDIRECT_URI=https://api.yourdomain.com/api/v1/auth/google/callback
```

**3. Cập nhật frontend:**

```jsx
const GOOGLE_CLIENT_ID = import.meta.env.VITE_GOOGLE_CLIENT_ID; // Production Client ID
```

---

## 📚 Tài Liệu Tham Khảo

-   [Google Identity Documentation](https://developers.google.com/identity)
-   [OAuth 2.0 Guide](https://developers.google.com/identity/protocols/oauth2)
-   [Google Sign-In for Websites](https://developers.google.com/identity/sign-in/web)
-   [JWT.io](https://jwt.io) - Decode và debug JWT tokens

---

## ✅ Checklist Hoàn Thành

-   [ ] Tạo Google OAuth Client trong Cloud Console
-   [ ] Cấu hình Authorized Origins và Redirect URIs
-   [ ] Cập nhật Client ID trong `.env` backend
-   [ ] Cập nhật Client Secret trong `.env` backend
-   [ ] Cấu hình frontend với Google SDK
-   [ ] Test đăng nhập thành công
-   [ ] Verify token audience khớp với backend
-   [ ] Deploy production với domain thật

---

**Created:** 2025-11-13  
**Last Updated:** 2025-11-13  
**Author:** AI Assistant  
**Project:** Card Words - English Learning Platform
