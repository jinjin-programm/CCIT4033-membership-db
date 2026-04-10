# 簡報大綱

## 投影片 1：標題
- 會員資料庫系統
- 課程：Introduction to Database Systems / 資料庫系統概論
- 組員名稱

## 投影片 2：專題背景
- 為什麼要做這個系統
- 解決什麼問題
- 主要使用者：admin 與 member

## 投影片 3：系統總覽
- 會員管理
- 繳費管理
- 活動管理
- 活動報名
- 報表查詢

## 投影片 4：資料庫結構
- `Member`
- `Payment`
- `SportsEvent`
- `EventRegistration`
- `Admin`

## 投影片 5：關聯關係
- member 對 payment 是一對多
- member 對 event registration 是一對多
- sports event 對 event registration 是一對多

## 投影片 6：Constraint
- `NOT NULL`
- `CHECK`
- `UNIQUE`
- `FOREIGN KEY`

## 投影片 7：為什麼使用 Trigger
- 繳費後自動變 Active
- 非 Active 會員不能報名
- 不能報名過期活動
- 不能新增未來日期繳費

## 投影片 8：Views 與報表
- `vw_MemberList`
- `vw_MembershipStatus`
- `vw_PaymentReport`
- `vw_EventList`
- `vw_EventRegistrationReport`

## 投影片 9：工作流程示範
- 新增會員
- 新增繳費
- 報名活動
- 查看報表

## 投影片 10：測試
- Python 測試腳本用於自動化測試
- 另外也新增純 SQL 測試腳本
- 測試包含 validation、trigger、cascade、views

## 投影片 11：優點
- 資料一致性高
- 規則自動化
- 報表簡潔
- 很適合資料庫課程學習

## 投影片 12：結論
- tables 負責存資料
- constraints 負責保護資料
- triggers 負責自動化規則
- views 負責顯示結果
