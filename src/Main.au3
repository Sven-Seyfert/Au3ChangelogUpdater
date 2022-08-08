; compiler information for AutoIt
#pragma compile(CompanyName, © SOLVE SMART)
#pragma compile(FileVersion, 0.2.0)
#pragma compile(LegalCopyright, © Sven Seyfert)
#pragma compile(ProductName, Au3ChangelogUpdater)
#pragma compile(ProductVersion, 0.2.0 - 2022-08-08)

#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#AutoIt3Wrapper_Icon=..\media\icons\favicon.ico
#AutoIt3Wrapper_Outfile_x64=..\build\Au3ChangelogUpdater.exe
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_UseX64=y



; opt and just singleton -------------------------------------------------------
Opt('MustDeclareVars', 1)
Global $aInst = ProcessList('Au3ChangelogUpdater.exe')
If $aInst[0][0] > 1 Then Exit



; includes ---------------------------------------------------------------------
#include-once
#include <Array.au3>
#include <File.au3>



; modules ----------------------------------------------------------------------
#include "Initializer.au3"
#include "ActionHandler.au3"
#include "GitCommandHandler.au3"
#include "CommitValidator.au3"
#include "ChangelogValidator.au3"
#include "ChangelogWriter.au3"
#include "VersionUpdater.au3"
#include "Helper.au3"



; processing -------------------------------------------------------------------
_Actions()
