#!/bin/sh
# GNU tar 1.35 under Apple Rosetta returns ENOSYS for mkdirat/openat2
# ("Cannot mkdir: Function not implemented") while extracting vscode-server.
# On Apple Silicon, run a native aarch64 busybox tar. Elsewhere, GNU tar.
HOST=/opt/host-tar/busybox
if [ -x "$HOST" ] && "$HOST" true >/dev/null 2>&1; then
  if [ "$1" = "--version" ]; then
    echo "tar (GNU tar) 1.34"
    echo "Copyright (C) 2021 Free Software Foundation, Inc."
    echo "License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>."
    echo ""
    echo "Written by John Gilmore and Jay Fenlason."
    exit 0
  fi
  exec "$HOST" tar "$@"
fi
exec /usr/bin/tar.distrib "$@"
