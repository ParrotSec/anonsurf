import httpClient
import strutils
import xmltree
import htmlparser


proc parseIPbyTorServer(data: string): array[2, string] =
  #[
    Get IP address and current status from Tor server
  ]#

  let ipAddr = parseHtml(data).findAll("strong")[0].innerText
  let status = parseHtml(data).findAll("title")[0].innerText
  return [status.replace("\n", "").replace("  ", ""), "Your address is: " & ipAddr]
  # return "Your address is: " & ipAddr & "\n" & status.replace("\n", "").replace("  ", "")


proc checkIPFromTorServer*(): array[2, string] =
  #[
    Check current public IP using https://check.torproject.org/ 
  ]#
  const
    target = "https://check.torproject.org/"
  var
    client = newHttpClient()
  
  try:
    let resp = client.get(target)
    let info = parseIPbyTorServer(resp.body)
    return info
  except Exception:
    stderr.write("[x] Get IP by Tor server error! Reason:\n" & getCurrentExceptionMsg() & "\n")
    return ["Error while getting IP information", getCurrentExceptionMsg()]
