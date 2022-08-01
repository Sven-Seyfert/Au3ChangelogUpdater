Func _ExistsChangelogFile()
    Return FileExists($sChangelogFilePath)
EndFunc

Func _ExistsCurrentTagInChangelogFile($sTag)
    Local $aFileContent    = FileReadToArray($sChangelogFilePath)
    Local $sSemVer         = StringReplace($sTag, 'v', '')
    Local $sFoundIndicator = '## [' & $sSemVer & '] - '

    Local Const $iFastComparison = 2

    For $i = 0 To _GetCount($aFileContent) Step 1
        If StringInStr($aFileContent[$i], $sFoundIndicator, $iFastComparison) <> 0 Then
            $iLineOfCurrentTag = $i

            ExitLoop
        EndIf
    Next

    Return $iLineOfCurrentTag <> 0
EndFunc
