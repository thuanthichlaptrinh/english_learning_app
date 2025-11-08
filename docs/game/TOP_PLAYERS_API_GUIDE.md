# 🏆 API Top Players - Tài Liệu Hướng Dẫn

## 📋 Tổng Quan

API trả về **top 10 người chơi** có điểm cao nhất từ **cả 3 tựa game**:
- 🎯 **Quick Quiz** (Quick Reflex Quiz)
- 🖼️ **Image Matching** 
- 📖 **Word Definition Matching**

---

## 🔗 Endpoint

### **GET `/api/v1/leaderboard/top-players`**

**Mô tả:** Lấy top 10 người chơi có điểm cao nhất từ cả 3 tựa game

**Authentication:** Không yêu cầu (Public API)

**Response Type:** `application/json`

---

## 📤 Response Format

```json
{
  "quickQuizTop10": [
    {
      "rank": 1,
      "userName": "Nguyễn Văn A",
      "avatar": "https://...",
      "totalScore": 9500
    },
    {
      "rank": 2,
      "userName": "Trần Thị B",
      "avatar": "https://...",
      "totalScore": 9200
    }
    // ... 8 players more
  ],
  "imageMatchingTop10": [
    {
      "rank": 1,
      "userName": "Lê Văn C",
      "avatar": "https://...",
      "totalScore": 8800
    }
    // ... 9 players more
  ],
  "wordDefinitionTop10": [
    {
      "rank": 1,
      "userName": "Phạm Thị D",
      "avatar": "https://...",
      "totalScore": 8500
    }
    // ... 9 players more
  ],
  "totalActivePlayers": 150,
  "cacheExpirySeconds": 300
}
```

---

## 📊 Response Fields

### **Top Level Fields**

| Field | Type | Description |
|-------|------|-------------|
| `quickQuizTop10` | `LeaderboardEntry[]` | Top 10 Quick Quiz players |
| `imageMatchingTop10` | `LeaderboardEntry[]` | Top 10 Image Matching players |
| `wordDefinitionTop10` | `LeaderboardEntry[]` | Top 10 Word Definition players |
| `totalActivePlayers` | `Integer` | Tổng số người chơi đã tham gia ít nhất 1 game |
| `cacheExpirySeconds` | `Integer` | Thời gian cache (giây), mặc định 300 (5 phút) |

### **LeaderboardEntry Object**

| Field | Type | Description |
|-------|------|-------------|
| `rank` | `Integer` | Xếp hạng (1-10) |
| `userName` | `String` | Tên người chơi |
| `avatar` | `String` | URL avatar của người chơi |
| `totalScore` | `Integer` | Tổng điểm |

---

## 💡 Ví Dụ Sử Dụng

### **cURL**

```bash
curl -X GET "http://localhost:8080/api/v1/leaderboard/top-players" \
  -H "Accept: application/json"
```

### **JavaScript (Fetch API)**

```javascript
fetch('http://localhost:8080/api/v1/leaderboard/top-players')
  .then(response => response.json())
  .then(data => {
    console.log('Quick Quiz Top 10:', data.quickQuizTop10);
    console.log('Image Matching Top 10:', data.imageMatchingTop10);
    console.log('Word Definition Top 10:', data.wordDefinitionTop10);
    console.log('Total Active Players:', data.totalActivePlayers);
  })
  .catch(error => console.error('Error:', error));
```

### **Python (requests)**

```python
import requests

response = requests.get('http://localhost:8080/api/v1/leaderboard/top-players')
data = response.json()

print(f"Quick Quiz Top 10: {len(data['quickQuizTop10'])} players")
print(f"Image Matching Top 10: {len(data['imageMatchingTop10'])} players")
print(f"Word Definition Top 10: {len(data['wordDefinitionTop10'])} players")
print(f"Total Active Players: {data['totalActivePlayers']}")
```

---

## 🔄 Cache Strategy

- **Cache Duration:** 5 phút (300 giây)
- **Cache Storage:** Redis
- **Cache Keys:**
  - `leaderboard:quiz:global`
  - `leaderboard:image-matching`
  - `leaderboard:word-definition`

**Lý do cache:**
- Giảm tải database
- Tăng tốc độ response
- Dữ liệu leaderboard không cần real-time tuyệt đối

---

## 🎯 Use Cases

