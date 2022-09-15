import xmltree
import htmlparser
import strutils


proc parseIPFromTorServer*(data: string): array[2, string] =
  #[
    Get IP address and current status from Tor server
  ]#

  let ipAddr = parseHtml(data).findAll("strong")[0].innerText
  let status = parseHtml(data).findAll("title")[0].innerText
  return [status.replace("\n", "").replace("  ", ""), "Your address is: " & ipAddr]
