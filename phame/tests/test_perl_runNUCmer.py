#! /usr/bin/env python
"""A test for gene concatenation."""
from __future__ import print_function
import unittest
import subprocess
import os


class TestGeneCater(unittest.TestCase):
    """Test gene concatenation."""

    def test_runucmer(self):
        """Test 1."""
        subprocess.call(["rm", "-rf", "phame/tests/runNUCmer_test"])

        run = subprocess.call(["perl", "perl_scripts/runNUCmer.pl",
                               "-c", "virus",
                               "-q", "phame/tests/files",
                               "-d", "phame/tests/runNUCmer_test",
                               "-t", "4",
                               "-l",
                               "phame/tests/files/fasta_filelist.txt", ])
        self.assertEqual(run, 0)

    def test_output_gaps(self):
        """Test gaps file."""
        gaps_path = "phame/tests/runNUCmer_test/gaps/"
        gaps_file1 = gaps_path + "ZEBOV_2007_23Luebo_ZEBOV_2007_4Luebo.gaps"
        gaps_file2 = gaps_path + "KJ660347_ZEBOV_2002_Ilembe.gaps"
        self.assertEqual(os.stat(gaps_file1).st_size, 0)
        self.assertEqual(os.stat(gaps_file2).st_size, 0)

    def test_output_delta(self):
        """Test delta files."""
        delta_path = "phame/tests/runNUCmer_test/delta/"
        delta_file1 = delta_path + "KJ660347_ZEBOV_2002_Ilembe.delta"
        delta_file2 = delta_path + "ZEBOV_2007_0Luebo_KJ660347.delta"
        with open(delta_file1, 'r') as df1:
            next(df1)
            second_line = next(df1)
        self.assertEqual(second_line, 'NUCMER\n')
        with open(delta_file2, 'r') as df2:
            next(df2)
            second_line = next(df2)
        self.assertEqual(second_line, 'NUCMER\n')

    def test_output_snps(self):
        """Test snps files."""
        snp_path = "phame/tests/runNUCmer_test/snps/"
        snp_file1 = snp_path + "ZEBOV_2002_Ilembe_ZEBOV_2007_0Luebo.snps"
        snp_file2 = snp_path + "ZEBOV_2007_23Luebo_ZEBOV_2007_4Luebo.snps"
        with open(snp_file1, 'r') as sf1:
            for _ in xrange(4):
                next(sf1)
            fourth_line_no = next(sf1).split("\t")[0]
        self.assertEqual(fourth_line_no, '133')
        with open(snp_file2, 'r') as sf2:
            for _ in xrange(4):
                next(sf2)
            fourth_line_no = next(sf2).split("\t")[0]
        self.assertEqual(fourth_line_no, '4733')

    def test_output_filters(self):
        """Test filter files."""
        filter_path = "phame/tests/runNUCmer_test/filters/"
        gap_filter1 = filter_path + "KJ660347_ZEBOV_2007_4Luebo.gapfilter"
        gap_filter2 = filter_path + "ZEBOV_2007_23Luebo_ZEBOV_2007_0Luebo.gapfilter"
        snp_filter1 = filter_path + "ZEBOV_2007_0Luebo_ZEBOV_2007_23Luebo.snpfilter"
        snp_filter2 = filter_path + "KJ660347_ZEBOV_2002_Ilembe.snpfilter"
        gf1 = return_line(gap_filter1, 3).split(" ")[0]
        gf2 = return_line(gap_filter2, 3).split(" ")[0]
        sf1 = return_line(snp_filter1, 3).split(" ")[0]
        sf2 = return_line(snp_filter2, 3).split(" ")[0]
        self.assertEqual(gf1, '1')
        self.assertEqual(gf2, '1')
        self.assertEqual(sf1, '1')
        self.assertEqual(sf2, '1')

    def test_output_stats(self):
        """Test stats files."""
        coords_path = "phame/tests/runNUCmer_test/stats/"
        coords_file1 = coords_path + "ZEBOV_2002_Ilembe_ZEBOV_2007_0Luebo.coords"
        coords_file2 = coords_path + "ZEBOV_2007_23Luebo_ZEBOV_2007_0Luebo.coords"
        rep_stats = coords_path + "repeat_stats.txt"
        cf1 = return_line(coords_file1, 4).split("\t")[0]
        cf2 = return_line(coords_file2, 4).split("\t")[0]
        rs = return_line(rep_stats, 13).split("\t")[1]
        self.assertEqual(cf1, '1')
        self.assertEqual(cf2, '1')
        self.assertEqual(rs, '18958\n')


def return_line(filename, num):
    """Print line number `num` from a file `filename`."""
    with open(filename, 'r') as f:
        for _ in xrange(num):
            next(f)
        line = next(f)
    return line

if __name__ == '__main__':
    unittest.main()
