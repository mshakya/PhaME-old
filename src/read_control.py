"""
author: Nick Miller

This script reads in and parses the PhaME control file.
It will be used to provide information to other scripts in the pipeline

"""


class ParseFile:

    refdir = ""
    workdir = ""
    perldir = ""
    reference = ""
    reffile = ""
    project_name = ""
    cdsSNPS = ""
    FirstTime = ""
    data = ""
    reads = ""
    tree = ""
    modelTest = ""
    bootstrap = ""
    N = ""
    PosSelect = ""
    code = ""
    clean = ""
    threads = ""
    cutoff = ""

    def read_file(self):
        ####TODO add path to open phame.ctl

        control_file = open("phame.ctl", "r")

        for line in control_file:

            line = line.strip()
            if line:
                pass
            else:
                continue

            words = line.split()

            if words[0] == "refdir":
                refdir = line.split("=")[1].partition("#")[0].strip()
                ParseFile.refdir = refdir
            elif words[0] == "workdir":
                workdir = line.split("=")[1].partition("#")[0].strip()
                ParseFile.workdir = workdir
            elif words[0] == "perldir":
                perldir = line.split("=")[1].partition("#")[0].strip()
                ParseFile.perldir = perldir
            elif words[0] == "reference":
                reference = line.split("=")[1].partition("#")[0].strip()
                ParseFile.reference = int(reference)
            elif words[0] == "reffile":
                reffile = line.split("=")[1].partition("#")[0].strip()
                ParseFile.reffile = reffile
            elif words[0] == "project":
                project = line.split("=")[1].partition("#")[0].strip()
                ParseFile.project_name = project
            elif words[0] == "cdsSNPS":
                cdsSNPS = line.split("=")[1].partition("#")[0].strip()
                ParseFile.cdsSNPS = int(cdsSNPS)
            elif words[0] == "FirstTime":
                firsTime = line.split("=")[1].partition("#")[0].strip()
                ParseFile.FirstTime = int(firsTime)
            elif words[0] == "data":
                data = line.split("=")[1].partition("#")[0].strip()
                ParseFile.data = int(data)
            elif words[0] == "reads":
                reads = line.split("=")[1].partition("#")[0].strip()
                ParseFile.reads = int(reads)
            elif words[0] == "tree":
                tree = line.split("=")[1].partition("#")[0].strip()
                ParseFile.tree = int(tree)
            elif words[0] == "modelTest":
                modelTest = line.split("=")[1].partition("#")[0].strip()
                ParseFile.modelTest = int(modelTest)
            elif words[0] == "bootstrap":
                bootStrap = line.split("=")[1].partition("#")[0].strip()
                ParseFile.bootstrap = int(bootStrap)
            elif words[0] == "N":
                N = line.split("=")[1].partition("#")[0].strip()
                ParseFile.N = int(N)
            elif words[0] == "PosSelect":
                PosSelect = line.split("=")[1].partition("#")[0].strip()
                ParseFile.PosSelect = int(PosSelect)
            elif words[0] == "code":
                code = line.split("=")[1].partition("#")[0].strip()
                ParseFile.code = int(code)
            elif words[0] == "clean":
                clean = line.split("=")[1].partition("#")[0].strip()
                ParseFile.clean = int(clean)
            elif words[0] == "threads":
                threads = line.split("=")[1].partition("#")[0].strip()
                ParseFile.threads = int(threads)
            elif words[0] == "cutoff":
                cutoff = line.split("=")[1].partition("#")[0].strip()
                ParseFile.cutoff = int(cutoff)

            else:
                pass

        control_file.close()
