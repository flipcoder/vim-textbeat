import vim,subprocess,os
import select

DECADENCE_PATH = os.path.join(os.path.expanduser('~'),'bin','decadence')
DEVNULL = open(os.devnull, 'w')

class VimDecadencePlugin:
    def __init__(self):
        self.processes = []
        self.playing = False
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
        if self.stop():
            return
        vim.command('call dc#starttimer()')
        vim.command('set cursorline')
        print 'Playing'
        self.processes.append(subprocess.Popen([\
            DECADENCE_PATH,\
            '+'+str(max(0,vim.current.window.cursor[0]-1)),\
            vim.current.buffer.name\
        ],
            stdout=subprocess.PIPE, stderr=subprocess.PIPE,
            bufsize=1, universal_newlines=True
        ))
    def playline(self):
        self.stop()
        self.processes.append(subprocess.Popen([\
            DECADENCE_PATH,\
            '-l',\
            vim.current.line\
        ], stdout=DEVNULL, stderr=DEVNULL))
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
            print 'Stopped'
            vim.command('call dc#stoptimer()')
            vim.command('set cursorline&')
    def reload(self):
        for i in xrange(10): # first 10 lines check for header
            try:
                line = vim.current.buffer[i]
            except:
                return
            if line.startswith('%'):
                ctrls = line[1:].split(' ')
                for ctrl in ctrls:
                    if ctrl.startswith('c') or ctrl.startswith('C'):
                        cs = ctrl[1:].split(',')
                        if len(cs)==1: cs.append('0')
                        x = str(int(cs[0])+int(cs[1]))
                        if len(cs)>=2:
                            vim.command('let &l:colorcolumn = join(range('+\
                                x +',100,'+cs[0]+'),\',\')')
                            return


VimDecadence = VimDecadencePlugin()

