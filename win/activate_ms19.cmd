@echo off
title Activate Microsoft Office 2019 ALL versions for FREE!&cls&echo ============================================================================&echo #Project: Activating Microsoft software products for FREE without software&echo ============================================================================&echo.&echo #Supported products:&echo - Microsoft Office Standard 2019&echo - Microsoft Office Professional Plus 2019&echo.&echo.&(if exist "%ProgramFiles%\Microsoft Office\Office16\ospp.vbs" cd /d "%ProgramFiles%\Microsoft Office\Office16")&(if exist "%ProgramFiles(x86)%\Microsoft Office\Office16\ospp.vbs" cd /d "%ProgramFiles(x86)%\Microsoft Office\Office16")&(for /f %%x in ('dir /b ..\root\Licenses16\ProPlus2019VL*.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses16\%%x" >nul)&(for /f %%x in ('dir /b ..\root\Licenses16\ProPlus2019VL*.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses16\%%x" >nul)&echo.&echo ============================================================================&echo Activating your Office...&cscript //nologo slmgr.vbs /ckms >nul&cscript //nologo ospp.vbs /setprt:1688 >nul&cscript //nologo ospp.vbs /unpkey:6MWKP >nul&cscript //nologo ospp.vbs /inpkey:NMMKJ-6RK4F-KMJVX-8D9MJ-6MWKP >nul&set i=1

:server
if %i%==1 set KMS_Sev=kms7.MSGuides.com 
if %i%==2 set KMS_Sev=kms8.MSGuides.com 
if %i%==3 set KMS_Sev=kms9.MSGuides.com 
if %i%==4 set KMS_Sev=kms.ddns.net
if %i%==5 set KMS_Sev=kms.ddz.red
if %i%==6 set KMS_Sev=kms.lotro.cc
if %i%==7 set KMS_Sev=hq1.chinancce.com
if %i%==8 set KMS_Sev=kms.loli.beer
if %i%==9 set KMS_Sev=kms.cnlic.com
if %i%==10 goto notsupported

cscript //nologo ospp.vbs /sethst:%KMS_Sev% >nul&echo ============================================================================&echo.&echo.
cscript //nologo ospp.vbs /act | find /i "successful" && exit || (echo The connection to the server failed! Trying to connect to another one... & echo Please wait... & echo. & echo. & set /a i+=1 & goto server)

:notsupported
echo.&echo ============================================================================&echo Sorry! Your version is not supported.

:halt
pause >nul
