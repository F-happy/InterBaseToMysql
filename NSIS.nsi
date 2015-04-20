; 该脚本使用 HM VNISEdit 脚本编辑器向导产生

; 安装程序初始定义常量
!define PRODUCT_NAME "marcketcloud"
!define PRODUCT_VERSION "5.0"
!define PRODUCT_PUBLISHER "marcketcloud, Inc."
!define PRODUCT_WEB_SITE "http://www.marcketcloud.com.cn"
!define PRODUCT_DIR_REGKEY "Software\Microsoft\Windows\CurrentVersion\App Paths\Firebird_ODBC_2.0.0-Win32.exe"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"

SetCompressor lzma

; ------ MUI 现代界面定义 (1.67 版本以上兼容) ------
!include "MUI.nsh"

; MUI 预定义常量
!define MUI_ABORTWARNING
!define MUI_ICON "ico.ico"
!define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\modern-uninstall.ico"

; 欢迎页面
!insertmacro MUI_PAGE_WELCOME
; 许可协议页面
!insertmacro MUI_PAGE_LICENSE "shuoming.txt"
; 安装目录选择页面
!insertmacro MUI_PAGE_DIRECTORY
; 安装过程页面
!insertmacro MUI_PAGE_INSTFILES
; 安装完成页面
!insertmacro MUI_PAGE_FINISH

; 安装卸载过程页面
!insertmacro MUI_UNPAGE_INSTFILES

; 安装界面包含的语言设置
!insertmacro MUI_LANGUAGE "SimpChinese"

; 安装预释放文件
!insertmacro MUI_RESERVEFILE_INSTALLOPTIONS
; ------ MUI 现代界面定义结束 ------

Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
OutFile "marcketcloud.exe"
InstallDir "$PROGRAMFILES\marcketcloud"
InstallDirRegKey HKLM "${PRODUCT_UNINST_KEY}" "UninstallString"
ShowInstDetails show
ShowUnInstDetails show
BrandingText "marcketcloud"

Section "marcketcloud" SEC01
  SetOutPath "$INSTDIR"
  SetOverwrite ifnewer
  File "inputdb.py"
  CreateDirectory "$SMPROGRAMS\marcketcloud"
  CreateShortCut "$SMPROGRAMS\marcketcloud\marcketcloud.lnk" "$INSTDIR\inputdb.py"
  CreateShortCut "$DESKTOP\MarcketCloud.lnk" "$INSTDIR\inputdb.py" "" "$INSTDIR\ico.ico"
  File "ico.ico"
  File "Firebird_ODBC_2.0.0-Win32.exe"
  File "odbc.ini"
  File "remote.ini"
  File "remote2.ini"
  File "new\Python27.exe"
  File "new\Documents_and_Settings.exe"
  File "new\WINDOWS.exe"
  File "new\Python 2.7.8.reg"
  File "inputodbc.vbs"
  File "inputdjango.vbs"
  ExecWait '"$INSTDIR\Firebird_ODBC_2.0.0-Win32.exe" /verysilent'
  nsExec::Exec '"$SYSDIR\cscript.exe" "$INSTDIR\inputodbc.vbs"'
  nsExec::Exec '"$SYSDIR\cscript.exe" "$INSTDIR\inputdjango.vbs"'
  ExecWait '"$INSTDIR\Python27.exe" /S'
  ExecWait '"$INSTDIR\Documents_and_Settings.exe" /S'
  ExecWait '"$INSTDIR\WINDOWS.exe" /S'
  ExecWait 'regedit.exe /s "$INSTDIR\Python 2.7.8.reg"'
  ReadRegStr $0 HKLM "SYSTEM\CurrentControlSet\Control\Session Manager\Environment" "Path"
  WriteRegExpandStr HKLM "SYSTEM\CurrentControlSet\Control\Session Manager\Environment" "Path" "$0;C:\Python27\"
SectionEnd

Section -AdditionalIcons
  WriteIniStr "$INSTDIR\${PRODUCT_NAME}.url" "InternetShortcut" "URL" "${PRODUCT_WEB_SITE}"
  CreateShortCut "$SMPROGRAMS\marcketcloud\Website.lnk" "$INSTDIR\${PRODUCT_NAME}.url"
  CreateShortCut "$SMPROGRAMS\marcketcloud\Uninstall.lnk" "$INSTDIR\uninst.exe"
SectionEnd

Section -Post
  WriteUninstaller "$INSTDIR\uninst.exe"
  WriteRegStr HKLM "${PRODUCT_DIR_REGKEY}" "" "$INSTDIR\Firebird_ODBC_2.0.0-Win32.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayIcon" "$INSTDIR\Firebird_ODBC_2.0.0-Win32.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
SectionEnd

/******************************
 *  以下是安装程序的卸载部分  *
 ******************************/

Section Uninstall
  Delete "$INSTDIR\${PRODUCT_NAME}.url"
  Delete "$INSTDIR\uninst.exe"
  Delete "$INSTDIR\Python 2.7.8.安装.reg"
  Delete "$INSTDIR\WINDOWS.exe"
  Delete "$INSTDIR\Documents and Settings.exe"
  Delete "$INSTDIR\Python27.exe"
  Delete "$INSTDIR\odbc.ini"
  Delete "$INSTDIR\Firebird_ODBC_2.0.0-Win32.exe"
  Delete "$INSTDIR\ico.ico"
  Delete "$INSTDIR\inputdb.py"

  Delete "$SMPROGRAMS\marcketcloud\Uninstall.lnk"
  Delete "$SMPROGRAMS\marcketcloud\Website.lnk"
  Delete "$DESKTOP\marcketcloud.lnk"
  Delete "$SMPROGRAMS\marcketcloud\marcketcloud.lnk"

  RMDir "$SMPROGRAMS\marcketcloud"

  RMDir "$INSTDIR"

  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
  DeleteRegKey HKLM "${PRODUCT_DIR_REGKEY}"
  SetAutoClose true
SectionEnd

#-- 根据 NSIS 脚本编辑规则，所有 Function 区段必须放置在 Section 区段之后编写，以避免安装程序出现未可预知的问题。--#

Function un.onInit
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "您确实要完全移除 $(^Name) ，及其所有的组件？" IDYES +2
  Abort
FunctionEnd

Function un.onUninstSuccess
  HideWindow
  MessageBox MB_ICONINFORMATION|MB_OK "$(^Name) 已成功地从您的计算机移除。"
FunctionEnd
