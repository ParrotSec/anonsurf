import gintro / gdkpixbuf

#[
  Load image from icons make to "embedded" icons
]#

type
  AnonImgBuf* = object
    imgSecLow*: Pixbuf
    imgSecMed*: Pixbuf
    imgSecHigh*: Pixbuf
    imgBootOn*: Pixbuf
    imgBootOff*: Pixbuf


proc initImgs(): AnonImgBuf =
  const
    imgSecLow = staticRead("../../../icons/sec-low.svg")
    imgSecMed = staticRead("../../../icons/sec-med.svg")
    imgSecHigh = staticRead("../../../icons/sec-high.svg")
    imgBootOff = staticRead("../../../icons/boot-off.svg")
    imgBootOn = staticRead("../../../icons/boot-on.svg")

  let loadLow = newPixbufLoader()
  discard loadLow.write(imgSecLow)
  discard loadLow.close()
  result.imgSecLow = loadLow.getPixbuf()

  let loadMed = newPixbufLoader()
  discard loadMed.write(imgSecMed)
  discard loadMed.close()
  result.imgSecMed = loadMed.getPixbuf()

  let loadHigh = newPixbufLoader()
  discard loadHigh.write(imgSecHigh)
  discard loadHigh.close()
  result.imgSecHigh = loadHigh.getPixbuf()

  let loadOff = newPixbufLoader()
  discard loadOff.write(imgBootOff)
  discard loadOff.close()
  result.imgBootOff = loadOff.getPixbuf()

  let loadOn = newPixbufLoader()
  discard loadOn.write(imgBootOn)
  discard loadOn.close()
  result.imgBootOn = loadOn.getPixbuf()

let surfImages* = initImgs()
