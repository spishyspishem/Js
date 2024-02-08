import requests

url = r'https://raw.githubusercontent.com/spishyspishem/Js/main/Python%20Dependencies/pk2_excel.py'
response = requests.get(url, verify=False) # TH has some kind of ssl certificates i can't verify; so disable verification
print(response.content)
with open('pk2_excel.py', 'wb') as f:
  f.write(response.content)
