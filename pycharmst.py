from pywinauto.application import Application
import os
import subprocess
import time
import pywinauto
import psutil
from pywinauto.controls.hwndwrapper import HwndWrapper
def open_new_proc(filename):

    process = subprocess.Popen([r"C:\Program Files\JetBrains\PyCharm Community Edition 2022.3.3\bin\pycharm64.exe" ,filename])


    # print("PyCharm PID:", process.pid)
    # Wait for PyCharm to start
    # time.sleep(4)
    return 
    # Connect to the PyCharm window
# pycharm = app.window(title_re=".*pycharmst.py.*")
# Send the F5 key to start debugging
# pycharm.type_keys("{F5}")
def get_pycharm_processes():
    pycharm_processes = []

    for proc in psutil.process_iter(['pid', 'name']):
        try:
            if 'pycharm' in proc.name().lower():
                pycharm_processes.append(proc.pid)
        except (psutil.NoSuchProcess, psutil.AccessDenied, psutil.ZombieProcess):
            pass

    return pycharm_processes
def get_all_titles():
    d={} 
    for k in get_pycharm_processes():
        for hwnd in pywinauto.findwindows.find_windows(class_name="SunAwtFrame",process=k):
            pycharm_window = HwndWrapper(hwnd)
            title = pycharm_window.window_text()
            d[title]=(k,pycharm_window )
    return d 

def run_debug_project(project_name,file_name,sec_time=False):
    b=os.path.basename(file_name)
    dic= get_all_titles()
    for k,v in dic.items():
        #the if with lower 
        #if project_name in k or os.path.basename(file_name) in k:
        if project_name.lower() in k.lower() or b.lower() in k.lower():
            select_file(b, v)
            break 
    else:
        if sec_time:
            print("error, couldnt open")
            return 
        print("project not found")
        open_new_proc(file_name)
        run_debug_project(project_name,file_name,sec_time=True)


def select_file(b, v):
    app = Application().connect(process=v[0])
    v = v[1]
    v.set_focus()
    app.wait_cpu_usage_lower(2.5)
    # type double shift and then the file name
    v.type_keys("{VK_SHIFT down}{VK_SHIFT up}{VK_SHIFT down}{VK_SHIFT up}")
    app.wait_cpu_usage_lower(2.5)
    v.type_keys(b)
    app.wait_cpu_usage_lower(2.5)
    # wait for idle
    v.type_keys("{ENTER}")


def select_line(line, v):
    app = Application().connect(process=v[0])
    v = v[1]
    v.set_focus()
    app.wait_cpu_usage_lower(24)
    v.type_keys("{VK_CONTROL down}G{VK_CONTROL up}")
    app.wait_cpu_usage_lower(9)
    w=app.top_window()
    w.type_keys(str(line))
    w.type_keys("{ENTER}")





# run_debug_project("mypy-gpt",r"C:\gitproj\mypy-gpt\gpt_linter\gptlinter.py")
# run_debug_project("compare-my-stocks",r"c:\Users\ekarni\compare-my-stocks\src\compare_my_stocks\processing\datagenerator.py")
def gotoline(file,line):
    fn = os.path.basename(file)
    open_new_proc(file)
    # run_debug_project("compare-my-stocks",r"c:\Users\ekarni\compare-my-stocks\src\compare_my_stocks\processing\datagenerator.py")
    for k in range(10):
        dic= get_all_titles()
        for k,v in dic.items():
            #the if with lower 
            #if project_name in k or os.path.basename(file_name) in k:
            if fn.lower() in k.lower():
                select_line(line,v)
                return  
        time.sleep(1)

import sys
gotoline(sys.argv[1],int(sys.argv[2]))

# print(list(get_all_titles()))
