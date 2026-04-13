## Redirecting Profile to Scott's Terminal Configuration

$PROFILE_REDIRECT = "$env:USERPROFILE\.terminal-config\profiles\powershell-profile.ps1"
$PROFILE_REDIRECT_RESOLVED = Resolve-Path $PROFILE_REDIRECT
. ${PROFILE_REDIRECT_RESOLVED}
