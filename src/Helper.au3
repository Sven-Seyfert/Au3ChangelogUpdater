Func _CreateListOfCommits($sCommits)
    Local Const $iEntireDelimiter = 1
    Local Const $iIndexToDelete   = 0

    Local $aListOfCommits = StringSplit($sCommits, @LF, $iEntireDelimiter)
    Local $iCount = Ubound($aListOfCommits) - 1

    _ArrayDelete($aListOfCommits, $iCount)
    _ArrayDelete($aListOfCommits, $iIndexToDelete)
    _ArraySort($aListOfCommits)

    Return $aListOfCommits
EndFunc

Func _GetCount($aList)
    Return UBound($aList) - 1
EndFunc

Func _GetFileContent($sFile)
    Local Const $iUtf8WithoutBomMode = 256

    Local $hFile        = FileOpen($sFile, $iUtf8WithoutBomMode)
    Local $sFileContent = FileRead($hFile)
    FileClose($hFile)

    Return $sFileContent
EndFunc

Func _WriteFile($sFile, $sText)
    Local Const $iUtf8WithoutBomAndOverwriteCreationMode = 256 + 2 + 8

    Local $hFile = FileOpen($sFile, $iUtf8WithoutBomAndOverwriteCreationMode)
    FileWrite($hFile, $sText)
    FileClose($hFile)
EndFunc
