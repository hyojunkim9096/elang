@echo off
REM 데이터 백업 스크립트 (Windows)

echo 📦 Exporting data from elang_camp database...

mysqldump -u elang -pelang1234 ^
  --no-create-info ^
  --skip-triggers ^
  --complete-insert ^
  elang_camp ^
  site_layout ^
  site_menu ^
  site_banner ^
  content_page ^
  board_category ^
  board_post ^
  > data-backup.sql

echo ✅ Data exported to: data-backup.sql
echo.
echo 📋 To import on another PC:
echo    mysql -u elang -pelang1234 elang_camp ^< data-backup.sql

pause
