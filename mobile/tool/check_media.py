"""Reject unresolved Git LFS pointers before shipping student app media."""

from pathlib import Path
import sys

MEDIA_EXTENSIONS = {".png", ".jpg", ".jpeg", ".webp", ".gif", ".ico", ".mp4", ".webm", ".mp3", ".wav"}


def main():
    roots = [Path(value) for value in sys.argv[1:]] or [Path("assets"), Path("web/icons")]
    failures = []
    count = 0
    for root in roots:
        if not root.is_dir():
            failures.append(f"Missing media directory: {root}")
            continue
        for path in root.rglob("*"):
            if not path.is_file() or path.suffix.lower() not in MEDIA_EXTENSIONS:
                continue
            count += 1
            with path.open("rb") as media:
                header = media.read(128)
            if header.startswith(b"version https://git-lfs.github.com/spec/v1"):
                failures.append(f"Unresolved Git LFS pointer: {path}")
            elif not header:
                failures.append(f"Empty media file: {path}")
    if failures:
        print("\n".join(failures), file=sys.stderr)
        print("Download the real files with git lfs pull before building.", file=sys.stderr)
        return 1
    print(f"Verified {count} media files; no Git LFS pointers or empty files.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
