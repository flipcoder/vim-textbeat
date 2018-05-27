import vim,subprocess,os

DECADENCE_PATH = os.path.join(os.path.expanduser('~'),'bin','decadence')
DEVNULL = open(os.devnull, 'w')

class VimDecadencePlugin:
    def __init__(self):
        self.processes = []
        self.playing = False
    def stop(self):
        term = 0
        for p in self.processes:
            if not p.poll():
                p.terminate()
                term += 1
        return term
    def playpause(self):
        if self.stop():
            return
        self.processes.append(subprocess.Popen([\
            DECADENCE_PATH,\
            '+'+str(vim.current.window.cursor[0]),\
            vim.current.buffer.name\
        ], stdout=DEVNULL, stderr=DEVNULL))
    def playline(self):
        self.stop()
        self.processes.append(subprocess.Popen([\
            DECADENCE_PATH,\
            '-l',\
            vim.current.line\
        ], stdout=DEVNULL, stderr=DEVNULL))
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
# 
