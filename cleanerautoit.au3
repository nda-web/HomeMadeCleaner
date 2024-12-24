#include <File.au3>
#include <FileConstants.au3>
#include <EditConstants.au3>
#include <WindowsConstants.au3>
#include <GUIConstantsEx.au3>
#include <ButtonConstants.au3>
#include <FontConstants.au3>
#include <ProgressConstants.au3>
#include <StaticConstants.au3>

; Función para limpiar una carpeta
Func ClearFolder($sFolderPath, ByRef $iTotalFiles, ByRef $iTotalSize, ByRef $sSummary)
    If FileExists($sFolderPath) Then
        Local $aFiles = _FileListToArrayRec($sFolderPath, "*", 3, $FLTAR_RECUR, $FLTAR_NOSORT, $FLTAR_FULLPATH)
        If @error Then
            $sSummary &= "Error al listar archivos en: " & $sFolderPath & @CRLF
            Return False
        EndIf
        For $i = 1 To $aFiles[0]
            Local $sFilePath = $aFiles[$i]
            If FileExists($sFilePath) Then
                If StringInStr(FileGetAttrib($sFilePath), "D") Then
                    DirRemove($sFilePath, 1)
                Else
                    $iTotalSize += FileGetSize($sFilePath)
                    FileDelete($sFilePath)
                EndIf
                $iTotalFiles += 1
            EndIf
        Next
        $sSummary &= "Carpeta limpiada: " & $sFolderPath & @CRLF
        Return True
    Else
        $sSummary &= "Carpeta no encontrada: " & $sFolderPath & @CRLF
        Return False
    EndIf
EndFunc

; Función para limpiar el registro
Func ClearRegistry(ByRef $sSummary)
    Local $aRegKeysToClear[7] = [ _
        "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU", _
        "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\TypedPaths", _
        "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\RecentDocs", _
        "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run", _
        "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run", _
        "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings\5.0\Cache\Extensible Cache", _
        "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings\5.0\Cache\Content" _
    ]

    For $sRegKey In $aRegKeysToClear
        If RegDelete($sRegKey) = 0 Then
            $sSummary &= "Clave del registro eliminada: " & $sRegKey & @CRLF
        Else
            $sSummary &= "Clave del registro no encontrada: " & $sRegKey & @CRLF
        EndIf
    Next

    $sSummary &= "Limpieza del registro completada." & @CRLF
EndFunc

; Listado de carpetas a limpiar
Local $aFoldersToClear[18] = [ _
    @TempDir, _
    @AppDataCommonDir & "\Temp", _
    "C:\Windows\Prefetch", _
    "C:\Windows\SoftwareDistribution\Download", _
    "C:\Windows\Logs", _
    @AppDataDir & "\Microsoft\Windows\Recent", _
    @LocalAppDataDir & "\Microsoft\Windows\Explorer", _
    @LocalAppDataDir & "\Microsoft\Edge\User Data\Default\Cache", _
    @LocalAppDataDir & "\Google\Chrome\User Data\Default\Cache", _
    @LocalAppDataDir & "\Mozilla\Firefox\Profiles", _
    @UserProfileDir & "\Downloads", _
    @LocalAppDataDir & "\Temp", _
    "C:\Windows\WinSxS\Backup", _
    @LocalAppDataDir & "\VirtualStore", _
    "C:\Windows\System32\DriverStore\FileRepository", _
    "C:\ProgramData\Microsoft\Windows Defender\Scans\History", _
    "C:\Windows\Temp", _
    @LocalAppDataDir & "\CrashDumps" _
]

; Crear interfaz gráfica
Local $hGUI = GUICreate("HomeMadeCleaner", 600, 500)
GUISetIcon("clean4.ico")

; Crear menú
Local $hMenu = GUICtrlCreateMenu("Opciones")
Local $hMenuCredits = GUICtrlCreateMenuitem("Créditos", $hMenu)

