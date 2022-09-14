Func IdentifyNextTag($sTag, $aListOfCommits)
    Local $bIncreaseMajorVersion = False
    Local $bIncreaseMinorVersion = False
    Local $bIncreasePatchVersion = False

    Local Const $iFastComparison = 2

    For $i = 0 To _GetCount($aListOfCommits) Step 1
        For $j = 0 To _GetCount($aListOfCommitTypes) Step 1
            Local $sCommitMessage     = $aListOfCommits[$i]
            Local $sCommitType        = $aListOfCommitTypes[$j][0]
            Local $sCommitTypeVersion = $aListOfCommitTypes[$j][1]

            If StringInStr($sCommitMessage, $sCommitType, $iFastComparison) <> 0 Then
                Switch $sCommitTypeVersion
                    Case StringLower('major')
                        $bIncreaseMajorVersion = True
                    Case StringLower('minor')
                        $bIncreaseMinorVersion = True
                    Case StringLower('patch')
                        $bIncreasePatchVersion = True
                EndSwitch

                ExitLoop
            EndIf
        Next
    Next

    Local $sSemVer = StringReplace($sTag, 'v', '')

    Local Const $sDelimiter = '.'

    Local $iMajor = StringSplit($sSemVer, $sDelimiter)[1]
    Local $iMinor = StringSplit($sSemVer, $sDelimiter)[2]
    Local $iPatch = StringSplit($sSemVer, $sDelimiter)[3]

    If $bIncreaseMajorVersion Then
        $iMajor += 1
        $iMinor = 0
        $iPatch = 0

        Return $iMajor & '.' & $iMinor & '.' & $iPatch
    EndIf

    If $bIncreaseMinorVersion Then
        $iMinor += 1
        $iPatch = 0

        Return $iMajor & '.' & $iMinor & '.' & $iPatch
    EndIf

    If $bIncreasePatchVersion Then
        $iPatch += 1

        Return $iMajor & '.' & $iMinor & '.' & $iPatch
    EndIf
EndFunc

Func _WriteNextTagSectionInChangelog($sNewTag, $aListOfCommits)
    Local $sVersion = @CRLF & '## [' & $sNewTag & '] - ' & @YEAR & '-' & @MON & '-' & @MDAY & @CRLF
    Local $sCommits = ''
    Local $sSave    = ''

    Local Const $iStripLeadingSpace = 1
    Local Const $iTrimSemicolon     = 1
    Local Const $sRegExPattern      = '(.+?:)'

    For $i = 0 To _GetCount($aListOfCommits) Step 1
        Local $sCommitType = StringRegExp($aListOfCommits[$i], $sRegExPattern, 1)[0]
        Local $sCommit     = StringReplace($aListOfCommits[$i], $sCommitType, '')
        $sCommit           = StringReplace(StringStripWS($sCommit, $iStripLeadingSpace), @CR, '')

        If $sCommitType <> $sSave Then
            $sCommits &= @CRLF & '### ' & StringTrimRight($sCommitType, $iTrimSemicolon) & @CRLF & @CRLF
            $sCommits &= '- ' & $sCommit & @CRLF
        EndIf

        If $sCommitType == $sSave Then
            $sCommits &= '- ' & $sCommit & @CRLF
        EndIf

        $sSave = $sCommitType
    Next

    Local Const $bOverWriteLine = True

    _FileWriteToLine($sChangelogFilePath, $iLineOfCurrentTag, $sVersion & $sCommits, $bOverWriteLine)
EndFunc

Func _WriteComparisonLinkOfCurrentTag($sTag, $sNewTag)
    Local $aFileContent    = FileReadToArray($sChangelogFilePath)
    Local $sSemVer         = StringReplace($sTag, 'v', '')
    Local $sFoundIndicator = '[' & $sSemVer & ']: https://'

    Local Const $iFastComparison = 2

    For $i = 0 To _GetCount($aFileContent) Step 1
        If StringInStr($aFileContent[$i], $sFoundIndicator, $iFastComparison) <> 0 Then
            _GetCodeHostingPlatform($aFileContent[$i])

            If StringInStr($aFileContent[$i], '/releases/tag/', $iFastComparison) <> 0 Or _
               StringInStr($aFileContent[$i], '/tags/', $iFastComparison) <> 0 Then
                _FromReleaseLink($sNewTag, $aFileContent, $i, $sSemVer)

                ExitLoop
            EndIf

            _FromComparisonLink($sTag, $sNewTag, $aFileContent, $i, $sSemVer)

            ExitLoop
        EndIf
    Next

    For $i = 0 To _GetCount($aFileContent) Step 1
        If StringInStr($aFileContent[$i], '[Unreleased]:', $iFastComparison) <> 0 Then
            Local $sSearch  = '(/compare/.+?)$'

            If $sCodeHostingPlatform == $sGithub Then
                Local $sReplace = '/compare/v' & $sNewTag & '...HEAD'
            EndIf

            If $sCodeHostingPlatform == $sGitlab Then
                Local $sReplace = '/compare/v' & $sNewTag & '...main'
            EndIf

            Local $sUnreleasedComparisonLink = StringRegExpReplace($aFileContent[$i], $sSearch, $sReplace)

            _FileWriteToLine($sChangelogFilePath, $i + 1, $sUnreleasedComparisonLink, True)

            ExitLoop
        EndIf
    Next
EndFunc

Func _GetCodeHostingPlatform($sLink)
    Local Const $iFastComparison = 2

    If StringInStr(StringLower($sLink), $sGithub, $iFastComparison) <> 0 Then
        $sCodeHostingPlatform = $sGithub

        Return
    EndIf

    If StringInStr(StringLower($sLink), $sGitlab, $iFastComparison) <> 0 Then
        $sCodeHostingPlatform = $sGitlab
    EndIf
EndFunc

Func _FromReleaseLink($sNewTag, $aFileContent, $i, $sSemVer)
    If $sCodeHostingPlatform == $sGithub Then
        Local $sSearch  = '(/releases/tag/)(.+?)$'
    EndIf

    If $sCodeHostingPlatform == $sGitlab Then
        Local $sSearch  = '(/tags/)(.+?)$'
    EndIf

    Local $sReplace = '/compare/$2...v' & $sNewTag

    Local $sNewTagComparisonLink = StringRegExpReplace($aFileContent[$i], $sSearch, $sReplace)
    $sNewTagComparisonLink       = StringReplace($sNewTagComparisonLink, '[' & $sSemVer & ']', '[' & $sNewTag & ']')

    _FileWriteToLine($sChangelogFilePath, $i + 1, $sNewTagComparisonLink)
EndFunc

Func _FromComparisonLink($sTag, $sNewTag, $aFileContent, $i, $sSemVer)
    Local $sSearch  = '(/compare/.+?)$'
    Local $sReplace = '/compare/' & $sTag & '...v' & $sNewTag

    Local $sNewTagComparisonLink = StringRegExpReplace($aFileContent[$i], $sSearch, $sReplace)
    $sNewTagComparisonLink       = StringReplace($sNewTagComparisonLink, '[' & $sSemVer & ']', '[' & $sNewTag & ']')

    _FileWriteToLine($sChangelogFilePath, $i + 1, $sNewTagComparisonLink)
EndFunc
