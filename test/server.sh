# Use this to run server silently
# Useful for cleaning up Dredd's output
# https://github.com/apiaryio/dredd/issues/593

# Ensure we are in the directory where this script resides
cd "$( dirname "${BASH_SOURCE[0]}" )"

# Break out of the test folder
cd ../

# Run shotgun, redirect all output to null (stdout and stderr)
# Launch it as forked, backgrounded child process
shotgun > /dev/null 2>&1 &

# Save its process id
PID=$!

# Kill shotgun on exit
function cleanup {
   kill $PID
}

trap cleanup EXIT

# Keep this script running until Dredd sends SIGKILL
cat
