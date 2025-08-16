#!/usr/bin/env sh
set -eu

# === RUTAS PERSISTENTES (EN EL VOLUME) ===
DATA_DIR=${DATA_DIR:-/data}
NB_DIR=${NB_DIR:-$DATA_DIR/notebooks}     # raíz donde verás/crearás notebooks
OUT_DIR=${OUT_DIR:-$DATA_DIR/jobs}        # carpeta para outputs de jobs
SCHEDULER_DB_URL=${SCHEDULER_DB_URL:-sqlite:////$DATA_DIR/scheduler.sqlite}

mkdir -p "$NB_DIR" "$OUT_DIR" "$DATA_DIR/.jupyter"

# (Si usas password por env: JUPYTER_PASSWORD o JUPYTER_PASSWORD_HASH)
PYCODE=$(cat <<'PY'
import os
pwd = os.environ.get("JUPYTER_PASSWORD")
ph  = os.environ.get("JUPYTER_PASSWORD_HASH")
if ph:
    print(ph)
elif pwd:
    try:
        from notebook.auth import passwd
    except Exception:
        try:
            from jupyter_server.auth import passwd
        except Exception:
            from jupyter_server.auth.security import passwd
    print(passwd(pwd))
else:
    print("")
PY
)
HASH=$(python -c "$PYCODE")

exec jupyter lab \
  --ip=0.0.0.0 \
  --port="${PORT:-8888}" \
  --allow-root --no-browser \
  --ServerApp.root_dir="$NB_DIR" \
  ${HASH:+--ServerApp.password="$HASH"} \
  --ServerApp.token="" \
  --ServerApp.trust_xheaders=True \
  --SchedulerApp.db_url="$SCHEDULER_DB_URL"
