Global $sRepositoryPath    = @ScriptDir
Global $sChangelogFilePath = $sRepositoryPath & '\CHANGELOG.md'

Global Const $sGithub = 'github.'
Global Const $sGitlab = 'gitlab.'
Global $sCodeHostingPlatform

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
