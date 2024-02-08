import os

# packages = ['openpyxl', 'xlrd', 'colorama', 'Pillow', 'opencv-python', 'scipy', 'pyautogui', 'ipython', 'pytz']
# packages = ['tabula-py', 'tabulate']
# packages = ['camelot-py']
# packages = ['pypdf']
# packages = ['requests']
packages = ['termcolor']

for package in packages:
  cmd = f'python -m pip install {package} --trusted-host=pypi.python.org --trusted-host=pypi.org --trusted-host=files.pythonhosted.org'
  os.system(cmd)