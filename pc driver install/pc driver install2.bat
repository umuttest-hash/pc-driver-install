@echo off
echo "Sürücüler güncelleniyor ve eksik sürücüler aranıyor..."

:: 1. Windows Update servisini başlatma
echo "Windows Update servisi başlatılıyor..."
net start wuauserv

:: 2. Windows Update aracını çalıştırarak sürücüleri güncelleme
echo "Windows Update ile sürücüler aranıyor..."
start /wait wuauclt /detectnow

:: 3. Yüklü sürücüleri listeleme
echo "Yüklü sürücüler listeleniyor..."
driverquery > "C:\yüklü_sürücüler.txt"

:: 4. Windows Update için cmd komutları ile sürücü yükleme
echo "Windows Update ile sürücüler yükleniyor..."
start /wait wuauclt /updatenow

:: 5. Manuel sürücü yüklemesi başlatma
echo "Manuel sürücü yüklemesi başlatılıyor..."
pnputil /scan-devices

:: 6. Eksik sürücüler için Aygıt Yöneticisi'ni açma
echo "Eksik sürücüler için tarama başlatılıyor..."
echo "Eksik sürücüler için Aygıt Yöneticisi'ni kontrol edin."
start devmgmt.msc

:: 7. Windows Update aracını tekrar çalıştırarak sürücüleri kontrol etme
echo "Windows Update tekrar başlatılıyor..."
start /wait wuauclt /detectnow

:: 8. Sürücü güncellemeleri uygulama
echo "Sürücü güncellemeleri uygulanıyor..."
start /wait devcon update "C:\Windows\System32\drivers" *.*

:: 9. NVIDIA sürücüsünü yüklemek isteyip istemediği soruluyor
echo "NVIDIA sürücüsü yüklensin mi? (Evet/Hayır)"
set /p user_choice=Evet veya Hayır yazın: 

:: Kullanıcının yanıtına göre işlem yapılacak
if /i "%user_choice%"=="Evet" (
    echo "NVIDIA sürücüsü yükleniyor..."
    :: NVIDIA sürücüsünün URL'sini belirleyin
    set NVIDIA_DRIVER_URL=https://www.nvidia.com/content/driverdownload-maps/confirm-not-url-here #Bu kısmı doğru indirme URL'si ile değiştirin

    :: İndirme işlemi başlatılıyor
    powershell -Command "Invoke-WebRequest -Uri %NVIDIA_DRIVER_URL% -OutFile C:\nvidia_driver.exe"

    :: İndirilen sürücüyü yükleme
    echo "NVIDIA sürücüsü yükleniyor..."
    start /wait C:\nvidia_driver.exe /silent

    echo "NVIDIA sürücüsü başarıyla yüklendi."
) else (
    echo "NVIDIA sürücüsü yüklenmedi."
)

:: 10. Yeniden başlatma talimatı
echo "İşlem tamamlandı, bilgisayarınızı yeniden başlatın."
pause
