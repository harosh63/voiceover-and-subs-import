@echo off
chcp 65001 & cls
setlocal enabledelayedexpansion

:: Вопрос пользователю о выборе шаблона сборки
echo Выберите шаблон сборки:
echo 1) mkv + mka + ass
echo 2) mkv + mka
echo 3) mkv + ass
set /p "TEMPLATE=Введите номер шаблона сборки: "

if "%TEMPLATE%"=="1" (
  :: mkv + mka + ass
  set /p "VOICE_FOLDER=Введите имя папки с озвучкой: "
  set /p "VOICE_SUBFOLDER=Введите имя студии-автора озвучки (оставьте пустым, если нет): "
  set /p "SUBS_FOLDER=Введите имя папки с субтитрами: "
  set /p "SUBS_SUBFOLDER=Введите имя студии-автора субтитров (оставьте пустым, если нет): "
  set /p "SUBS_SIGNSFOLDER=Введите имя папки с надписями (оставьте пустым, если нет): "
) else if "%TEMPLATE%"=="2" (
  :: mkv + mka
  set /p "VOICE_FOLDER=Введите имя папки с озвучкой: "
  set /p "VOICE_SUBFOLDER=Введите имя студии-автора озвучки (оставьте пустым, если нет): "
) else if "%TEMPLATE%"=="3" (
  :: mkv + ass
  set /p "SUBS_FOLDER=Введите имя папки с субтитрами: "
  set /p "SUBS_SUBFOLDER=Введите имя студии-автора субтитров (оставьте пустым, если нет): "
  set /p "SUBS_SIGNSFOLDER=Введите имя папки с надписями (оставьте пустым, если нет): "
)

:: Указать путь к утилите mkvtoolnix.exe
set "MKVTOOLNIX=%PROGRAMFILES%\MkvToolNix\mkvmerge.exe"
set "MKVTOOLNIX-x86=%PROGRAMFILES(x86)%\MkvToolNix\mkvmerge.exe"

:: Цикл по всем файлам с расширением .mkv в текущей папке
for %%f in (*.mkv) do (
  :: Указать путь к файлу озвучки
  if "%VOICE_SUBFOLDER%"=="" (
    set "VOICE_FILE=!VOICE_FOLDER!\%%~nf.mka"
  ) else (
    set "VOICE_FILE=!VOICE_FOLDER!\!VOICE_SUBFOLDER!\%%~nf.mka"
  )
  
  :: Указать путь к файлу субтитров
  if "%SUBS_SIGNSFOLDER%"=="" (
    set "SUBS_FILE=!SUBS_FOLDER!\!SUBS_SUBFOLDER!\%%~nf.ass"
  ) else if "%SUBS_SUBFOLDER%"=="" (
    set "SUBS_FILE=!SUBS_FOLDER!\%%~nf.ass"
  ) else (
    set "SUBS_FILE=!SUBS_FOLDER!\!SUBS_SUBFOLDER!\!SUBS_SIGNSFOLDER!\%%~nf.ass"
  )
  
  :: Выбор шаблона сборки
  if "%TEMPLATE%"=="1" (
    :: mkv + mka + ass
    "%MKVTOOLNIX%" --output "Completed\%%~nf_output.mkv" --default-track 0:yes --language 0:rus "!VOICE_FILE!" --default-track 0:yes --language 0:rus "!SUBS_FILE!" --default-track 1:no --default-track 0:yes --language 0:jpn "%%f" --title "%%~nf" --track-order 2:0,1:0,0:0 --disable-track-statistics-tags --no-global-tags
  ) else if "%TEMPLATE%"=="2" (
    :: mkv + mka
    "%MKVTOOLNIX%" --output "Completed\%%~nf_output.mkv" --default-track 0:yes --language 0:rus "!VOICE_FILE!" --default-track 1:no --default-track 0:yes --language 0:jpn "%%f" --title "%%~nf" --track-order 1:0,0:0 --disable-track-statistics-tags --no-global-tags
  ) else if "%TEMPLATE%"=="3" (
    :: mkv + ass
    "%MKVTOOLNIX%" --output "Completed\%%~nf_output.mkv" --default-track 0:yes --language 0:rus "!SUBS_FILE!" --default-track 1:no --default-track 0:yes --language 0:jpn "%%f" --title "%%~nf" --track-order 1:0,0:0 --disable-track-statistics-tags --no-global-tags
  )

  :: Выбор шаблона сборки
  if "%TEMPLATE%"=="1" (
    :: mkv + mka + ass
    "%MKVTOOLNIX-x86%" --output "Completed\%%~nf_output.mkv" --default-track 0:yes --language 0:rus "!VOICE_FILE!" --default-track 0:yes --language 0:rus "!SUBS_FILE!" --default-track 1:no --default-track 0:yes --language 0:jpn "%%f" --title "%%~nf" --track-order 2:0,1:0,0:0 --disable-track-statistics-tags --no-global-tags
  ) else if "%TEMPLATE%"=="2" (
    :: mkv + mka
    "%MKVTOOLNIX-x86%" --output "Completed\%%~nf_output.mkv" --default-track 0:yes --language 0:rus "!VOICE_FILE!" --default-track 1:no --default-track 0:yes --language 0:jpn "%%f" --title "%%~nf" --track-order 1:0,0:0 --disable-track-statistics-tags --no-global-tags
  ) else if "%TEMPLATE%"=="3" (
    :: mkv + ass
    "%MKVTOOLNIX-x86%" --output "Completed\%%~nf_output.mkv" --default-track 0:yes --language 0:rus "!SUBS_FILE!" --default-track 1:no --default-track 0:yes --language 0:jpn "%%f" --title "%%~nf" --track-order 1:0,0:0 --disable-track-statistics-tags --no-global-tags
  )
)
