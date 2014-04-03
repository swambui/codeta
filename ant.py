import subprocess
import zipfile
import ant

zipfile = open('build.xml', 'w')
p = subprocess.Popen('call ant compile', shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
for line in p.stdout.readlines(): 
    zipfile.write(line) 
retval = p.wait()

