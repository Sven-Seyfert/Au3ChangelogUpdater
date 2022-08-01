Func _RunGitCommand($sCommand)
    Local Const $STDOUT_CHILD = 2
    Local $sDriveLetter = StringLeft($sRepositoryPath, 1)
    Local $iPID = Run(@ComSpec & ' /K ' & $sDriveLetter & ': && cd "' & $sRepositoryPath & '" && ' & $sCommand, '', @SW_HIDE, $STDOUT_CHILD)

    ProcessWaitClose($iPID)

    Return $iPID
EndFunc

Func _GetLatestGitTag()
    Local $sCommandForTag = 'git describe --tags --abbrev=0'
    Local $iPID = _RunGitCommand($sCommandForTag)

    Local $sOutput = StringReplace(StdoutRead($iPID), $sRepositoryPath & '>', '')
    $sOutput = StringReplace($sOutput, @CRLF, '')
    $sOutput = StringReplace($sOutput, @LF, '')

    Return $sOutput
EndFunc

Func _GetCommitsMessagesBetweenHeadAndTag($sTag)
    Local $sCommandForCommits = 'git log --pretty=format:"%s" --no-merges --max-count=20 HEAD...' & $sTag
    Local $iPID = _RunGitCommand($sCommandForCommits)

    Return StringReplace(StdoutRead($iPID), $sRepositoryPath & '>', '')
EndFunc
