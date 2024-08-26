import pyautogui
import time
import os
import pyperclip
import sys
import subprocess

def set_folder(folder):
  global image_folder
  image_folder = folder

def click(img, child_img = None, xoff = 0, yoff = 0, confidence = 0.9, type='primary', doclick=True):
  """
  img is the filepath to the image of what you want to click
  xoff and yoff are the pixel offsets where you click
  from the image that was found
  """
  pth = os.path.join(image_folder, img)
  loc = pyautogui.locateOnScreen(pth, confidence = confidence)
  loc_x, loc_y = pyautogui.center(loc)
  if child_img is None:
    loc_x += xoff
    loc_y += yoff
  else: # find an image within another image in case the child image appears on screen in multiple places but the parent image only appears in one place
    childpth = os.path.join(image_folder, child_img)
    x2, y2, ww, hh = pyautogui.locate(childpth, pth)
    loc_x = loc_x + x2/2 + xoff
    loc_y = loc_y + y2/2 + yoff
  if doclick:
    pyautogui.click(loc_x, loc_y, button=type)
  else:
    pyautogui.moveTo(loc_x, loc_y)
  return (loc_x, loc_y)

def clickuntilnextimagefound(img1, img2, xoff = 0, yoff = 0, confidence1=0.9, confidence2=0.9, type='primary', doclick=True, sleep_time = 0.3):
  """ try clicking until the next image is found """
  pth1 = os.path.join(image_folder, img1)
  pth2 = os.path.join(image_folder, img2)
  while True:
    try:
      click(img1, child_img = None, xoff=xoff, yoff=yoff, confidence=confidence1, type=type, doclick=doclick)
    except Exception as e:
      print(f"looking for {pth1}, exception was: {e}")
      pass
    time.sleep(0.1)
    res = pyautogui.locateOnScreen(pth2, confidence=confidence2)
    if res == None:
      time.sleep(sleep_time)
      continue
    else:
      break

def tryclickinguntilfound(img, child_img = None, xoff = 0, yoff = 0, confidence=0.9, type='primary', doclick=True, sleep_time=0.5, maxtries=None):
  pth = os.path.join(image_folder, img)
  attempts = sys.maxsize if maxtries == None else maxtries
  for ii in range(attempts):
    try:
      result = click(img, child_img=child_img, xoff=xoff, yoff=yoff, confidence=confidence, type=type, doclick=doclick)
    except Exception as e:
      result = None
      print(f'Attempt {ii} for "{pth}" Exception: {e}')
      time.sleep(sleep_time)
      continue
    break
  return result

def which_image_found_first(imgs_list, confidence_list='', sleep_time=0.3, maxtries=None):
  """ determine which of a collection of images is the first to appear on screen """
  if confidence_list == '':
    confidence_list = [0.9 for ii in imgs_list]
  pths_list = [os.path.join(image_folder, img) for img in imgs_list]
  attempts = sys.maxsize if maxtries == None else maxtries
  for ii in range(attempts):
    print(f'Attempt {ii} for "{pths_list}"')
    for img, pth, confidence in zip(imgs_list, pths_list, confidence_list):
      res = pyautogui.locateOnScreen(pth, confidence=confidence)
      if res != None:
        x2, y2, ww, hh = res
        loc_x, loc_y = pyautogui.center(res)
        return {'name':img, 'loc':(loc_x, loc_y)}
    time.sleep(sleep_time)
  return None

def tryscrollinguntilfound(img, child_img = None, xoff = 0, yoff = 0, amt = -300, confidence = 0.9, type='primary', doclick=True):
  pth = os.path.join(image_folder, img)
  while True:
    try:
      # result = click(img, child_img = child_img, xoff, yoff, confidence)
      result = click(img, child_img=child_img, xoff=xoff, yoff=yoff, confidence=confidence, type=type, doclick=doclick)
    except:
      print(f"Scrolling, couldn't find image '{img}'...")
      pyautogui.scroll(amt)
      time.sleep(0.2)
      continue
    break
  return result

def click_and_drag_from_to(start_x, start_y, end_x, end_y, copy_to_clipboard=True):
  pyautogui.moveTo(start_x, start_y)
  pyautogui.mouseDown()
  pyautogui.moveTo(end_x, end_y)
  pyautogui.mouseUp()
  if copy_to_clipboard:
    time.sleep(0.04)
    pyautogui.hotkey('ctrl', 'c')
    time.sleep(0.04)
    return pyperclip.paste()
  else:
    return None 

