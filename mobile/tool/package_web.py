"""Give every release fresh asset and entrypoint URLs, including on Safari."""

import os
from pathlib import Path
import re
import shutil


def main():
    revision = os.environ["GITHUB_SHA"]
    if not re.fullmatch(r"[a-f0-9]{7,40}", revision):
        raise ValueError("GITHUB_SHA must be a Git commit hash")
    root = Path("build/web")
    release_base = f"releases/{revision}/"
    release = root / release_base
    release.mkdir(parents=True, exist_ok=False)
    for name in ("assets", "main.dart.js"):
        shutil.move(str(root / name), str(release / name))
    for name in ("index.html", "flutter_bootstrap.js"):
        path = root / name
        content = path.read_text(encoding="utf-8")
        if 'const releaseBase = "";' not in content:
            raise RuntimeError(f"Missing release base marker in {name}")
        if '"main.dart.js"' not in content:
            raise RuntimeError(f"Missing Flutter entrypoint in {name}")
        content = content.replace('const releaseBase = "";', f'const releaseBase = "{release_base}";')
        content = content.replace('"main.dart.js"', f'"{release_base}main.dart.js"')
        path.write_text(content, encoding="utf-8")
    print(f"Packaged web app with fresh release URLs: {release_base}")


if __name__ == "__main__":
    main()
