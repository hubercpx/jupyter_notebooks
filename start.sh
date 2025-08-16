#!/usr/bin/env sh
set -eu

# Usa un hash directo si lo proporcionas; si no, genera el hash desde la contraseña en texto plano
if [ -n "${JUPYTER_PASSWORD_HASH:-}" ]; then
  HASH="$JUPYTER_PASSWORD_HASH"
elif [ -n "${JUPYTER_PASSWORD:-}" ]; then
  HASH=$(python - <<'PY'
from notebook.auth import passwd
import os
print(passwd(os.environ['JUPYTER_PASSWORD']))
PY
)
else
  echo "ERROR: define JUPYTER_PASSWORD o JUPYTER_PASSWORD_HASH en variables de entorno."
  exit 1
fi

exec jupyter lab \
  --ip=0.0.0.0 \
  --port="${PORT:-8888}" \
  --allow-root \
  --no-browser \
  --ServerApp.password="$HASH" \
  --ServerApp.token="" \
  --ServerApp.trust_xheaders=True
