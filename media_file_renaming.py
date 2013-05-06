#!/usr/bin/env python2.6
import os, sys
from optparse import OptionParser

parser = parser=OptionParser()
parser.add_option("-p", "--path", dest = "path", type = "string", 
    help = "path to the directory containing the files to rename")
parser.add_option("-o", "--option", dest = "pendtype", type = "string", 
    help = "designate whether to prepend or append to filename")
parser.add_option("-t","--text", dest = "pend_text", type = "string", 
    help = "the text to append/prepend or remove from the files")
parser.add_option("-e", "--extension", action = "store_true", dest = "e", 
    default = False, help = "if wanting to remve an extenion, flag must be true" )
parser.add_option("-i", "--increment", action = "store_true", dest = "i",
    default = False, help = "if you want to add an incrementing number, flag must be true")

(options, args)=parser.parse_args()

option_types = {
    'append' : 'a',
    'prepend' : 'p',
    "remove" : "r"
}
append = option_types['append']
prepend = option_types['prepend']
remove = option_types['remove']
Usage = "Usage: " + sys.argv[0] + " [-o {prepend, append, remove}] "\
    "[-t text_to_pend] [-p directory_folder] [-e] [-i]"
pendtype = options.pendtype
pend_text = options.pend_text
path = options.path
increment = 0

def main(argv):
    ###  Check command arguments/settings
    global path, pendtype, pend_text
    error = False
    cwd = os.getcwd()+"/"

    print "** This script will append or prepend a string "
    print "** to a file name recursively in the given directory"

    # get path to files that will be edited.  Verify exists
    ask = "~ What directory are the files to be renamed in? "
    if path and not os.path.isdir(path):
        error = True
        ask = "~ "+path+" does not exisit. \n" + ask
    if error or not path:
        path = str(raw_input(ask))
        error = False
    if not os.path.isdir(path):
        print "~ The path " + path + " provided by the user does not exist. Please run again."
        exit(0) 

    # get pendtype and determine if accepted
    ask = "~ Do you want to prepend, append or remove text from the filename? "
    if pendtype and not is_accepted_type(pendtype):
        error = True
        ask = "~ "+pendtype+" is not an excepted option. \n" + ask
    if error or not pendtype:
        pendtype = str(raw_input(ask))
        error = False
    if not is_accepted_type(pendtype):
        print "~ The option " + pendtype + " is not accepted. Please run again."
        exit(0)

    # get text to attach/remove
    if not pend_text:
        pend_text = str(raw_input("~ What text will I "+get_type()+"? "))

    # echo to user the inputs receieved
    add = ""
    if options.e:
        add += " extension"
    if options.i:
        add += " incrementally in 2 digits"
    print "- " + get_type() + add + " '" + pend_text +"' "+get_toFrom()+" files in '" + path + "'\n"
    cont = raw_input("~ If above is correct, press Enter to continue.  \n"\
            "~ Otherwise, please enter q ")
    if str(cont) == "q":
        exit(0)

    # start the renaming!!
    recursive_walk(path)
    print ""
    
def get_toFrom():
    if pendtype.startswith(remove):
        return "from"
    else:
        return "to"

def get_type():
    if pendtype.startswith(prepend):
        return "prepend"
    elif pendtype.startswith(append):
        return "append"
    elif pendtype.startswith(remove):
        return "remove"
    else:
        return False

def is_accepted_type(txt):
    global append, prepend, remove
    return (txt.startswith(prepend) or txt.startswith(append) or txt.startswith(remove))

def need_pend_text(type):
    global append, prepend
    return (type.startswith(prepend) or type.startswith(append))

def recursive_walk(this_path):
    global increment
    this_path, dirs, files = os.walk(this_path).next()
    files.sort()
    dirs.sort()
    this_path += "/"

    print "- " + this_path
    for f in files:
        increment += 1
        change_name(f, this_path)

    for d in dirs:
        increment = 0
        recursive_walk(this_path+d)

def change_name(f, this_path):
    global options, pend_text
    this_pend_text = pend_text
    if options.i:
        if increment < 10:
            this_pend_text += "0"
        this_pend_text += str(increment)
    full_path = this_path + f
    filename, ext = os.path.splitext(f)
    new_name = ''
    if pendtype.startswith(prepend):
        # (text)filename.ext
        new_name = this_pend_text + filename + ext
        new_name_path = this_path + new_name
    elif pendtype.startswith(append): 
        # filename(text).ext
        new_name = filename + this_pend_text + ext
        new_name_path = this_path + new_name
    elif pendtype.startswith(remove):
        if not options.e:
            # filename.ext -> file.ext
            new_name = filename.replace(this_pend_text, "") + ext
            new_name_path = this_path + new_name 
        else:
            if not pend_text.startswith("."):
                this_pend_text = "." + this_pend_text
            new_name = filename + ext.replace(this_pend_text, "")
            new_name_path = this_path + new_name 
    
    if full_path != new_name_path:
        if os.path.exists(new_name_path):
            print "~~ there is an error, the file '" + new_name_path + "' already exists"
            exit(1)

        print "-- mv " + full_path + " " + new_name_path
        os.renames(full_path, new_name_path)  


main(sys.argv)