def is_on_page(img, confidence=0.9):
  pth = os.path.join(image_folder, img)
  return pyautogui.locateOnScreen(pth, confidence = confidence) != None
  
def send_hotkey_sequence(seq, waitper = 0.1):
  for hotkey in seq:
    pyautogui.hotkey(*hotkey)
    time.sleep(waitper)
    
def select_file_in_file_explorer(parent_folder, filename, initial_delay=0.3, using_copy=False, nav_to_dir = True, tab_delay = 0.1, copy_delay = 0.01, parent_folder_delay = 0.05, file_name_delay = 0.05):
  # time.sleep(initial_delay)
  tryclickinguntilfound('new_folder.png', doclick=False)
  pyautogui.hotkey('alt', 'd')
  if nav_to_dir:
    time.sleep(parent_folder_delay)
    if not using_copy:
      pyautogui.write(parent_folder)
    else:
      orig = pyperclip.paste()
      pyperclip.copy(parent_folder)
      time.sleep(copy_delay)
      pyautogui.hotkey('ctrl', 'v')
      pyperclip.copy(orig)
    pyautogui.press('enter')
  time.sleep(file_name_delay)
  # tryclickinguntilfound('file name.png', xoff=30, confidence=0.99)
  for ii in range(6): # tab down to the "file name" field, as long as file explorer is in details view. If icons view, should only be 5 tabs, not six
    pyautogui.press('tab')
    time.sleep(tab_delay)
  if not using_copy:
    pyautogui.write(filename)
  else:
    orig = pyperclip.paste()
    pyperclip.copy(filename)
    time.sleep(copy_delay)
    pyautogui.hotkey('ctrl', 'v')
    pyperclip.copy(orig)
  pyautogui.press('enter')
  
def navigate_to_url(url, delay = 0.2, interval=0.05, using_copy=False, copy_delay = 0.01): # for use in chrome web browser, probably works in other browsers as well
  pyautogui.hotkey('alt', 'd', interval=interval)
  time.sleep(delay)
  if using_copy == False:
    pyautogui.write(url + "\n")
  else:
    orig = pyperclip.paste()
    pyperclip.copy(url)
    time.sleep(copy_delay)
    pyautogui.hotkey('ctrl', 'v')
    pyautogui.write("\n")
    pyperclip.copy(orig)
    
def guarantee_copy(text_to_copy, sleep_time=0.05, repeats=3):
  text_to_copy = str(text_to_copy)
  for ii in range(repeats):
    pyperclip.copy(text_to_copy)
    time.sleep(sleep_time)
    
    
if __name__ == '__main__':
  image_folder = 'imgs'
  set_folder(image_folder)
  os.chdir(os.path.dirname(__file__))
  
  ########################################
  ## VS Code / Python script AWS access ##
  ########################################
  
  subprocess.Popen(r'aws sso login --profile default')
  time.sleep(5.0)
  os.system(r'"send_hotkey.ahk" 2 f14 4') # move to primary monitor (4 = rightmost)
  
  time.sleep(1.5)
  tryclickinguntilfound('confirm.png')
  time.sleep(1.5)
  tryclickinguntilfound('allow.png')
  time.sleep(3.0)
  os.system(r'"send_hotkey.ahk" 2 f14 1') # move to leftmost monitor
  time.sleep(1.0)
  pyautogui.hotkey('ctrl', 'w')
  
  ############################
  ## Regular browser access ##
  ############################
  
  os.startfile(r'https://launcher.myapps.microsoft.com/api/signin/{some_key}?tenantId={another_key}') # link to single sign on through the browser goes here; should be bookmarked
  time.sleep(5.0)
  os.system(r'"send_hotkey.ahk" 2 f14 4') # move to primary monitor (4 = rightmost)
  
  time.sleep(1.5)
  tryclickinguntilfound('services_dropdown.png')
  time.sleep(1.5)
  tryclickinguntilfound('access.png')
  time.sleep(3.0)
  os.system(r'"send_hotkey.ahk" 2 f14 1') # move to leftmost monitor
  time.sleep(10.0)
  pyautogui.hotkey('ctrl', 'w')
  time.sleep(1.0)
  pyautogui.hotkey('ctrl', 'w')
