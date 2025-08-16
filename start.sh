#!/usr/bin/env sh
set -eu

PYCODE=$(cat <<'PY'
import os
pwd = os.environ.get("JUPYTER_PASSWORD")
ph  = os.environ.get("JUPYTER_PASSWORD_HASH")

if ph:
    print(ph)
elif pwd:
    # intenta primero en notebook, si no, en jupyter_server
    try:
        from notebook.auth import passwd
    except Exception:
        try:
            from jupyter_server.auth import passwd
        except Exception:
            from jupyter_server.auth.security import passwd
    print(passwd(pwd))
else:
    raise SystemExit("ERROR: define JUPYTER_PASSWORD o JUPYTER_PASSWORD_HASH")
PY
)

HASH=$(python -c "$PYCODE")

exec jupyter lab \
  --ip=0.0.0.0 \
  --port="${PORT:-8888}" \
  --allow-root \
  --no-browser \
  --ServerApp.password="$HASH" \
  --ServerApp.token="" \
  --ServerApp.trust_xheaders=True
