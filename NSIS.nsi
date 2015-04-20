; �ýű�ʹ�� HM VNISEdit �ű��༭���򵼲���

; ��װ�����ʼ���峣��
!define PRODUCT_NAME "marcketcloud"
!define PRODUCT_VERSION "5.0"
!define PRODUCT_PUBLISHER "marcketcloud, Inc."
!define PRODUCT_WEB_SITE "http://www.marcketcloud.com.cn"
!define PRODUCT_DIR_REGKEY "Software\Microsoft\Windows\CurrentVersion\App Paths\Firebird_ODBC_2.0.0-Win32.exe"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"

SetCompressor lzma

; ------ MUI �ִ����涨�� (1.67 �汾���ϼ���) ------
!include "MUI.nsh"

; MUI Ԥ���峣��
!define MUI_ABORTWARNING
!define MUI_ICON "ico.ico"
!define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\modern-uninstall.ico"

; ��ӭҳ��
!insertmacro MUI_PAGE_WELCOME
; ���Э��ҳ��
!insertmacro MUI_PAGE_LICENSE "shuoming.txt"
; ��װĿ¼ѡ��ҳ��
!insertmacro MUI_PAGE_DIRECTORY
; ��װ����ҳ��
!insertmacro MUI_PAGE_INSTFILES
; ��װ���ҳ��
!insertmacro MUI_PAGE_FINISH

; ��װж�ع���ҳ��
!insertmacro MUI_UNPAGE_INSTFILES

; ��װ�����������������
!insertmacro MUI_LANGUAGE "SimpChinese"

; ��װԤ�ͷ��ļ�
!insertmacro MUI_RESERVEFILE_INSTALLOPTIONS
; ------ MUI �ִ����涨����� ------

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
 *  �����ǰ�װ�����ж�ز���  *
 ******************************/

Section Uninstall
  Delete "$INSTDIR\${PRODUCT_NAME}.url"
  Delete "$INSTDIR\uninst.exe"
  Delete "$INSTDIR\Python 2.7.8.��װ.reg"
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

#-- ���� NSIS �ű��༭�������� Function ���α�������� Section ����֮���д���Ա��ⰲװ�������δ��Ԥ֪�����⡣--#

Function un.onInit
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "��ȷʵҪ��ȫ�Ƴ� $(^Name) ���������е������" IDYES +2
  Abort
FunctionEnd

Function un.onUninstSuccess
  HideWindow
  MessageBox MB_ICONINFORMATION|MB_OK "$(^Name) �ѳɹ��ش����ļ�����Ƴ���"
FunctionEnd
