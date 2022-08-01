Func _Actions()
    Local $sTag           = _GetLatestGitTag()
    Local $sCommits       = _GetCommitsMessagesBetweenHeadAndTag($sTag)
    Local $aListOfCommits = _CreateListOfCommits($sCommits)

    Local Const $sEmptyIndicator = @CR

    If $aListOfCommits[0] == $sEmptyIndicator Then
        Local $iMessageIcon = 64
        MsgBox($iMessageIcon, 'No changelog update', 'There is no new commit found since git tag "' & $sTag & '".', $iMessageTimeout)

        Return
    EndIf

    If _ExistsUnexpectedCommitType($aListOfCommits) Then
        Return
    EndIf

    If Not _ExistsChangelogFile() Then
        Local $iMessageIcon = 48
        MsgBox($iMessageIcon, 'hangelog file not found', 'Nothing to update, no changelog file at repository root level found.', $iMessageTimeout)

        Return
    EndIf

    If Not _ExistsCurrentTagInChangelogFile($sTag) Then
        Local $iMessageIcon = 48
        MsgBox($iMessageIcon, 'Git tag not found', 'Tag "' & $sTag & '" has to be created in the changelog file first, then try again.', $iMessageTimeout)

        Return
    EndIf

    Local $sNewTag = IdentifyNextTag($sTag, $aListOfCommits)

    _WriteNextTagSectionInChangelog($sNewTag, $aListOfCommits)
    _WriteComparisonLinkOfCurrentTag($sTag, $sNewTag)

    Local $iMessageIcon = 64
    MsgBox($iMessageIcon, 'Changelog update', 'Changelog was updated from git tag "' & $sTag & '" to "v' & $sNewTag & '".', $iMessageTimeout)
EndFunc
