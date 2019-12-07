# Make vim the default editor
$env:EDITOR = "gvim --nofork"
$env:GIT_EDITOR = $Env:EDITOR

# Disable the Progress Bar
$ProgressPreference='Continue'