### **1. Trang Dashboard**
Hiển thị top players của cả 3 game trong 1 trang duy nhất.

### **2. Màn Hình Chờ**
Hiển thị leaderboard trong khi người chơi đợi trận đấu.

### **3. Social Features**
So sánh thành tích của người chơi với top players.

### **4. Analytics**
Theo dõi số lượng người chơi active (`totalActivePlayers`).

---

## ⚠️ Lưu Ý

### **Empty Results**
Nếu chưa có người chơi nào, các array sẽ rỗng:
```json
{
  "quickQuizTop10": [],
  "imageMatchingTop10": [],
  "wordDefinitionTop10": [],
  "totalActivePlayers": 0,
  "cacheExpirySeconds": 300
}
```

### **Less Than 10 Players**
Nếu có ít hơn 10 người chơi, array sẽ chứa đúng số người thực tế:
```json
{
  "quickQuizTop10": [
    {"rank": 1, "userName": "Player 1", "totalScore": 1000},
    {"rank": 2, "userName": "Player 2", "totalScore": 800}
  ],
  // ... only 2 players
}
```

### **Same Score Handling**
- Nếu 2 người có cùng điểm, người chơi gần đây hơn sẽ được ưu tiên xếp hạng cao hơn
- Redis sorted sets sử dụng lexicographic order cho các phần tử có cùng score

---

## 🔗 Related APIs

- `GET /api/v1/leaderboard/quiz/global` - Top Quick Quiz only
- `GET /api/v1/leaderboard/image-matching` - Top Image Matching only  
- `GET /api/v1/leaderboard/word-definition` - Top Word Definition only
- `GET /api/v1/leaderboard/quiz/my-rank` - Xếp hạng cá nhân

---

## 📝 Testing

### **Test với Swagger UI**
1. Truy cập: http://localhost:8080/swagger-ui/index.html
2. Tìm section **"Leaderboard"**
3. Chọn endpoint `GET /api/v1/leaderboard/top-players`
4. Click **"Try it out"** → **"Execute"**

### **Expected Status Codes**
- `200 OK` - Success
- `500 Internal Server Error` - Server error

---

## 🎨 Frontend Integration Example

### **React Component**

```jsx
import React, { useEffect, useState } from 'react';

function TopPlayersBoard() {
  const [topPlayers, setTopPlayers] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetch('http://localhost:8080/api/v1/leaderboard/top-players')
      .then(res => res.json())
      .then(data => {
        setTopPlayers(data);
        setLoading(false);
      })
      .catch(err => {
        console.error('Error loading top players:', err);
        setLoading(false);
      });
  }, []);

  if (loading) return <div>Loading...</div>;

  return (
    <div className="top-players-container">
      <h1>🏆 Top Players</h1>
      
      <section>
        <h2>🎯 Quick Quiz</h2>
        <ul>
          {topPlayers?.quickQuizTop10.map(player => (
            <li key={player.rank}>
              #{player.rank} {player.userName} - {player.totalScore} pts
            </li>
          ))}
        </ul>
      </section>

      <section>
        <h2>🖼️ Image Matching</h2>
        <ul>
          {topPlayers?.imageMatchingTop10.map(player => (
            <li key={player.rank}>
              #{player.rank} {player.userName} - {player.totalScore} pts
            </li>
          ))}
        </ul>
      </section>

      <section>
        <h2>📖 Word Definition</h2>
        <ul>
          {topPlayers?.wordDefinitionTop10.map(player => (
            <li key={player.rank}>
              #{player.rank} {player.userName} - {player.totalScore} pts
            </li>
          ))}
        </ul>
      </section>

      <footer>
        Total Active Players: {topPlayers?.totalActivePlayers}
      </footer>
    </div>
  );
}

export default TopPlayersBoard;
```

---

## 🚀 Performance

### **Response Time**
- **With Cache:** ~50-100ms
- **Without Cache:** ~200-500ms

### **Optimization Tips**
1. Cache response ở frontend (5 phút)
2. Sử dụng pagination nếu cần > 10 players
3. Load avatar lazy (chỉ load khi scroll)
4. Sử dụng CDN cho avatar images

---

## 📚 Documentation

- **Swagger UI:** http://localhost:8080/swagger-ui/index.html
- **API Docs:** http://localhost:8080/v3/api-docs
- **Source Code:** `LeaderboardController.java` → `getTopPlayersAllGames()`
