from unittest import TestCase
import src.read_control


class TestParseFile(TestCase):

    def setUp(self):
        config_file = open("phame.ctl", "r")
        return config_file

    def test_read_file(self):
        control = src.read_control.ParseFile()
        control.read_file()

        assert control.refdir == "/path/to/PhaME/test/ref"
        assert control.workdir == "/path/to/PhaME/test"
        assert control.reference == 1
        assert control.project_name == "ebola_test"
        assert control.cdsSNPS == 1
        assert control.FirstTime == 1
        assert control.data == 3
        assert control.reads == 2
        assert control.tree == 1
        assert control.modelTest == 0
        assert control.bootstrap == 1
        assert control.N == 100
        assert control.PosSelect == 2
        assert control.code == 1
        assert control.clean == 0
        assert control.threads == 4
        assert control.cutoff == 0






