
"""
author: Nick Miller

script translates a nucleotide sequence to an amino acid sequence
"""

#TODO set up read file and pass codons to check if they are in dictionary


class Translate:

    def __init__(self):
        pass
        #creat class vars here
        #requires id, values, seq, length, dna, start, index, codon, codlen

    def read_codon(self):
        pass



    def translate_codon(self, codon):

        aa_table = {"AAA":"K", "AAC":"N", "AAG":"K", "AAT":"N", "ACA":"T", "ACC":"T", "ACG":"T", "ACT":"T", "AGA":"R", "AGC":"S", "AGG":"R", "AGT":"S", "ATA":"I", "ATC":"I", "ATG":"M", "ATT":"I", "CAA":"Q", "CAC":"H", "CAG":"Q",
                    "CAT":"H", "CCA":"P", "CCC":"P", "CCG":"P", "CCT":"P", "CGA":"R", "CGC":"R", "CGG":"R", "CGT":"R", "CTA":"L", "CTC":"L", "CTG":"L", "CTT":"L", "GAA":"E",
                    "GCG":"A", "GCT":"A", "GAC":"D", "GAG":"E", "GAT":"D", "GCA":"A", "GCC":"A", "GGA":"G",  "GGG":"G", "GGT":"G", "GTA":"V", "GGC":"G",
                    "GTC":"V", "GTG":"V", "GTT":"V", "TAC":"Y", "TAT":"Y", "TCA":"S", "TCC":"S", "TCG":"S", "TCT":"S", "TGC":"C", "TGG":"W", "TGT":"C", "TTA":"L", "TTC":"F", "TTG":"L", "TTT":"F", "TAA":"*", "TAG":"*", "TGA":"*",
                    "AAR":"K", "AAS":"X", "AAY":"N", "ACN":"T", "ACR":"T", "ACY":"T", "AKC":"X", "AKT":"X", "AMT":"X", "ARA":"X", "ARC":"X", "ART":"X", "AST":"X", "ATR":"X", "ATY":"I", "AYT":"X", "CAK":"X", "CAN":"X", "CAR":"Q",
                    "CCK":"P", "CCN":"P", "CGM":"R", "CGN":"R", "CGK":"R", "CGY":"R", "CKM":"X", "CMA":"X", "CMC":"X", "CTY":"L", "CVC":"X", "CWG":"X", "CYG":"X", "CYT":"X", "DAG":"X", "GAK":"X", "GAN":"X", "GAR":"E", "GAS":"X",
                    "GAY":"D", "GCN":"A","GCR":"A" , "GCS":"A", "GCY":"A", "GGK":"G", "GGY":"G", "GKA":"X", "GMT":"X", "GNT":"X", "GRC":"X", "GSG":"X", "GST":"X", "GTS":"V", "GTW":"V", "GTY":"V", "GYG":"X", "GYT":"X", "KAA":"X",
                    "KAG":"X", "KCC":"X", "KGC":"X", "MTC":"X", "MTG":"X", "MTT":"X", "NAC":"X", "NTG":"X", "RAA":"X", "RAC":"X", "RAG":"x", "RAT":"X", "RAW":"X", "RCG":"X", "RGC":"X", "RGT":"X", "RTA":"X", "RTC":"X", "RTG":"X",
                    "RTT":"X", "SAG":"X", "SCC":"X", "SGT":"X", "SGS":"X", "SGY":"X", "STG":"x", "TCM":"S", "TCR":"S", "TGM":"X", "TGY":"C", "TST":"X", "TTN":"X", "TTS":"X", "TTW":"X", "TTY":"X", "TWC":"X", "TWG":"X", "WAA":"X",
                    "WTT":"X", "YGT":"X", "YTC":"X", "YTG":"X", "YTY":"X"}

        if codon in aa_table:
            return aa_table[codon]
        else:
            print str(codon) + " is not an Amino Acid. "
            return " "







