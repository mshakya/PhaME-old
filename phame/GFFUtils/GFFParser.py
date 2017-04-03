"""Get coding and non-coding regions from GFF file."""

from __future__ import print_function
import sys
import argparse
import GFFFile
import GTFFile
import logging


def cmdline_parser():
    """Create an argparse instance."""
    parser = argparse.ArgumentParser(description=""""to parse GFF/GTF file to
        get coding and non coding sequences, corresponding files should have
        appropriate syntax, .gff/.gff3 for gff files and .gtf for gtf files""")
    parser.add_argument("-I", "--IN_GFF", help="""Path to GFF/GTF file""")
    parser.add_argument("-T", "--FEATURE", help="""Type of feature to extract
                        """)
    parser.add_argument("-F", "--FIELD", help="""List of Field (column) to
                        extract from gff/gtf. If the field is not recognized
                        then an empty column with just . is printed""")
    parser.add_argument("-O", "--OUT", default=None,
                        help="""Output file, if not specified
                        the output will be printed in the screen""")
    return parser


def main():
    """The main function."""
    parser = cmdline_parser()
    args = parser.parse_args()

    if args.IN_GFF.split(".")[-1] in ["GFF", "GFF3"]:
        try:
            get_regions(input_file=args.IN_GFF,
                        feature_type=args.FEATURE,
                        field_list=args.FIELD,
                        is_gff=True,
                        outfile=args.OUT)
        except TypeError:
            print("The file is not correctly formatted GFF or doesnt exist")

    elif args.IN_GFF.split(".")[-1] in ["GTF"]:
        try:
            get_regions(input_file=args.IN_GFF,
                        feature_type=args.FEATURE,
                        field_list=args.FIELD,
                        is_gff=False)
        except TypeError:
            print("The file is not correctly formatted GFF or doesnt exist")
    else:
        raise TypeError('The filename should have gff/gff3/gtf to indicate its type')


def get_regions(input_file, feature_type, field_list, is_gff, outfile=None):
    """ Extract desired Feature and Fields from GFF/GTF file."""
    feature_type = feature_type

    # Fields to report
    if field_list is None:
        field_list = None
    else:
        parsed_fields = []
        for field in field_list.split(','):
            if field == "chr" or field == "chrom":
                # Allow 'chr' and 'chrom' to be aliases for 'seqname'
                parsed_fields.append("seqname")
            else:
                parsed_fields.append(field)

    # Input file type
    if is_gff:
        file_iterator = GFFFile.GFFIterator
    else:
        file_iterator = GTFFile.GTFIterator

    # Output stream
    if outfile is None:
        fp = sys.stdout
    else:
        fp = open(outfile, 'w')

    # Null character (used when values are empty)
    null = '.'

    # Iterate through the file line-by-line
    for line in file_iterator(input_file):
        if line.type == GFFFile.PRAGMA:
            if line[0].startswith('##gff-version') and not is_gff:
                sys.stderr.write("Input file is GFF not GTF? Rerun using --gff option\n")
                sys.exit(1)
        elif line.type == GFFFile.ANNOTATION:
            if feature_type is None or line['feature'] == feature_type:
                # Extract and report data
                if parsed_fields is None:
                    print("%s" % line)
                else:
                    out_line = []
                    for field in parsed_fields:
                        try:
                            # Assume standard field
                            out_line.append(str(line[field]))
                        except KeyError:
                            # Not standard, try as an attribute name
                            try:
                                out_line.append(str(line['attributes'][field]))
                            except KeyError:
                                # Not an attribute either
                                out_line.append(str(null))
                    fp.write("%s\n" % '\t'.join(out_line))

    # Finished - close output file
    if outfile is not None:
        fp.close()


if __name__ == '__main__':
    logging.basicConfig(format="%(levelname)s: %(message)s")
    main()
