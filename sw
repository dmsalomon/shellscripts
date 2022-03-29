#!/usr/bin/env python3

from datetime import datetime
from time import sleep
import sys
import termios

CR = "\r\033[K" # ]

class TerminalState:
    def __init__(self, pty=None):
        self.pty = pty or 0 # 0 for STDIN_FILENO
        self.flags = termios.tcgetattr(self.pty)
        self._restored = False

    def echoctl_off(self):
        flags = self.flags.copy()
        flags[3] &= ~termios.ECHOCTL
        termios.tcsetattr(self.pty, termios.TCSADRAIN, flags)

    def restore(self):
        if not self._restored:
            termios.tcsetattr(self.pty, termios.TCSADRAIN, self.flags)
            self._restored = True

    def __del__(self):
        self.restore()

def main():
    start = datetime.now()
    while True:
        now = datetime.now()
        delta = now - start
        sys.stdout.write(f"{CR}{delta}")
        sleep(0.005)

if __name__ == "__main__":
    term_state = TerminalState()
    try:
        term_state.echoctl_off()
        main()
    except KeyboardInterrupt:
        pass
    finally:
        print()

