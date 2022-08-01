;~ Global $sRepositoryPath    = @ScriptDir
Global $sRepositoryPath    = 'C:\LocalWorkspace\GitHub\Public\Au3NewProject'
Global $sChangelogFilePath = $sRepositoryPath & '\CHANGELOG.md'

Global Const $iMessageTimeout = 30
Global $iLineOfCurrentTag     = 0

Global $aListOfCommitTypes[][2] = _
    [ _
        ['Added: ',      'minor'], _
        ['Added!: ',     'major'], _
        ['Changed: ',    'minor'], _
        ['Changed!: ',   'major'], _
        ['Deprecated: ', 'patch'], _
        ['Fixed: ',      'patch'], _
        ['Removed: ',    'minor'], _
        ['Security: ',   'minor'], _
        ['Security!: ',  'major'] _
    ]
