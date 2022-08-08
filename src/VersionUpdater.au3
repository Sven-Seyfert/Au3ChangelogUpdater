Func _VersionBump($sTag, $sNewTag)
    Local Const $sFileExtension         = '*.au3'
    Local Const $iReturnFilesOnly       = 1
    Local Const $iSearchInAllSubfolders = 1

    Local $aListOfFiles = _FileListToArrayRec($sRepositoryPath, $sFileExtension, $iReturnFilesOnly, $iSearchInAllSubfolders)

    _ArrayDelete($aListOfFiles, 0)

    Local $sSemVer = StringReplace($sTag, 'v', '')

    Local $sSearch1  = '#pragma compile(FileVersion, ' & $sSemVer & ')'
    Local $sReplace1 = '#pragma compile(FileVersion, ' & $sNewTag & ')'

    Local $sSearch2  = '#pragma compile\(ProductVersion, .+?\)'
    Local $sReplace2 = '#pragma compile(ProductVersion, ' & $sNewTag & ' - ' & @YEAR & '-' & @MON & '-' & @MDAY & ')'

    Local Const $iReplaceOccurence = 1

    For $i = 0 To _GetCount($aListOfFiles) Step 1
        Local $sFilePath    = $sRepositoryPath & '\' & $aListOfFiles[$i]
        Local $sFileContent = _GetFileContent($sFilePath)

        $sFileContent = StringReplace($sFileContent, $sSearch1, $sReplace1, $iReplaceOccurence)

        Local $iReplacements = @extended

        If $iReplacements == 0 Then
            ContinueLoop
        EndIf

        $sFileContent = StringRegExpReplace($sFileContent, $sSearch2, $sReplace2, $iReplaceOccurence)

        _WriteFile($sFilePath, $sFileContent)
    Next
EndFunc
