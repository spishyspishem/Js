import requests

url_a = r'https://raw.githubusercontent.com/spishyspishem/Js/main/AHK%20Scripts/Keyboard_Shortcuts.ahk'
response_a = requests.get(url_a, verify=False) # TH has some kind of ssl certificates i can't verify; so disable verification
print(response_a.content)
with open('Keyboard_Shortcuts.ahk', 'wb') as f:
  f.write(response_a.content)

url_b = r'https://raw.githubusercontent.com/spishyspishem/Js/main/AHK%20Scripts/AdvancedWindowSnap.ahk'
response_b = requests.get(url_b, verify=False) # TH has some kind of ssl certificates i can't verify; so disable verification
print(response_b.content)
with open('AdvancedWindowSnap.ahk', 'wb') as f:
  f.write(response_b.content)

url_c = r'https://raw.githubusercontent.com/spishyspishem/Js/main/AHK%20Scripts/VSCode.ahk'
response_c = requests.get(url_c, verify=False) # TH has some kind of ssl certificates i can't verify; so disable verification
print(response_c.content)
with open('VSCode.ahk', 'wb') as f:
  f.write(response_c.content)
