@echo off
echo ============================================
echo   MSFilesA - Instalacao para Windows
echo ============================================
echo.

:: Verificar se Node.js esta instalado
where node >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo [ERRO] Node.js nao encontrado!
    echo Por favor, instale o Node.js em: https://nodejs.org/
    pause
    exit /b 1
)

:: Verificar se Python esta instalado
where python >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo [ERRO] Python nao encontrado!
    echo Por favor, instale o Python em: https://python.org/
    pause
    exit /b 1
)

echo [OK] Node.js encontrado
node --version

echo [OK] Python encontrado
python --version

echo.
echo Instalando dependencias Node.js...
call npm install

echo.
echo Instalando dependencias Python...
pip install python-docx reportlab openpyxl python-pptx PyPDF2

echo.
echo ============================================
echo   Instalacao concluida com sucesso!
echo ============================================
echo.
echo Para usar com Claude Code, execute:
echo   claude
echo.
pause
