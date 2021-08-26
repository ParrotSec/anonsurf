#[
  Read and parse all important ports from torrc
]#

import os
import strutils

type
  TorConfig* = object
    fileErr*: bool # Error while reading file
    controlPort*: string
    transPort*: string
    socksPort*: string
    dnsPort*: string


proc getTorrcPorts*(): TorConfig =
  const
    path = "/etc/tor/torrc"

  if fileExists(path):
    result.fileErr = false
    for line in lines(path):
      if line.startsWith("TransPort"):
        result.transPort = line.split(" ")[1]
      elif line.startsWith("SocksPort"):
        result.socksPort = line.split(" ")[1]
      elif line.startsWith("DNSPort"):
        result.dnsPort = line.split(" ")[1]
      elif line.startsWith("ControlPort"):
        result.controlPort = line.split(" ")[1]
      else:
        discard
  else:
    result.fileErr = true
