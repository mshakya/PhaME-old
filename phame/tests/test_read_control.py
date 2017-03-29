#! /usr/bin/env python
"""A test for control file readings."""
import sys
import unittest
sys.path.append('.')
from phame import ParseFile  # noqa


class TestParseFile(unittest.TestCase):
    """Test if control file is correctly parsed."""

    def test_read_file(self):
        """Test for control file parser."""
        control = ParseFile()
        control.read_file("phame/tests/files/phame.ctl")

        self.assertEqual(control.refdir, "/path/to/PhaME/test/ref")
        self.assertEqual(control.workdir, "/path/to/PhaME/test")
        self.assertEqual(control.reference, 1)
        self.assertEqual(control.project_name, "ebola_test")
        self.assertEqual(control.cdsSNPS, 1)
        self.assertEqual(control.FirstTime, 1)
        self.assertEqual(control.data, 3)
        self.assertEqual(control.reads, 2)
        self.assertEqual(control.tree, 1)
        self.assertEqual(control.modelTest, 0)
        self.assertEqual(control.bootstrap, 1)
        self.assertEqual(control.PosSelect, 2)
        self.assertEqual(control.N, 100)
        self.assertEqual(control.code, 1)
        self.assertEqual(control.clean, 0)
        self.assertEqual(control.threads, 4)
        self.assertEqual(control.cutoff, 0)


# class Test
if __name__ == '__main__':
    unittest.main()
