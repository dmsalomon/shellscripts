#!/usr/bin/env python3

from datetime import datetime
from time import sleep
import sys
from termios import tcgetattr, tcsetattr, TCSADRAIN
import termios
from contextlib import contextmanager

CR = "\r\033[K"  # ]


@contextmanager
def no_echoctl(*, pty=None):
    pty = pty or 0  # 0 for STDIN_FILENO
    oflags = tcgetattr(pty)
    flags = oflags.copy()
    flags[3] &= ~termios.ECHOCTL
    tcsetattr(pty, TCSADRAIN, flags)
    try:
        yield
    finally:
        tcsetattr(pty, TCSADRAIN, oflags)


def main():
    start = datetime.now()
    while True:
        now = datetime.now()
        delta = now - start
        sys.stdout.write(f"{CR}{delta}")
        sleep(0.005)


if __name__ == "__main__":
    with no_echoctl():
        try:
            main()
        except KeyboardInterrupt:
            pass
        finally:
            print()
