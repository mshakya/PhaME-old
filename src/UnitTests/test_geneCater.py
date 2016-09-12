from unittest import TestCase
import src.catAlign
import os


class TestGeneCater(TestCase):
    def test_get_files(self):

        filename = "/Users/nick/PycharmProjects/PhaME/test/ref/KJ660347.fasta"
        directory = "/Users/nick/PycharmProjects/PhaME/src/"

        test_genecater_obj = src.catAlign.GeneCater()
        test_genecater_obj.get_files(filename, directory)

        flag = False

        if os.path.exists(directory+"all_reference_combined.fa"):
            flag = True

        assert flag == True

        # use to quickly remove the file
        self.clean()

    def clean(self):

        directory = "/Users/nick/PycharmProjects/PhaME/src/all_reference_combined.fa"

        os.remove(directory)
