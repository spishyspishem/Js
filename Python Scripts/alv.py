import time
import datetime
import threading
import re
from ctypes import windll
import psutil
import pyautogui
import keyboard
 
def get_time():
  return datetime.datetime.fromtimestamp(int(time.time()))
 
def kpalv():
  ES_CONTINUOUS = 0x80000000
  ES_DISPLAY_REQUIRED = 0x00000002
  flags = ES_CONTINUOUS | ES_DISPLAY_REQUIRED
  windll.kernel32.SetThreadExecutionState(flags)
  while True:
    print(f'Time: {get_time()}')
    time.sleep(60*60)
 
def kill_dell():
  while True:
    for proc in psutil.process_iter():
      if 'DPM.exe' in proc.name():
        print(get_time, ': Killing:', proc.name(), 'at PID', proc.pid)
        proc.terminate()
    time.sleep(3.0)
    break

def actpoll():
  POLL_FREQ = 5
  keyboard.start_recording()
  time.sleep(POLL_FREQ)
  while True:
    keypresses = keyboard.stop_recording()
    was_pressed = 1 if len(keypresses) > 0 else 0
    vl = pyautogui.position()
    pat = r'Point\(x=(.*), y=(.*)\)'
    ss = re.search(pat, str(vl))
    with open('actpoll.csv', 'a') as f:
      f.write(f'{int(time.time())},{ss.group(1)},{ss.group(2)},{was_pressed}\n')
    keyboard.start_recording()
    time.sleep(POLL_FREQ)

if __name__ == '__main__':
  t1 = threading.Thread(target=kpalv)
  t2 = threading.Thread(target=kill_dell)
  t3 = threading.Thread(target=actpoll)
  
  t1.start()
  t2.start()
  t3.start()
  
  t1.join()
  t2.join()
  t3.join()