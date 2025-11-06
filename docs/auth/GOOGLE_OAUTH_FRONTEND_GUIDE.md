# Hướng dẫn tích hợp Google OAuth2 cho Frontend

## Tổng quan

## Luồng hoạt động

```
┌─────────┐         ┌──────────┐         ┌─────────────┐         ┌─────────┐
│ Frontend│         │  Google  │         │   Backend   │         │Database │
└────┬────┘         └─────┬────┘         └──────┬──────┘         └────┬────┘
     │                    │                     │                      │
     │ 1. User click      │                     │                      │
     │    "Login Google"  │                     │                      │
     ├────────────────────>                     │                      │
     │                    │                     │                      │
     │ 2. Show Google     │                     │                      │
     │    Login Popup     │                     │                      │
     <────────────────────┤                     │                      │
     │                    │                     │                      │
     │ 3. User login &    │                     │                      │
     │    authorize       │                     │                      │
     ├───────────────────>│                     │                      │
     │                    │                     │                      │
     │ 4. Return ID Token │                     │                      │
     <───────────────────┤│                     │                      │
     │                    │                     │                      │
     │ 5. Send ID Token   │                     │                      │
     │    to backend      │                     │                      │
     ├─────────────────────────────────────────>│                      │
     │                    │                     │                      │
     │                    │ 6. Verify ID Token  │                      │
     │                    <─────────────────────┤                      │
     │                    │                     │                      │
     │                    │ 7. Token valid ✓    │                      │
     │                    ├─────────────────────>                      │
     │                    │                     │                      │
     │                    │                     │ 8. Create/Update User│
     │                    │                     ├─────────────────────>│
     │                    │                     │                      │
     │                    │                     │ 9. User saved        │
     │                    │                     <─────────────────────┤│
     │                    │                     │                      │
     │                    │                     │ 10. Generate JWT     │
     │                    │                     │     (Access + Refresh)│
     │                    │                     │                      │
     │ 11. Return JWT +   │                     │                      │
     │     User Info      │                     │                      │
     <─────────────────────────────────────────┤│                      │
     │                    │                     │                      │
     │ 12. Save JWT &     │                     │                      │
     │     redirect       │                     │                      │
     │                    │                     │                      │
```

## 🔧 API Backend hiện có

### Endpoint

```
POST /api/v1/auth/google
Content-Type: application/json
```

### Request Body

```json
{
    "idToken": "eyJhbGciOiJSUzI1NiIsImtpZCI6IjU5N..."
}
```

### Response Success (200 OK)

```json
{
    "status": "success",
    "message": "Đăng nhập Google thành công",
    "data": {
        "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
        "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
        "tokenType": "Bearer",
        "expiresIn": 86400,
        "isNewUser": false,
        "user": {
            "id": "123",
            "email": "user@gmail.com",
            "firstName": "Nguyen",
            "lastName": "Van A",
            "avatar": "https://lh3.googleusercontent.com/...",
            "currentLevel": "A1"
        }
    }
}
```

### Response Error (400/401)

```json
{
    "status": "error",
    "message": "Xác thực Google thất bại: Token Google không hợp lệ",
    "data": null
}
```

## Testing

### Test với Postman/Thunder Client:

1. Lấy ID Token từ Google:

    - Vào: https://developers.google.com/oauthplayground/
    - Chọn: Google OAuth2 API v2
    - Authorize APIs
    - Exchange authorization code for tokens
    - Copy `id_token`

2. Test API:

```bash
curl -X POST http://localhost:8080/api/v1/auth/google \
  -H "Content-Type: application/json" \
  -d '{"idToken": "YOUR_ID_TOKEN_HERE"}'
```

---

## Tổng kết

### Backend ✓

-   API `/api/v1/auth/google` sẵn sàng
-   Verify ID Token tự động
-   Tạo user mới hoặc login user cũ
-   Trả về JWT tokens (access + refresh)
-   Xử lý avatar, email, tên từ Google
-   Tự động active user (không cần verify email)

### Frontend cần làm:

1. Tích hợp Google Sign-In button
2. Lấy ID Token từ Google
3. Gửi ID Token đến API `/api/v1/auth/google`
4. Lưu accessToken và refreshToken
5. Redirect user sau khi login thành công
6. Sử dụng accessToken cho các API calls tiếp theo
