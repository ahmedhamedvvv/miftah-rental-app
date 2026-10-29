"""Download the app's photos from Pexels into assets/photos.

Runs in CI (the build containers can reach images.pexels.com). Files that
already exist are skipped, so it is cheap to run on every build. Photos are
resized to 1080px wide and saved as progressive JPEGs.
"""
import json
import pathlib
import shutil
import subprocess
import sys
import urllib.request

ROOT = pathlib.Path(__file__).resolve().parent.parent
OUT = ROOT / "assets" / "photos"


def main() -> int:
    photos = json.loads((ROOT / "tool" / "photos.json").read_text())
    failed = []
    for p in photos:
        dest = OUT / p["file"]
        if dest.exists() and dest.stat().st_size > 10_000:
            continue
        dest.parent.mkdir(parents=True, exist_ok=True)
        pid = p["pexels"]
        url = (f"https://images.pexels.com/photos/{pid}/pexels-photo-{pid}.jpeg"
               "?auto=compress&cs=tinysrgb&w=1400")
        raw = dest.with_name(dest.stem + ".download.jpg")
        try:
            req = urllib.request.Request(url, headers={"User-Agent": "Mozilla/5.0"})
            with urllib.request.urlopen(req, timeout=60) as r:
                data = r.read()
            if not data.startswith(b"\xff\xd8"):
                raise ValueError(f"not a JPEG ({len(data)} bytes): {data[:60]!r}")
            raw.write_bytes(data)
            tool = shutil.which("magick") or shutil.which("convert")
            resized = tool and subprocess.run(
                [tool, f"jpg:{raw}", "-resize", "1080x1080>", "-strip",
                 "-interlace", "Plane", "-quality", "78", f"jpg:{dest}"],
            ).returncode == 0
            if not resized:
                # Pexels already serves a compressed 1400px JPEG.
                raw.replace(dest)
            print(f"ok   {p['file']}")
        except Exception as e:  # noqa: BLE001
            failed.append(p["file"])
            print(f"FAIL {p['file']}: {e}")
        finally:
            raw.unlink(missing_ok=True)
    if failed:
        print(f"{len(failed)} photo(s) failed; the app shows a drawn fallback for them.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
