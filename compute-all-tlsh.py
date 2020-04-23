# Requirements
#   - TLSH python extension, see https://github.com/trendmicro/tlsh
#
# Usage
#   $ preston verify | parallel --progress "echo {} | python preton-tlsh.py" > hash-tlsh.nq

import sys
import tlsh

for line in sys.stdin:
	vals = line.split()
	(file_id, file_path) = vals[:2]

	if file_path[:5] == "file:":
		file_path = file_path[5:]
	
	tlsh_hash = "hash://tlsh/" + tlsh.hash(open(file_path, 'rb').read())
	print("%s\t%s" % (file_id, tlsh_hash))
