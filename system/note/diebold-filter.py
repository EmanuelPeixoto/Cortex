import sys, os, subprocess, tempfile, glob, time
from PIL import Image

DEV = os.environ.get("DIEBOLD_DEV", "/dev/usb/lp0")
DOT_PER_MM = 8


def raster_bytes(img):
    w, h = img.size
    assert w % 8 == 0, w
    px = img.load()
    out = bytearray()
    for y in range(h):
        for x in range(0, w, 8):
            b = 0
            for i in range(8):
                if px[x + i, y] == 0:
                    b |= 1 << (7 - i)
            out.append(b)
    return bytes(out)


def trim(img):
    px = img.load()
    w, h = img.size
    minx, miny, maxx, maxy = w, h, -1, -1
    for y in range(h):
        for x in range(w):
            if px[x, y] < 250:
                if x < minx:
                    minx = x
                if x > maxx:
                    maxx = x
                if y < miny:
                    miny = y
                if y > maxy:
                    maxy = y
    if maxx < minx:
        return None
    pad = 8  # ~1mm de respiro
    minx = max(0, minx - pad)
    miny = max(0, miny - pad)
    maxx = min(w - 1, maxx + pad)
    maxy = min(h - 1, maxy + pad)
    return img.crop((minx, miny, maxx + 1, maxy + 1))


def process(img, paper_mm):
    img = img.convert("L")
    img = trim(img)
    if img is None:
        return None
    w, h = img.size
    # tag deitado (ex.: 95x40mm) -> gira 90°, igual ao script
    if w > h:
        img = img.rotate(90, expand=True)
        w, h = img.size
    alvo = min(paper_mm, 72) * DOT_PER_MM
    if w > alvo:  # só encolhe se não couber (mantém escala 1:1 p/ tags)
        img = img.resize((alvo, round(h * alvo / w)), Image.LANCZOS)
        w = alvo
    w = (w + 7) // 8 * 8
    if w != img.width:
        c = Image.new("L", (w, img.height), 255)
        c.paste(img, (0, 0))
        img = c
    return img.convert("1")


def envia(img, paper_mm):
    w, h = img.size
    larg = w // 8
    marg = max(0, (min(paper_mm, 72) * DOT_PER_MM - w) // 2) // 8
    data = bytes([0x1B, 0x6E, marg, larg, h & 0xFF, (h >> 8) & 0xFF]) + raster_bytes(img) + b"\x11"
    with open(DEV, "wb") as f:
        for i in range(0, len(data), 2048):
            f.write(data[i:i + 2048])
            f.flush()
            time.sleep(0.06)


def main():
    opts = sys.argv[5] if len(sys.argv) > 5 else ""
    paper = 80 if "80" in opts else 57
    copies = int(sys.argv[4]) if len(sys.argv) > 4 else 1

    if len(sys.argv) > 6 and os.path.exists(sys.argv[6]):
        pdf = sys.argv[6]
    else:
        fd, pdf = tempfile.mkstemp(suffix=".pdf")
        with os.fdopen(fd, "wb") as f:
            f.write(sys.stdin.buffer.read())

    tmp = tempfile.mkdtemp()
    subprocess.run(["pdftoppm", "-r", "203", "-png", "-gray", pdf, os.path.join(tmp, "pg")], check=True)

    paginas = []
    for png in sorted(glob.glob(os.path.join(tmp, "pg*.png"))):
        img = process(Image.open(png), paper)
        if img is not None:
            paginas.append(img)

    for _ in range(copies):
        for img in paginas:
            envia(img, paper)


if __name__ == "__main__":
    main()