Local $hLabelTitle = GUICtrlCreateLabel("Bienvenido a HomeMadeCleaner", 20, 20, 560, 30)
GUICtrlSetFont($hLabelTitle, 14, $FW_BOLD)
Local $hLabelSummary = GUICtrlCreateLabel("Resumen de lo que se va a borrar:", 20, 70, 560, 20)
GUICtrlSetFont($hLabelSummary, 12)
Local $hSummaryText = GUICtrlCreateEdit("", 20, 100, 560, 180, BitOR($ES_MULTILINE, $ES_READONLY, $WS_VSCROLL))

; Barra de progreso
Local $hProgressBar = GUICtrlCreateProgress(20, 300, 560, 20)

; Botones
Local $hButtonCleanRegistry = GUICtrlCreateButton("Limpiar Registro", 280, 340, 120, 30)
Local $hButtonClean = GUICtrlCreateButton("Iniciar Limpieza", 20, 340, 120, 30)
Local $hButtonCancel = GUICtrlCreateButton("Cancelar", 150, 340, 120, 30)

; Mostrar la GUI
GUISetState(@SW_SHOW, $hGUI)

; Manejo de eventos
While True
    Local $hMsg = GUIGetMsg()
    Switch $hMsg
        Case $GUI_EVENT_CLOSE, $hButtonCancel
            Exit
        Case $hButtonClean
            Local $sSummary = "Resumen de la limpieza:" & @CRLF
            Local $iTotalFiles = 0
            Local $iTotalSize = 0
            For $sFolder In $aFoldersToClear
                ClearFolder($sFolder, $iTotalFiles, $iTotalSize, $sSummary)
            Next
            $sSummary &= "Total de archivos eliminados: " & $iTotalFiles & @CRLF
            $sSummary &= "Espacio recuperado: " & Round($iTotalSize / 1024 / 1024, 2) & " MB" & @CRLF
            GUICtrlSetData($hSummaryText, $sSummary)
            MsgBox(64, "Limpieza", "Limpieza completada.")
        Case $hButtonCleanRegistry
            Local $sSummary = "Resumen de la limpieza del registro:" & @CRLF
            ClearRegistry($sSummary)
            GUICtrlSetData($hSummaryText, $sSummary)
            MsgBox(64, "Limpieza del Registro", "Limpieza del registro completada.")
        Case $hMenuCredits
            ShowCredits()
    EndSwitch
WEnd


; Función para mostrar la ventana de créditos
Func ShowCredits()
    Local $hCreditsGUI = GUICreate("Créditos", 400, 300)
    GUISetIcon("clean4.ico")

    ; Verifica si el archivo de imagen existe
    If FileExists(@ScriptDir & "\about.jpg") Then
        ; Calcula las coordenadas para centrar la imagen
        Local $imageWidth = 161
        Local $imageHeight = 200
        Local $imageX = (400 - $imageWidth) / 2
        Local $imageY = 10

        GUICtrlCreatePic(@ScriptDir & "\about.jpg", $imageX, $imageY, $imageWidth, $imageHeight)
    Else
        MsgBox(0, "Error", "No se encontró la imagen: " & @ScriptDir & "\about.jpg")
    EndIf

    ; Calcula las coordenadas para centrar el texto
    Local $labelWidth = 360
    Local $labelHeight = 100
    Local $labelX = (400 - $labelWidth) / 2
    Local $labelY = 220

    Local $hLabelCredits = GUICtrlCreateLabel("Autor: Martin Alejandro Oviedo" & @CRLF & _
                                              "Desarrollador: DeePSurfer", $labelX, $labelY, $labelWidth, $labelHeight)
    GUICtrlSetFont($hLabelCredits, 12, $FW_BOLD)

    ; Calcula las coordenadas para centrar el botón
    Local $buttonWidth = 100
    Local $buttonHeight = 30
    Local $buttonX = (400 - $buttonWidth) / 2
    Local $buttonY = 260

    Local $hButtonCloseCredits = GUICtrlCreateButton("Cerrar", $buttonX, $buttonY, $buttonWidth, $buttonHeight)
    GUISetState(@SW_SHOW, $hCreditsGUI)

    While True
        Local $hMsgCredits = GUIGetMsg()
        Switch $hMsgCredits
            Case $GUI_EVENT_CLOSE, $hButtonCloseCredits
                GUIDelete($hCreditsGUI)
                ExitLoop
        EndSwitch
    WEnd
EndFunc

