#!/usr/bin/env python
"""
     Distrivia Test Runner
    ~~~~~~~~~~~~~~~~~~~~~~~
    A cool test runner for the unit tests.

    :copyright: (c) 2011 by Brian Gianforcaro, Steven Glazer, Sam Milton.
"""


from flaskext.script import Manager
from flaskext.zen import Test, ZenTest
from distrivia import app

manager = Manager(app)

manager.add_command( 'test', Test() )
manager.add_command( 'zen', ZenTest() )

if __name__ == '__main__':
    manager.run()
