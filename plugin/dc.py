from __future__ import print_function
import vim,subprocess,os,select

class VimDecadencePlugin:
    DEVNULL = open(os.devnull, 'w')
    
    def set_python(self,p):
        self.PYTHON = os.path.expanduser(p)
    
    def set_dc_path(self,p):
        self.DC_PATH = os.path.expanduser(p)

    def check_paths(self):
        if not self.PYTHON or not self.DC_PATH:
            print("vim-decadence: in your .vimrc, set the locations:")
            print("   let g:decadence_python = '/usr/bin/python2'")
            print("   let g:decadence_path = '~/bin/decadence/decadence.py'")
            print("In the future, this will be automatic.")
            return False
        return True

    def __init__(self):
        self.processes = []
        self.playing = False
        self.PYTHON = None
        self.DC_PATH = None
        
    def stop(self):
        term = 0
        for p in self.processes:
            if p.poll()==None:
                try:
                    p.terminate()
                except:
                    pass
                term += 1
        self.processes = []
        return term
    def refresh(self):
        self.processes = filter(lambda p: p.poll()!=None, self.processes)
    def play(self):
        if not self.check_paths(): return
        if self.stop():
            return
        vim.command('call dc#starttimer()')
        vim.command('set cursorline')
        print('Playing')
        self.processes.append(subprocess.Popen([\
            self.PYTHON,\
            self.DC_PATH,\
            '--follow',
            '+'+str(max(0,vim.current.window.cursor[0]-1)),\
            vim.current.buffer.name\
        ],
            stdout=subprocess.PIPE, stderr=subprocess.PIPE,
            bufsize=1, universal_newlines=True
        ))
    def playline(self):
        if not self.check_paths(): return
        self.stop()
        self.processes.append(subprocess.Popen([\
            self.PYTHON,\
            self.DC_PATH,\
            '-l',\
            vim.current.line\
        ], stdout=self.DEVNULL, stderr=self.DEVNULL))
    def poll(self):
        running = 0
        done = False
        active = 0
        for p in self.processes:
            working = False
            if p.poll()==None:
                active += 1
            while True:
                sel = None
                try:
                    sel = select.select([p.stdout],[],[],0)
                    if not sel or not sel[0]:
                        break
                except:
                    break
                buf = p.stdout.read(1)
                if not buf:
                    break
                if buf=='\n':
                    vim.command('normal! '+str(buf.count('\n'))+'j')
                working = True
            if working:
                running += 1
        if not active:
            print('Stopped')
            vim.command('call dc#stoptimer()')
            vim.command('set cursorline&')
    def reload(self):
        for i in xrange(2): # first 2 lines check for header
            try:
                line = vim.current.buffer[i]
            except:
                return
            if line.startswith('%'):
                ctrls = line[1:].split(' ')
                for ctrl in ctrls:
                    if ctrl.startswith('c') or ctrl.startswith('C'):
                        ctrl = ctrl[1:]
                        if ctrl[0]=='=':
                            ctrl = ctrl[1:]
                        cs = ctrl.split(',')
                        if len(cs)==1: cs.append('0')
                        x = str(int(cs[0])+int(cs[1]))
                        if len(cs)>=2:
                            vim.command('let &l:colorcolumn = join(range('+\
                                x +',100,'+cs[0]+'),\',\')')
                            return


VimDecadence = VimDecadencePlugin()

