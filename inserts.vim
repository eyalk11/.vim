" Saves the last inserts you typed or copied globally (by buffers and time).
" Allows you to fetch the last 1000 inserts for any buffer using FZF
"Need to fill let g:vimloc -  location to save inserts.cache
"requires fzf.vim 
" to use call EnableTrackInserts on .vimrc 
"

function! EnableTrackInserts()
    :autocmd TextYankPost * call SaveLastCopy()
    :autocmd InsertLeave * call SaveLastInsert()
    :au VimEnter * nested call LoadBaseInserts(0)
endfunction 
function! LoadBaseInserts(pr)
py3 << EOF
import vim
import pickle
from collections import defaultdict
import datetime
import time
maxtimespan=datetime.timedelta(days=5)
bufslasttwentysec=defaultdict(lambda: 0)
maxloadtime=3
lastmin = 0 
try:
    st = time.time()
    input = open(vim.eval('g:vimloc')+'\\inserts.cache', 'rb')
    inserts=pickle.load(input)
    endt= time.time()
    loadtime=endt-st
    dt=datetime.datetime.now()

    if (loadtime> maxloadtime) or (vim.eval('a:pr')==1):
        print('trimming loadtime is %s' % (loadtime))
        n=0
        for bufn,v in inserts.items():
            for t,l in v[0]:
                n+=1
                if (dt-datetime.datetime.fromtimestamp(t))>maxtimespan:
                    a,b=inserts[bufn][0].popleft() 
                    inserts[bufn][1].remove(b)
        print('total inserts is %s' % (n))

except:
    import traceback
    traceback.print_exc()
    vim.command('echom "failed loading inserts"')
    inserts={}
EOF
endfunction
"insert tracking aaaa
py3<<EOF
import re
def returninsertsforbufn(breaklines):
    bufname=vim.eval("g:bufn")
    if not bufname in inserts:
        return {}
    z=list(inserts[bufname][0])
    if breaklines:
        z=list(breakl(z))
    z=filter(lambda x: filterinp(x[1]),z)
    return {x:y for (y,x) in  z}
def returnallinserts(selectedbufs=None):
    from functools import reduce
    if selectedbufs:
        vals=[inserts[x] for x in selectedbufs if x in inserts]
    else:
        vals=list(inserts.values())
    z=reduce(lambda x,y:x+y, map(lambda x: list(x[0]),vals))
    z=filter(lambda x: filterinp(x[1]),z)
    return {x:y for (y,x) in  z}
def breakl(z):
    for x in z:
        ls=x[1].split('\n')
        yield from zip([x[0]]*len(ls),ls)
def filterinp(x):
    if len(x)==0:
        return False 
    if re.match('^\s+$',x):
        return False
    return ( re.search('\w\w\w',x) and isascii(x) )
def isascii(s):
    """Check if the characters in string s are in ASCII, U+0-U+7F."""
    return len(s) == len(s.encode(errors='ignore'))
EOF
function! SaveLastInsert()
    if !exists("b:save_inserts")
        let b:save_inserts=1
    endif 
    if !(b:save_inserts==1)
        return 
    endif 
    if mode()=='c'
        return
    endif

    call AddInsert(@.)
    "endif
endfunction

function! SaveLastCopy()
    let reg= v:event['regname']
    "echo v:event['regcontents']
    if !exists("b:save_inserts")
        let b:save_inserts=1
    endif 
     if (b:save_inserts==0)
         return 
     endif 
    call AddInsert(getreg(reg))
endfunction

function! AddInsert(str)
    if len(a:str)>5000
        return
    endif
    call AddInsertInternal(a:str)
endfunction
function! AddInsertInternal(str)
py3 <<EOF
bufn=vim.eval('expand("%:p")')
import datetime
dt= datetime.datetime.now()
sec=dt.second
if dt.minute != lastmin:
    bufslasttwentysec= defaultdict(lambda: 0)
    lastmin=dt.minute
bufslasttwentysec[sec // 5 ]+=1
toexit= ( bufslasttwentysec[sec // 5 ] > 100) #more than 20 in 5 sec slot
EOF
if py3eval('toexit')
    if exists('g:restartinsertwatch')
        if len(timer_info(g:restartinsertwatch))>0
            return
        endif 
    endif
    :autocmd! InsertLeave *
    :autocmd! TextYankPost *
    let g:restartinsertwatch=timer_start(20000,'EnableTrackInserts',{'repeat':1})
    :echo 'pause inserts'
    return
endif
let strt = substitute(a:str,"\<BS>",'\n','g')
py3 insertfunc(vim.eval('strt'))
endfunction
function! CleanIns()
    py3 inserts={}
call SaveInsertsFunc('')
endfunction 
PY << EOF
from collections import deque
def insertfunc(mystr):
    import re
    if not filterinp(mystr):
        return
    bufn=vim.eval('expand("%:p")')
    if bufn in inserts:
        if len(inserts[bufn][0])>1000:
            a,b=inserts[bufn][0].popleft() 
            inserts[bufn][1].remove(b)
    else:
        inserts[bufn]=(deque(),set())
    if mystr in inserts[bufn][1]:
        return 
    inserts[bufn][0].append((round(datetime.datetime.now().timestamp()) ,mystr))
    inserts[bufn][1].add(mystr)
EOF
function! RecallInserts(break)
    let g:bufn=fnamemodify(bufname('%'),":p")
    if a:break 
    let t=py3eval( 'returninsertsforbufn(1)')
else 
    
    let t=py3eval( 'returninsertsforbufn(0)')
endif
    let ls=sort((keys(t)), {arg2, arg1 -> t[arg1] - t[arg2]})
    :call fzf#run({'source': ls ,'sink':function('PInsert'),'options': '-m'})
endfunction

function! GetAllInserts()
    "not efficient but who cares
    let ls=py3eval( 'returnallinserts()')
    let ls=sort(keys(ls), {arg2, arg1 -> ls[arg1] - ls[arg2]})
    :call fzf#run({'source': ls,'sink':function('PInsert2'),'options': '-m'})
endfunction

function! GetAllInsertsForCurrentBufs()
    "not efficient but who cares
    let ls=[]
    let lastbuf=bufnr('$')
    for i in range(lastbuf)
        let bufn=fnamemodify(bufname(i),":p")
        if bufn!=''
            call add(ls,bufn)
        endif
    endfor
    let g:bufl=ls
    let ls=py3eval( 'returnallinserts(vim.eval("g:bufl") )')
    let ls=sort(keys(ls), {arg2, arg1 -> ls[arg1] - ls[arg2]})
    :call fzf#run({'source': ls,'sink':function('PInsert2'),'options': '-m'})
endfunction

function! PInsert2(item)
    let @z=a:item
    norm "zp
    call feedkeys('a')
endfunction

function! PInsert(item)
    let @z=a:item
    norm "zp
endfunction
