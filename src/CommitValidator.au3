Func _ExistsUnexpectedCommitType($aListOfCommits)
    Local Const $iFastComparison = 2

    For $i = 0 To _GetCount($aListOfCommits) Step 1
        Local $bFound = False

        For $j = 0 To _GetCount($aListOfCommitTypes) Step 1
            Local $sCommitMessage = $aListOfCommits[$i]
            Local $sCommitType    = $aListOfCommitTypes[$j][0]

            If StringInStr($sCommitMessage, $sCommitType, $iFastComparison) <> 0 Then
                $bFound = True

                ExitLoop
            EndIf
        Next

        If Not $bFound Then
            _ShowMessage($aListOfCommitTypes, $sCommitMessage)

            Return True
        EndIf
    Next

    Return False
EndFunc

Func _ShowMessage($aListOfCommitTypes, $sCommitMessage)
    Local $sCommitTypes

    For $i = 0 To _GetCount($aListOfCommitTypes) Step 1
        $sCommitTypes &= '- ' & $aListOfCommitTypes[$i][0] & @CRLF
    Next

    $sCommitTypes = StringTrimRight($sCommitTypes, 1)

    Local $iMessageIcon = 48
    MsgBox($iMessageIcon, _
        'Unexpected commit message', _
        'The following commit message doesn''t fit the expected commit types:' & @CRLF & @CRLF & _
        '=> ' & $sCommitMessage & @CRLF & _
        'These are the expected commit types:' & @CRLF & @CRLF & _
        $sCommitTypes, _
        $iMessageTimeout)
EndFunc
